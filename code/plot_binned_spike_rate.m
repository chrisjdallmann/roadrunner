% PLOT_BINNED_SPIKE_RATE.m plots spike rate for translational and rotational speed bins  
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
trans_speed_bins = 0:0.5:10; % mm/s
rot_speed_bins = 0:20:300; % deg/s

% Initialize variables
spike_rate_all = []; 
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
    n_trials = sum(animal_ids==animal_id);
    spike_rate_animal = []; 
    translational_speed_animal = [];
    rotational_speed_animal = [];

    % Loop over trials
    for trial = 1:n_trials
        recording = find(animal_ids==animal_id & trials==trial);

        % Compute spike rate 
        spike_events = data(recording).spike_events;
        width = 2; % s
        sd = 0.2; % s
        scaling_factor = 2;
        spike_rate = compute_spike_rate(spike_events, width*sampling_rate_ephys, sd*sampling_rate_ephys, scaling_factor);

        % Get speeds
        translational_speed = data(recording).translational_speed;
        rotational_speed = data(recording).rotational_speed;  
   
        % Resample data 
        time_ephys = data(recording).time_ephys;
        time_treadmill = data(recording).time_treadmill;
        time_reference = linspace(0, time_ephys(end), time_ephys(end)*sampling_rate_reference);
        spike_rate = spline(time_ephys, spike_rate, time_reference);
        translational_speed = spline(time_treadmill, translational_speed, time_reference);
        rotational_speed = spline(time_treadmill, rotational_speed, time_reference);
        
        % Concatenate data across trials 
        spike_rate_animal = [spike_rate_animal; spike_rate'];
        translational_speed_animal = [translational_speed_animal; translational_speed'];
        rotational_speed_animal = [rotational_speed_animal; rotational_speed'];

    end
    
    % Compute mean spike rate in speed bins 
    spike_rate_all(:,:,n_animal) = nan(length(trans_speed_bins)-1, length(rot_speed_bins)-1);
    for trans_speed_bin = 1:length(trans_speed_bins)-1
        for rot_speed_bin = 1:length(rot_speed_bins)-1
            binned_spike_rate = mean(spike_rate_animal( ...
                (translational_speed_animal >= trans_speed_bins(trans_speed_bin) & translational_speed_animal < trans_speed_bins(trans_speed_bin+1)) ...
                & (rotational_speed_animal >= rot_speed_bins(rot_speed_bin) & rotational_speed_animal < rot_speed_bins(rot_speed_bin+1)) ...
                ));
            spike_rate_all(trans_speed_bin, rot_speed_bin, n_animal) = binned_spike_rate;
        end
    end
end

% Plot data
figure
clims = [0,25];
imagesc(flipud(nanmean(spike_rate_all,3)), clims)
c = colorbar;
c.Label.String = 'Spike rate';
set(gca,'xtick',1:length(rot_speed_bins),'xticklabel',20:20:300,'ytick',1:20,'yticklabel',10:-.5:.5)
xlabel("Rotational speed (deg/s)")
ylabel("Translational speed (mm/s)")


% % Set bins
% bins_ephys = 1 : bin_size*sampling_rate_ephys : numel(y);
% bins_treadmill = 1 : bin_size*sampling_rate_treadmill : numel(x1);
% 
% % Bin ephys and treadmill data
% y_binned = [];
% x1_binned = [];
% x2_binned = [];
% n_bins = numel(bins_ephys);    
% % Loop over bins
% for bin = 1:n_bins-1
%     y_binned = [y_binned; sum(y(bins_ephys(bin) : bins_ephys(bin+1)))/bin_size];
%     x1_binned = [x1_binned; mean(x1(bins_treadmill(bin) : bins_treadmill(bin+1)))];
%     x2_binned = [x2_binned; mean(x2(bins_treadmill(bin) : bins_treadmill(bin+1)))];
% end