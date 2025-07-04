% PLOT_DATA_DISTRIBUTION.m plots the probability histrogram of electrophysiology or treadmill data 
% 
% Files required: 
%    walking_data.mat
%
% Functions/packages required:
% 

% Author: Chris J. Dallmann 
% Affiliation: University of Wuerzburg
% Last revision: 04-July-2025

% ------------- BEGIN CODE -------------%

%clear
clc

% Load data
%load('Z:\Data\Roadrunner\Electrophysiology_treadmill\walking_data.mat')

% Initialize variables
animal_ids_to_include = [1,4,5,6,7,9,10,16,17,18];   
sampling_rate_ephys = 20000; % Hz 
sampling_rate_treadmill = 50; % Hz
sampling_rate_reference = 1000; % Hz

% Initialize variables
speed_binned = [];
spike_rate_binned = [];
recordings = 1:numel(data);
animal_ids = [];
lower_prctile = []; 
lower_spike_rate = [];
upper_prctile = []; 
upper_spike_rate = [];
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
    speed_animal = [];
    spike_rate_animal = [];

    % Loop over trials
    for trial = trials_animal
        recording = find(animal_ids==animal_id & trials==trial);

        % Calculate spike rate
        spike_events = data(recording).spike_events;
        sd = 0.15; % s
        spike_rate = ephys_compute_spike_rate(spike_events, sampling_rate_ephys, sd);

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

        spike_rate(movement==0) = [];
        speed(movement==0) = [];
        
        % Store trial data  
        spike_rate_animal = [spike_rate_animal, spike_rate]; 
        speed_animal = [speed_animal, speed];
    end

    % Histogram counts of speed
    bin_size_speed = 0.5;
    edges_speed = -2.5:bin_size_speed:15.5;
    centers_speed = edges_speed(1)+bin_size_speed/2 : bin_size_speed : edges_speed(end)-bin_size_speed/2;
    h = histcounts(speed_animal,edges_speed,'normalization','probability');
    speed_binned = [speed_binned, h'];
          
    % Histogram counts of spike rate
    bin_size_spike_rate = 1;
    edges_spike_rate = -0.5:bin_size_spike_rate:30.5;
    centers_spike_rate = edges_spike_rate(1)+bin_size_spike_rate/2 : bin_size_spike_rate : edges_spike_rate(end)-bin_size_spike_rate/2;
    h_spike_rate = histcounts(spike_rate,edges_spike_rate,'normalization','probability');
    spike_rate_binned = [spike_rate_binned, h_spike_rate'];

    % Get percentiles
    lower_prctile = [lower_prctile, prctile(speed_animal,20)];
    upper_prctile = [upper_prctile, prctile(speed_animal,80)];

    lower_spike_rate = [lower_spike_rate, mean(spike_rate_animal(speed_animal<lower_prctile(n_animal)))];
    upper_spike_rate = [upper_spike_rate, mean(spike_rate_animal(speed_animal>upper_prctile(n_animal)))];
end

figure
colors = parula(length(animal_ids_to_include));
subplot(121)
    hold on
    for animal_index = 1:length(animal_ids_to_include)
        plot(centers_speed,speed_binned(:,animal_index),'color',colors(animal_index,:))
    end
    set(gca,'Color','none')
    xlabel('Speed (mm/s)')
    grid on
    ylim([0,0.5])
    ylabel('Probability')
subplot(122)
    hold on
    for animal_index = 1:length(animal_ids_to_include)
        plot(centers_spike_rate,spike_rate_binned(:,animal_index),'color',colors(animal_index,:))
    end
    xlabel('Spike rate (Hz)')
    set(gca,'Color','none')
    grid on
    ylim([0,0.5])
    legend(cellstr(num2str(animal_ids_to_include')))


figure
hold on
for i =1:10
    plot([0,1],[lower_prctile(i),upper_prctile(i)],'-k')
end
plot([0,1],[mean(lower_prctile), mean(upper_prctile)],'-k','LineWidth',3)
hold off
ylabel('Translational speed (mm/s)')
xlim([-0.5,1.5])
set(gca,'Color','none','xtick',0:1,'xticklabel',{'slow','fast'})
grid on


figure
hold on
for i =1:10
    plot([0,1],[lower_spike_rate(i),upper_spike_rate(i)],'-k')
end
plot([0,1],[mean(lower_spike_rate), mean(upper_spike_rate)],'-k','LineWidth',3)
hold off
ylabel('Spike rate (Hz)')
xlim([-0.5,1.5])
set(gca,'Color','none','xtick',0:1,'xticklabel',{'slow','fast'})
grid on

[p, h, stats] = signrank(lower_spike_rate,upper_spike_rate);