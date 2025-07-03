% PLOT_BOUT_TRANSITIONS.m plots spike rates, membrane potential, and speeds aligned to movement onsets and offsets 
% 
% Files required: 
%    walking_data.mat
%
% Functions/packages required:
% 

% Author: Chris J. Dallmann 
% Affiliation: University of Wuerzburg
% Last revision: 01-July-2025

% ------------- BEGIN CODE -------------

%clc, clear

% Load data
%load('Z:\Data\Roadrunner\Electrophysiology_treadmill\walking_data.mat')

% Set parameters
animal_ids_to_include = [1,4,5,6,7,9,10,16,17,18];  
sampling_rate_ephys = 20000; % Hz 
sampling_rate_treadmill = 50; % Hz
sampling_rate_reference = 1000; % Hz
transition_type = 'onset';
parameter_name = 'membrane_potential_smoothed'; % 'membrane_potential', 'membrane_potential_smoothed', 'spike_events', 'spike_rate', '*_speed', '*_velocity'
parameter_source = 'ephys'; % 'ephys', 'treadmill'
subtract_baseline = true;
baseline_win = 0.5; % s, from beginning of window
pre_window = 1; % s
post_window = 1; % s

% Initialize variables
parameter_all = []; 
recordings = 1:numel(data);
animal_ids = [];
for recording = recordings
    animal_ids = [animal_ids; data(recording).flyid];
end 
trials = [];
for recording = recordings
    trials = [trials; data(recording).trial];
end 


% Loop over animals
n_animal = 0;
for animal_id = animal_ids_to_include
    % Initialize variables
    n_animal = n_animal+1;
    trials_animal = trials(animal_ids==animal_id)';
    parameter_animal = [];

    % Loop over trials
    for trial = trials_animal
        recording = find(animal_ids==animal_id & trials==trial);

        % Get data
        if strcmp(parameter_name,'spike_rate')
            % Compute spike rate
            spike_events = data(recording).spike_events;
            sd = 0.1; % s
            data(recording).spike_rate = compute_spike_rate(spike_events, sampling_rate_ephys, sd);
        end
        if strcmp(parameter_name,'membrane_potential_smoothed')
            width = 0.2; % s
            data(recording).membrane_potential_smoothed = smooth(data(recording).membrane_potential, width*sampling_rate_ephys);
        end

        % Get bout onset and offset indices
        bout_onset_indices_treadmill = find(diff(data(recording).movement)>0)+1;
        bout_offset_indices_treadmill = find(diff(data(recording).movement)<0)+1;
    
        % Get transition indices
        if strcmp(transition_type, 'onset') 
            transition_indices_treadmill = bout_onset_indices_treadmill;
            other_indices_treadmill = bout_offset_indices_treadmill;
        else 
            transition_indices_treadmill = bout_offset_indices_treadmill;
            other_indices_treadmill = bout_onset_indices_treadmill;
        end
        
        % Exclude transitions where there is not enough data or another
        % transition in the pre or post window
        n_frames_treadmill = numel(data(recording).time_treadmill);
        transitions_to_exlude = [];
        for transition = 1:numel(transition_indices_treadmill)
            transition_window_start_treadmill = transition_indices_treadmill(transition) - pre_window*sampling_rate_treadmill;
            transition_window_end_treadmill = transition_indices_treadmill(transition) + post_window*sampling_rate_treadmill;
            
            if (transition_window_start_treadmill < 0) ...
                    || (transition_window_end_treadmill > n_frames_treadmill) ...
                    || any(other_indices_treadmill >= transition_window_start_treadmill & other_indices_treadmill <= transition_window_end_treadmill)
    
                transitions_to_exlude = [transitions_to_exlude; transition];
            end
        end
        transition_indices_treadmill(transitions_to_exlude) = [];
        transition_time_treadmill = data(recording).time_treadmill(transition_indices_treadmill);
    
        % Loop over transitions
        parameter = [];
        for transition = 1:numel(transition_indices_treadmill)
            % Determine indices of transition windows 
            if strcmp(parameter_source,'ephys')
                transition_window_start = find(data(recording).time_ephys>=transition_time_treadmill(transition),1,'first') - pre_window*sampling_rate_ephys;
                transition_window_end = find(data(recording).time_ephys<=transition_time_treadmill(transition),1,'last') + post_window*sampling_rate_ephys;
            else
                transition_window_start = transition_indices_treadmill(transition) - pre_window*sampling_rate_treadmill;
                transition_window_end = transition_indices_treadmill(transition) + post_window*sampling_rate_treadmill;   
            end

            % Read out parameter
            parameter(:,transition) = data(recording).(parameter_name)(transition_window_start:transition_window_end);

            % Subtract baseline (optional)
            if strcmp(parameter_source,'ephys') && ~strcmp(parameter_name,'spike_events')
                parameter(:,transition) = parameter(:,transition) - mean(parameter(1:baseline_win *sampling_rate_ephys,transition));
            elseif strcmp(parameter_source,'treadmill')
                parameter(:,transition) = parameter(:,transition) - mean(parameter(1:baseline_win *sampling_rate_treadmill,transition));
            end
        end

        % Store trial data  
        parameter_animal = [parameter_animal, parameter];
    end

    % Compute relative time to cross threshold
    if strcmp(transition_type,'onset')
        if strcmp(parameter_source,'ephys')
            transition = pre_window*sampling_rate_ephys;
            sampling_rate = sampling_rate_ephys;
        else
            % Upsample treadmill data for higher temporal resolution
            sampling_rate = sampling_rate_reference;
            transition = pre_window*sampling_rate_treadmill * sampling_rate_reference/sampling_rate_treadmill;
            parameter_animal_upsampled = [];
            time_ephys = data(recording).time_ephys;
            time_treadmill = linspace(0, pre_window+post_window, size(parameter_animal,1));
            time_reference = linspace(0, pre_window+post_window, size(parameter_animal,1) * sampling_rate_reference/sampling_rate_treadmill);
            % Loop over bouts
            for bout = 1:size(parameter_animal,2)
                parameter_animal_upsampled(:,bout) = spline(time_treadmill, parameter_animal(:,bout), time_reference);
            end
            parameter_animal = parameter_animal_upsampled;
            clearvars parameter_animal_upsampled
        end
        
        % Compute threshold as 1.5x standard deviation of baseline (half
        % pre window)
        threshold = mean(std(parameter_animal(1:transition/2,:),0,2)) * 1.5;

        % Find time point relative to transition where mean crosses threshold 
        mean_onset = (find(mean(parameter_animal,2)>threshold,1,'first') - transition)/sampling_rate;
        disp([num2str(animal_id),': ',num2str(mean_onset)])
    end

    % Store animal data 
    if strcmp(parameter_name,'spike_events')
        parameter_all = [parameter_all, parameter_animal];
    else
        parameter_all = [parameter_all, mean(parameter_animal,2)];
    end
end


% Plot transition data
figure
hold on
time = linspace(-pre_window,post_window,size(parameter_all,1));
if strcmp(parameter_name,'spike_events')
    for bout = 1:size(parameter_all,2)
        plot(time(parameter_all(:,bout)>0), size(parameter_all,2)-bout+1, '.', 'color', [.8,.8,.8].*bout/size(parameter_all,2))
    end
    plot([0,0], [0, size(parameter_all,2)+1], 'k')
else    
    plot(time, parameter_all)
    plot(time, mean(parameter_all,2), 'k')
    plot(time, mean(parameter_all,2) + std(parameter_all,0,2)/sqrt(numel(data)), 'k')
    plot(time, mean(parameter_all,2) - std(parameter_all,0,2)/sqrt(numel(data)), 'k')
    plot([0,0], [min(min(parameter_all))-1, max(max(parameter_all))+1], 'k')
end
hold off
xlabel('Time to transition (s)')
set(gca,'Color','none')
ylabel('Parameter')

%export_fig(gcf,'C:\Users\Chris\Desktop\figure.eps','-eps')  