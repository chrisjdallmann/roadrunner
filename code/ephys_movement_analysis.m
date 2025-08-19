% EPHYS_MOVEMENT_ANALYSIS.m compares electrophysiology data for moving and non-moving animals
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
dataset = 'treadmill_ephys_rr_gfp_flight.mat';
load(['Z:\Data\Roadrunner\',dataset])

% Set parameters
parameter_name = 'membrane_potential_smoothed'; 

% Initialize variables
sampling_rate_ephys = 20000;
recordings = 1:numel(data);
parameter_moving = [];
parameter_not_moving = [];
animal_ids = [];
for recording = recordings
    animal_ids = [animal_ids; data(recording).animal_id];
end 
trials = [];
for recording = recordings
    trials = [trials; data(recording).trial];
end 


% Loop over animals
for n_animal = 1:numel(unique(animal_ids))
    % Initialize variables
    animal_id = animal_ids(n_animal);   
    trials_animal = trials(animal_ids==animal_id)';
    parameter_animal_moving = [];
    parameter_animal_not_moving = [];

    % Loop over trials
    for n_trial = 1:numel(trials_animal)
        recording = find(animal_ids==animal_id & trials==trials_animal(n_trial));

        if strcmp(parameter_name,'membrane_potential_smoothed')
            width = 0.02; % s
            data(recording).membrane_potential_smoothed = smooth(data(recording).membrane_potential, width*sampling_rate_ephys);
        end

        % Store trial data
        parameter_animal_moving = [parameter_animal_moving; mean(data(recording).(parameter_name)(data(recording).movement==1))];
        parameter_animal_not_moving = [parameter_animal_not_moving; mean(data(recording).(parameter_name)(data(recording).movement==0))];
    end

    % Store animal data
    parameter_moving = [parameter_moving; mean(parameter_animal_moving)];
    parameter_not_moving = [parameter_not_moving; mean(parameter_animal_not_moving)];
end


% Plot means
figure
hold on
for n_animal = 1:numel(animal_ids)
    plot([0,1], [parameter_not_moving, parameter_moving], 'k', 'LineWidth', 0.5)
end
plot([0,1], [mean(parameter_not_moving), mean(parameter_moving)], 'k', 'LineWidth', 1.5)
hold off
set(gca, 'Color', 'none', 'xlim', [-.5,1.5], 'xtick', [0,1], 'xticklabel', {'non-moving', 'moving'})
ylabel('Parameter')
grid on

% Display mean of means and sem
disp(['N = ', num2str(numel(unique(animal_ids)))])
disp(['Moving: ', num2str(mean(parameter_moving)), ' +- ', num2str(std(parameter_moving)/sqrt(numel(parameter_moving))), ' Hz']) 
disp(['Not moving: ', num2str(mean(parameter_not_moving)), ' +- ', num2str(std(parameter_not_moving)/sqrt(numel(parameter_not_moving))), ' Hz']) 

% Compute statistics
[p, h, stats] = signrank(parameter_not_moving,parameter_moving);
