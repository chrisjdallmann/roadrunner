% EPHYS_TRANSITION_ANALYSIS.m aligns electrophysiology and treadmill data to movement onset or offset 
% 
% Files required: 
%    data.mat

% Author: Chris J. Dallmann 
% Affiliation: University of Wuerzburg
% Last revision: 19-August-2025

% ------------- BEGIN CODE -------------

clear
clc

% Load data
dataset = 'treadmill_ephys_rr_gfp_walking.mat';
load(['Z:\Data\Roadrunner\',dataset])

% Set parameters
n_transitions_min = 3;
transition_type = 'onset';
parameter_name = 'spike_rate'; 
parameter_source = 'ephys'; % 'ephys', 'treadmill'
pre_window = 1; % s
post_window = 1; % s
plot_type = 'time_series'; % 'mean', 'time_series'
subtract_baseline = false;
baseline_win = 0.5; % s, from beginning of pre_window

% Initialize variables
sampling_rate_ephys = 20000; % Hz 
sampling_rate_treadmill = 50; % Hz

parameter_all = []; 
recordings = 1:numel(data);
animal_ids = [];
for recording = recordings
    animal_ids = [animal_ids; data(recording).animal_id];
end 
trials = [];
for recording = recordings
    trials = [trials; data(recording).trial];
end 
time_to_transition = [];


% Loop over animals
for n_animal = 1:numel(unique(animal_ids))
    % Initialize variables
    animal_id = unique(animal_ids);
    animal_id = animal_id(n_animal);

    trials_animal = trials(animal_ids==animal_id)';
    parameter_animal = [];

    % Loop over trials
    for n_trial = 1:numel(trials_animal)
        trial = trials_animal(n_trial);
        recording = find(animal_ids==animal_id & trials==trial);

        % Get data
        if strcmp(parameter_name,'membrane_potential_smoothed')
            width = 0.02; % s
            data(recording).membrane_potential_smoothed = smooth(data(recording).membrane_potential, width*sampling_rate_ephys);
        end

        % Get movement onset and offset indices
        onset_indices = find(diff(data(recording).movement)>0)+1;
        offset_indices = find(diff(data(recording).movement)<0)+1;
    
        % Get transition indices
        if strcmp(transition_type, 'onset') 
            transition_indices = onset_indices;
            other_indices = offset_indices;
        else 
            transition_indices = offset_indices;
            other_indices = onset_indices;
        end
        
        % Exclude transitions where there is not enough data or another
        % transition in the pre or post window
        n_frames = numel(data(recording).time_ephys);
        transitions_to_exlude = [];
        for transition = 1:numel(transition_indices)
            transition_window_start = transition_indices(transition) - pre_window*sampling_rate_ephys;
            transition_window_end = transition_indices(transition) + post_window*sampling_rate_ephys;
            
            if (transition_window_start < 0) ...
                    || (transition_window_end > n_frames) ...
                    || any(other_indices >= transition_window_start & other_indices <= transition_window_end)
    
                transitions_to_exlude = [transitions_to_exlude; transition];
            end
        end
        transition_indices(transitions_to_exlude) = [];

        % Loop over transitions
        parameter = [];
        for transition = 1:numel(transition_indices)
            % Determine indices of transition windows 
            if strcmp(parameter_source,'ephys')
                transition_window_start = transition_indices(transition) - pre_window*sampling_rate_ephys;
                transition_window_end = transition_indices(transition) + post_window*sampling_rate_ephys;
            else
                transition_window_start = find(data(recording).time_treadmill>=data(recording).time_ephys(transition_indices(transition)),1,'first') ... 
                    - pre_window*sampling_rate_treadmill;
                transition_window_end = find(data(recording).time_treadmill<=data(recording).time_ephys(transition_indices(transition)),1,'last') ... 
                    + post_window*sampling_rate_treadmill; 
            end

            % Read out parameter
            parameter(:,transition) = data(recording).(parameter_name)(transition_window_start:transition_window_end);

            % Subtract baseline (optional)
            if subtract_baseline
                if strcmp(parameter_source,'ephys') 
                    parameter(:,transition) = parameter(:,transition) - mean(parameter(1:baseline_win*sampling_rate_ephys,transition));
                elseif strcmp(parameter_source,'treadmill')
                    parameter(:,transition) = parameter(:,transition) - mean(parameter(1:baseline_win*sampling_rate_treadmill,transition));
                end
            end
        end
    
        % Store trial data  
        parameter_animal = [parameter_animal, parameter];
    end

    % Display number of transitions 
    display(['Animal ',num2str(animal_id),': ',num2str(size(parameter_animal,2))])

    % Store animal data 
    if size(parameter_animal,2) >= n_transitions_min    
        if strcmp(parameter_name,'spike_events')
            parameter_all = [parameter_all, parameter_animal];
        else
            parameter_all = [parameter_all, mean(parameter_animal,2)];
        end
    end
end


% Plot mean before and after transition
if strcmp(plot_type,'mean')
    mean_before = [];
    mean_after = [];
    for animal_index = 1:size(parameter_all,2)
        if strcmp(parameter_source,'ephys')
            sampling_rate = sampling_rate_ephys;
        else
            sampling_rate = sampling_rate_treadmill;
        end

        mean_before = [mean_before; mean(parameter_all(1:pre_window*sampling_rate-1,animal_index))];
        mean_after = [mean_after; mean(parameter_all(pre_window*sampling_rate:end,animal_index))];
    end
    
    figure
    hold on
    for animal_index = 1:size(parameter_all,2)
        plot([0,1],[mean_before(animal_index),mean_after(animal_index)],'-k')
    end
    plot([0,1],[mean(mean_before), mean(mean_after)],'-k','LineWidth',3)
    hold off
    ylabel('Parameter')
    xlim([-0.5,1.5])
    ylim([0,20])
    set(gca,'Color','none','xtick',0:1,'xticklabel',{'before','after'})
    grid on

    % Compute statistics
    [p, h, stats] = signrank(mean_before,mean_after);
end

% Plot mean time course aligned to transition
if strcmp(plot_type,'time_series')
    figure
    hold on
    time = linspace(-pre_window,post_window,size(parameter_all,1));
    if strcmp(parameter_name,'spike_events')
        for bout = 1:size(parameter_all,2)
            plot(time(parameter_all(:,bout)>0), size(parameter_all,2)-bout+1, '.', 'color', [.8,.8,.8].*bout/size(parameter_all,2))
        end
        plot([0,0], [0, size(parameter_all,2)+1], 'k')
    else    
        plot(time, parameter_all, 'color', [.7,.7,.7])
        plot(time, mean(parameter_all,2), 'k')
        plot(time, mean(parameter_all,2) + std(parameter_all,0,2)/sqrt(numel(data)), 'k')
        plot(time, mean(parameter_all,2) - std(parameter_all,0,2)/sqrt(numel(data)), 'k')
        plot([0,0], [min(min(parameter_all))-1, max(max(parameter_all))+1], 'k')
    end
    hold off
    xlabel('Time to transition (s)')
    set(gca,'Color','none')
    ylabel('Parameter')
end
