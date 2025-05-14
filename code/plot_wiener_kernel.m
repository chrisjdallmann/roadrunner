% PLOT_WIENER_KERNEL.m plots the Wiener kernel mapping an input signal to an output signal 
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

%clear, clc

% Load data
%load('Z:\Data\Roadrunner\Electrophysiology_treadmill\walking_data.mat')

% Set parameters
animal_id = 1;
sampling_rate_ephys = 20000;
sampling_rate_treadmill = 50;
sampling_rate_reference = 1000;

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

n_trials = sum(animal_ids==animal_id);

input_all = [];
output_all = [];

% Loop over trials
for trial = 1:n_trials
    recording = find(animal_ids==animal_id & trials==trial);
    
    % Get input and output 
    spike_events = data(recording).spike_events;
    width = 2; % s
    sd = 0.2; % s
    scaling_factor = 2;
    input = compute_spike_rate(spike_events, width*sampling_rate_ephys, sd*sampling_rate_ephys, scaling_factor);

    output = data(recording).translational_speed;


    % Resample data to reference sampling rate
    time_ephys = data(recording).time_ephys;
    time_treadmill = data(recording).time_treadmill;
    time_reference = linspace(0,time_ephys(end),time_ephys(end)*sampling_rate_reference);
    input = spline(time_ephys,input,time_reference);
    output = spline(time_treadmill,output,time_reference);

    movement_data = data(recording).movement;
    movement_data = repelem(movement_data, round(numel(output)/numel(movement_data)));
    movement_data(end-(numel(movement_data)-numel(output)-1) : end) = [];

    % Select data during movement only 
    input = input(movement_data==1);
    output = output(movement_data==1);

    %input = input(randperm(length(input)));

    % Store trial data
    input_all = [input_all, input'];
    output_all = [output_all, output'];
end

% Compute Wiener kernel between input and output
filter_width = 1;
[kernel, lags] = compute_wiener_kernel(input,output,sampling_rate_reference,filter_width);

% Plot Wiener kernel
figure
plot(lags,kernel)
set(gca,'Color','none')
xlabel('Lag')

% figure
% hold on
% plot(input)
% plot(output)
% plot(conv(input,kernel,'same'), '--')
% hold off
% set(gca,'Color','none')
