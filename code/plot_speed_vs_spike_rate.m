% PLOT_SPIKE_RATE_VS_SPEED.m plots spike rates and mean speeds for movement bouts 
% 
% Files required: 
%    walking_data.mat
%
% Functions/packages required:
% 

% Author: Chris J. Dallmann 
% Affiliation: University of Wuerzburg
% Last revision: 12-May-2025

% ------------- BEGIN CODE -------------

clear, clc

% Load data
load('Z:\Data\Roadrunner\Electrophysiology_treadmill\walking_data.mat')

% Set parameters
animal_ids_to_include = [1,4,5,6,7,9,10];  
sampling_rate_ephys = 20000; % Hz
sampling_rate_treadmill = 50; % Hz
sampling_rate_reference = 1000; % Hz
min_bout_duration = 1; % s

% Initialize variables
recordings = 1:numel(data);
animal_ids = [];
for recording = recordings
    animal_ids = [animal_ids; data(recording).flyid];
end 
trials = [];
for recording = recordings
    trials = [trials; data(recording).trial];
end 
colors = parula(numel(animal_ids_to_include));


% Loop over animals
h = figure;
n_animal = 0;
for animal_id = animal_ids_to_include
    % Initialize variables
    n_animal = n_animal+1;
    n_trials = sum(animal_ids==animal_id);
    spike_rate_animal = [];
    translational_speed_animal = [];
    rotational_speed_anmal = [];

    % Loop over trials
    for trial = 1:n_trials
        recording = find(animal_ids==animal_id & trials==trial);

        % Compute spike rate 
        spike_events = data(recording).spike_events;
        width = 2; % s
        sd = 0.2; % s
        scaling_factor = 2;
        data(recording).spike_rate = compute_spike_rate(spike_events, width*sampling_rate_ephys, sd*sampling_rate_ephys, scaling_factor);

        % Get bout onset and offset indices
        bout_onset_indices_treadmill = find(diff(data(recording).movement)>0)+1;
        bout_offset_indices_treadmill = find(diff(data(recording).movement)<0)+1;
    
        % Exclude incompletely recorded bouts
        bout_onset_indices_treadmill(bout_onset_indices_treadmill>bout_offset_indices_treadmill(end)) = [];
        bout_offset_indices_treadmill(bout_offset_indices_treadmill<bout_onset_indices_treadmill(1)) = [];
    
        % Loop over bouts
        n_bouts = numel(bout_onset_indices_treadmill);
        spike_rate = [];
        translational_speed = [];
        rotational_speed = [];
        n_bout = 0; 
        n_bin = 0;
        for bout = 1:n_bouts
            % Get bout onset and offset times
            bout_onset_time = data(recording).time_treadmill(bout_onset_indices_treadmill(bout));
            bout_offset_time = data(recording).time_treadmill(bout_offset_indices_treadmill(bout));
            
            % Compute mean spike rate and speed for bouts longer than min_bout_duration
            if (bout_offset_time-bout_onset_time) >= min_bout_duration
                n_bout = n_bout+1;
    
                bout_onset_index_ephys = find(data(recording).time_ephys>=bout_onset_time,1,'first');
                bout_offset_index_ephys = find(data(recording).time_ephys<=bout_offset_time,1,'last');
    
                bout_onset_index_treadmill = bout_onset_indices_treadmill(bout);
                bout_offset_index_treadmill = bout_offset_indices_treadmill(bout);
    
                spike_rate(n_bout) = mean(data(recording).spike_rate(bout_onset_index_ephys : bout_offset_index_ephys));
                translational_speed(n_bout) = mean(data(recording).translational_speed(bout_onset_index_treadmill : bout_offset_index_treadmill));
                rotational_speed(n_bout) = mean(data(recording).rotational_speed(bout_onset_index_treadmill : bout_offset_index_treadmill));                
            end
        end

        % Concatenate data across trials
        spike_rate_animal = [spike_rate_animal; spike_rate'];
        translational_speed_animal = [translational_speed_animal; translational_speed'];
        rotational_speed_anmal = [rotational_speed_anmal; rotational_speed'];
    end

    % Plot data
    figure(h)
    hold on
    plot(translational_speed_animal, spike_rate_animal, 'o', 'Color', colors(n_animal,:))
    
    % Fit linear model
    model = fitlm(translational_speed_animal, spike_rate_animal, 'linear');
     
    % Plot linear model
    coefficients = model.Coefficients.Estimate;
    y_fit = coefficients(2)*translational_speed_animal + coefficients(1);
    plot(translational_speed_animal, y_fit,'-', 'Color', colors(n_animal,:))
end

hold off
xlabel('Spike rate (Hz)')
ylabel('Translational speed (mm/s)')
set(gca,'Color','none')


% if normalize_spike_rate
%     % Compute binned spike rate for entire recording
%     spike_events = data(recording).spike_events;
%     bins = 1 : sampling_rate_ephys*bin_size_for_normalization : numel(spike_events);
%     n_bins = numel(bins);
%     spike_rate_recording = [];
%     for bin = 1:n_bins-1
%         spike_rate_recording = [spike_rate_recording; sum(spike_events(bins(bin) : bins(bin+1)))/bin_size_for_normalization];
%     end
%     % Normalize spike rate by subtracting the minimum spike rate and
%     % dividing by the 95th percentile value of the spike rate
%     % distribution (similar to Yang et al. 2024)
%     spike_rate = spike_rate-min(spike_rate_recording);
%     spike_rate = spike_rate./prctile(spike_rate_recording,95);
% end

% if binned_analysis
%     bins = bout_onset_time : bin_size : bout_offset_time+bin_size; % s
%     n_bins = numel(bins);
% 
%     % Loop over bins
%     for bin = 1:n_bins-1
%         n_bin = n_bin+1;
% 
%         % Calculate spike rate in bin
%         bin_onset_index_ephys = find(data(recording).time_ephys>=bins(bin),1,'first') - shift_ephys_data*sampling_rate_ephys;
%         bin_offset_index_ephys = find(data(recording).time_ephys<bins(bin+1),1,'last') - shift_ephys_data*sampling_rate_ephys;
% 
%         n_spikes = sum(data(recording).spike_events(bin_onset_index_ephys : bin_offset_index_ephys));
%         spike_rate(n_bin) = n_spikes/(bins(bin+1)-bins(bin));
% 
%         % Calculate mean speeds in bin
%         bin_onset_index_treadmill = find(data(recording).time_treadmill>=bins(bin),1,'first');
%         bin_offset_index_treadmill = find(data(recording).time_treadmill<bins(bin+1),1,'last');
% 
%         translational_speed(n_bin) = mean(data(recording).translational_speed(bin_onset_index_treadmill : bin_offset_index_treadmill));
%         rotational_speed(n_bin) = mean(data(recording).rotational_speed(bin_onset_index_treadmill : bin_offset_index_treadmill));
%     end
% 
% else
%     % Calculate spike rate during bout
%     n_spikes = sum(data(recording).spike_events(bout_onset_index_ephys : bout_offset_index_ephys));
%     spike_rate(n_bout) = n_spikes/(bout_offset_time-bout_onset_time);
% 
%     % Calculate mean speeds during bout 
%     bout_onset_index_treadmill =  bout_onset_indices_treadmill(bout);
%     bout_offset_index_treadmill =  bout_offset_indices_treadmill(bout);
% 
%     translational_speed(n_bout) = mean(data(recording).translational_speed(bout_onset_index_treadmill : bout_offset_index_treadmill));
%     rotational_speed(n_bout) = mean(data(recording).rotational_speed(bout_onset_index_treadmill : bout_offset_index_treadmill));
% end