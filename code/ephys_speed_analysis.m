% EPHYS_SPEED_ANALYSIS.m computes speed distributions and pools spike rate for lower and upper percentiles  
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

% Load data
load(['..\data\',dataset])

% Initialize variables
recordings = 1:numel(data);
animal_ids = [];
for recording = recordings
    animal_ids = [animal_ids; data(recording).animal_id];
end 
trials = [];
for recording = recordings
    trials = [trials; data(recording).trial];
end 
lower_speed = []; 
upper_speed = []; 
lower_spike_rate = [];
upper_spike_rate = [];
speed_kde = [];


% Loop over animals
for n_animal = 1:numel(unique(animal_ids))
    % Initialize variables
    animal_id = unique(animal_ids);
    animal_id = animal_id(n_animal);
    
    trials_animal = trials(animal_ids==animal_id)';
    speed_animal = [];
    spike_rate_animal = [];

    % Loop over trials
    for n_trial = 1:numel(trials_animal)
        recording = find(animal_ids==animal_id & trials==trials_animal(n_trial));

        % Get data
        speed = data(recording).translational_speed;
        movement = data(recording).movement;
        spike_rate =  data(recording).spike_rate;

        % Upsample speed
        time_ephys = data(recording).time_ephys;
        time_treadmill = data(recording).time_treadmill;
        speed = spline(time_treadmill, speed, time_ephys);

        % Exclude non-movement
        spike_rate(movement==0) = [];
        speed(movement==0) = [];
        
        % Store trial data  
        spike_rate_animal = [spike_rate_animal; spike_rate]; 
        speed_animal = [speed_animal; speed];
    end

    % Get percentiles
    lower_speed = [lower_speed, prctile(speed_animal, 20)];
    upper_speed = [upper_speed, prctile(speed_animal, 80)];

    lower_spike_rate = [lower_spike_rate, mean(spike_rate_animal(speed_animal<lower_speed(n_animal)))];
    upper_spike_rate = [upper_spike_rate, mean(spike_rate_animal(speed_animal>upper_speed(n_animal)))];

    % Compute KDE for speed
    [f,xi,bw] = ksdensity(speed_animal, -5:0.01:25, 'Bandwidth', 0.1);  
    speed_kde = [speed_kde, f'];
end


% Plot speed distribution per animal
% Sort animals based on peak in speed distribution and indicate lower and
% upper percentiles
figure
[~, index] = max(speed_kde);
[~, sort_index] = sort(index,'ascend');
for n_animal = 1:numel(unique(animal_ids))
    animal_index = sort_index(n_animal);
    subplot(length(sort_index), 1, n_animal)
    hold on
    plot(-5:0.01:25, speed_kde(:,animal_index), 'k')
    plot([lower_speed(animal_index),lower_speed(animal_index)], [0,max(max(speed_kde))], 'k')
    plot([upper_speed(animal_index),upper_speed(animal_index)], [0,max(max(speed_kde))], 'k')
    hold off
    set(gca, 'Color', 'none')
    if n_animal < length(sort_index)
        axis off
    else
        xlabel('Speed (mm/s)')
        ylabel('KDE')
        set(gca,'ytick',0:1)
    end
    ylim([0,max(max(speed_kde))])
end

% Plot spike rate
figure
hold on
for animal_index = 1:numel(unique(animal_ids))
    plot([0,1], [lower_spike_rate(animal_index),upper_spike_rate(animal_index)], 'k', 'LineWidth', 0.5)
end
plot([0,1],[mean(lower_spike_rate), mean(upper_spike_rate)], '-k', 'LineWidth', 1)
hold off
xlim([-0.5,1.5])
ylim([0,20])
ylabel('Spike rate (Hz)')
set(gca, 'Color', 'none', 'xtick', 0:1, 'xticklabel', {'slower','faster'})
grid on

% Compute statistics
[p, h, stats] = signrank(lower_spike_rate,upper_spike_rate);