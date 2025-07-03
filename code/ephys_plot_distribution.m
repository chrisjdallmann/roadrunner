% PLOT_DATA_DISTRIBUTION.m plots the probability histrogram of electrophysiology or treadmill data 
% 
% Files required: 
%    walking_data.mat
%
% Functions/packages required:
% 

% Author: Chris J. Dallmann 
% Affiliation: University of Wuerzburg
% Last revision: 01-July-2025

% ------------- BEGIN CODE -------------%

%clear, clc

% Load data
%load('Z:\Data\Roadrunner\Electrophysiology_treadmill\walking_data.mat')

% Set parameters
animal_ids_to_include = 9; %[1,4,5,6,7,9,10,13,16,17,18];   
sampling_rate_ephys = 20000; % Hz 
sampling_rate_treadmill = 50; % Hz
sampling_rate_reference = 1000; % Hz
subtract_baseline_spike_rate = true;

% Initialize variables
speed_all = [];
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
for animal_id = animal_ids_to_include
    % Initialize variables
    trials_animal = trials(animal_ids==animal_id)';
    speed_animal = [];
    spike_rate_animal = [];

    % Loop over trials
    for trial = trials_animal
        recording = find(animal_ids==animal_id & trials==trial);

        % Calculate spike rate
        spike_events = data(recording).spike_events;
        width = 2; % s
        sd = 0.2; % s
        scaling_factor = 2;
        spike_rate = compute_spike_rate(spike_events, width*sampling_rate_ephys, sd*sampling_rate_ephys, scaling_factor);

        % Get speed and movement data
        speed = data(recording).translational_speed;
        movement = data(recording).movement;

        % Resample data 
        time_ephys = data(recording).time_ephys;
        time_treadmill = data(recording).time_treadmill;
        time_reference = linspace(0, time_ephys(end), time_ephys(end)*sampling_rate_reference);
        spike_rate = spline(time_ephys, spike_rate, time_reference);
        speed = spline(time_treadmill, speed, time_reference);
        
        movement = repelem(movement, round(numel(speed)/numel(movement)));
        movement(end-(numel(movement)-numel(speed)-1) : end) = [];

        % Subtract baseline spike rate
        if subtract_baseline_spike_rate
            baseline_spike_rate = median(spike_rate(movement==0));       
            spike_rate = spike_rate - baseline_spike_rate;
        end

        spike_rate(movement==0) = [];
        speed(movement==0) = [];
        
        % Store trial data  
        speed_animal = [speed_animal, speed];
        spike_rate_animal = [spike_rate, spike_rate];        
    end

    figure
    subplot(121)
        hold on
        % Histogram
        bins_size = 0.5;
        edges = -0.5:bins_size:15.5;
        h = histcounts(speed_animal,edges,'normalization','probability');
        plot(edges(1:end-1)+bins_size/2,h)
        % Kernel density estimate
        [f,xi] = ksdensity(speed);
        plot(xi,f,'k')
        xlim([0,15])
        ylim([0,1])
        hold off
        set(gca,'Color','none')
        xlabel('Speed (mm/s)')

        speed_all = [speed_all, h'];

    subplot(122)
        hold on
        % Histogram
        bins_size = 1;
        edges = -0.5:bins_size:25.5;
        h = histcounts(spike_rate,edges,'normalization','probability');
        plot(edges(1:end-1)+bins_size/2,h)
        % Kernel density estimate
        [f,xi] = ksdensity(spike_rate);
        plot(xi,f,'k')
        xlim([0,25])
        ylim([0,1])
        hold off
        set(gca,'Color','none')
        xlabel('Spike rate (Hz)')

        spike_rate_all = [spike_rate_all, h'];
end

figure
subplot(121)
    plot(speed_all)
    set(gca,'Color','none')
    xlabel('Speed (mm/s)')
    grid on
subplot(122)
    plot(spike_rate_all)
    xlabel('Spike rate (Hz)')
    set(gca,'Color','none')
    grid on

%export_fig(gcf,'C:\Users\Chris\Desktop\figure.eps','-eps')  