% EPHYS_CROSS_CORRELATION.m computes the cross-correlation between electrophysiology and treadmill data 
% 
% Files required: 
%    data.mat

% Author: Chris J. Dallmann 
% Affiliation: University of Wuerzburg
% Last revision: 04-January-2026

% ------------- BEGIN CODE -------------

clear
clc

% Settings
dataset = 'treadmill_ephys_rrn_gfp_walking.mat';
ephys_parameter_name = 'spike_rate'; 
treadmill_parameter_name = 'translational_speed';
correlation_window = 3; % Seconds

% Load data
load(['..\data\',dataset])

% Initialize variables
sampling_rate_ephys = 20000; % Hz 
r_all = [];
recordings = 1:numel(data);
animal_ids = [];
for recording = recordings
    animal_ids = [animal_ids; data(recording).animal_id];
end 
unique_animal_ids = unique(animal_ids);
trials = [];
for recording = recordings
    trials = [trials; data(recording).trial];
end 


% Loop over animals
for n_animal = 1:numel(unique_animal_ids)
    
    % Initialize variables
    animal_id = unique_animal_ids(n_animal);
    trials_animal = trials(animal_ids==animal_id)';
    ephys_data_animal = [];
    treadmill_data_animal = [];

    % Loop over trials
    for n_trial = 1:numel(trials_animal)
        recording = find(animal_ids==animal_id & trials==trials_animal(n_trial));

        % Get data
        if strcmp(ephys_parameter_name,'membrane_potential_smoothed')
            width = 0.02; % s
            data(recording).membrane_potential_smoothed = smooth(data(recording).membrane_potential, width*sampling_rate_ephys);
        end
        ephys_data = data(recording).(ephys_parameter_name);
        treadmill_data = data(recording).(treadmill_parameter_name);

        % Upsample treadmill data 
        time_ephys = data(recording).time_ephys;
        time_treadmill = data(recording).time_treadmill;
        treadmill_data = spline(time_treadmill, treadmill_data, time_ephys);

        % Concatenate data across trials 
        ephys_data_animal = [ephys_data_animal; ephys_data];
        treadmill_data_animal = [treadmill_data_animal; treadmill_data];
    end

    % Z-score data to ensure correlation reflects similarity in shape, not
    % magnitude
    ephys_data_animal = zscore(ephys_data_animal);
    treadmill_data_animal = zscore(treadmill_data_animal);

    % Compute cross-correlation 
    [r,lags] = xcorr(ephys_data_animal, treadmill_data_animal, 'normalized'); % Peak at negative lag means the input leads the output
    start_index = find(lags>=-correlation_window*sampling_rate_ephys,1,'first');
    end_index = find(lags<=correlation_window*sampling_rate_ephys,1,'last');
        
    % Store animal data
    r_all(:,n_animal) = r(start_index:end_index);
end

% Plot cross-correlation
figure
hold on
lag = -correlation_window:1/sampling_rate_ephys:correlation_window;
plot(lag,r_all)
plot(lag,mean(r_all,2),'k')
plot(lag,mean(r_all,2)+std(r_all,0,2)/sqrt(size(r_all,2)),'k')
plot(lag,mean(r_all,2)-std(r_all,0,2)/sqrt(size(r_all,2)),'k')
plot([0,0],[0,1],'k')
hold off
set(gca,'Color','none')
xlabel('Lag (s)')
ylabel('r')

[m,i] = max(mean(r_all,2));
lag(i)