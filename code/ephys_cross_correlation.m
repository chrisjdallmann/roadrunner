% PLOT_CROSS_CORRELATION.m plots the cross-correlation between electrophysiology and treadmill data 
% 
% Files required: 
%    walking_data.mat
%
% Functions/packages required:
% 

% Author: Chris J. Dallmann 
% Affiliation: University of Wuerzburg
% Last revision: 04-July-2025

% ------------- BEGIN CODE -------------

%clc, clear

% Load data
%load('Z:\Data\Roadrunner\Electrophysiology_treadmill\walking_data.mat')

% Set parameters
ephys_parameter_name = 'spike_rate'; 
treadmill_parameter_name = 'rotational_speed';
correlation_window = 5; % s

% Initialize variables
animal_ids_to_include = [1,4,5,6,7,9,10,16,17,18];   
sampling_rate_ephys = 20000; % Hz 
sampling_rate_treadmill = 50; % Hz
sampling_rate_reference = 1000; % Hz

r_all = [];
r_all_shuffled = [];
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
    ephys_data_animal = [];
    treadmill_data_animal = [];

    % Loop over trials
    for trial = trials_animal
        recording = find(animal_ids==animal_id & trials==trial);

        % Get data
        if strcmp(ephys_parameter_name, 'spike_rate')
            % Compute spike rate
            spike_events = data(recording).spike_events;
            sd = 0.15; % s
            ephys_data = ephys_compute_spike_rate(spike_events, sampling_rate_ephys, sd);
        else
            ephys_data = data(recording).(ephys_parameter_name);
        end
        treadmill_data = data(recording).(treadmill_parameter_name);

        % Resample data
        time_ephys = data(recording).time_ephys;
        time_treadmill = data(recording).time_treadmill;
        time_reference = linspace(0, time_ephys(end), time_ephys(end)*sampling_rate_reference);
        ephys_data = spline(time_ephys, ephys_data, time_reference);
        treadmill_data = spline(time_treadmill, treadmill_data, time_reference);
    
        movement_data = data(recording).movement;  
        movement_data = repelem(movement_data, round(numel(treadmill_data)/numel(movement_data)));
        movement_data(end-(numel(movement_data)-numel(treadmill_data)-1) : end) = [];

        % Concatenate data across trials 
        ephys_data_animal = [ephys_data_animal; ephys_data'];
        treadmill_data_animal = [treadmill_data_animal; treadmill_data'];
    end

    % Z-score data to ensure correlation reflect similarity in shape, not
    % magnitude
    ephys_data_animal = zscore(ephys_data_animal);
    treadmill_data_animal = zscore(treadmill_data_animal);

    % Compute cross-correlation 
    % Real data
    [r,lags] = xcorr(ephys_data_animal,treadmill_data_animal,'normalized'); % Peak at negative lag means the input leads the output
    start_index = find(lags>=-correlation_window*sampling_rate_reference,1,'first');
    end_index = find(lags<=correlation_window*sampling_rate_reference,1,'last');

    % Shuffled electrophysiology data
    ephys_data_animal_shuffled = ephys_data_animal(randperm(length(ephys_data_animal)));
    [r_shuffled,~] = xcorr(ephys_data_animal_shuffled,treadmill_data_animal,'normalized'); 
        
    % Store cross-correlation
    r_all(:,n_animal) = r(start_index:end_index);
    r_all_shuffled(:,n_animal) = r_shuffled(start_index:end_index);
end

% Plot cross-correlation
figure
hold on
lag = -correlation_window:1/sampling_rate_reference:correlation_window;
plot(lag,r_all)
plot(lag,mean(r_all,2),'k')
plot(lag,mean(r_all,2)+std(r_all,0,2)/sqrt(size(r_all,2)),'k')
plot(lag,mean(r_all,2)-std(r_all,0,2)/sqrt(size(r_all,2)),'k')
%plot(lag,mean(r_all_shuffled,2),'r')
%plot(lag,mean(r_all_shuffled,2)+std(r_all_shuffled,0,2)/sqrt(size(r_all_shuffled,2)),'r')
%plot(lag,mean(r_all_shuffled,2)-std(r_all_shuffled,0,2)/sqrt(size(r_all_shuffled,2)),'r')
plot([0,0],[0,1],'k')
hold off
set(gca,'Color','none')
xlabel('Lag (s)')
ylabel('r')

[m,i] = max(mean(r_all,2))
lag(i)

% % Set bins
% bins_ephys = 1 : sampling_rate_ephys*bin_size : numel(ephys_data);
% bins_treadmill = 1 : sampling_rate_treadmill*bin_size : numel(treadmill_data);
%
% % Bin ephys and treadmill data
% ephys_data_binned = [];
% treadmill_data_binned = [];
% n_bins = numel(bins_ephys);
% % Loop over bins
% for bin = 1:n_bins-1
%     if strcmp(ephys_parameter_name, 'spike_events')
%         ephys_data_binned = [ephys_data_binned; sum(ephys_data(bins_ephys(bin) : bins_ephys(bin+1)))/bin_size];
%     else
%         ephys_data_binned = [ephys_data_binned; mean(ephys_data(bins_ephys(bin) : bins_ephys(bin+1)))];
%     end
%     treadmill_data_binned = [treadmill_data_binned; mean(treadmill_data(bins_treadmill(bin) : bins_treadmill(bin+1)))];
% end
%
% % Z-score data
% ephys_data_binned = zscore(ephys_data_binned);
% treadmill_data_binned = zscore(treadmill_data_binned);
%
% % Compute cross-correlation
% [r,lags] = xcorr(ephys_data_binned, treadmill_data_binned, 'normalized');
% start_index = find(lags>=-correlation_window/bin_size,1,'first');
% end_index = find(lags<=correlation_window/bin_size,1,'last');
% %stem(lags(start_index:end_index),r(start_index:end_index))