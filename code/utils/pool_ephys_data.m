% POOL_EPHYS_DATA.m pools electrophysiology data 
% 
% Files required: 
%
% Functions/packages required:
% 

% Author: Chris J. Dallmann 
% Affiliation: University of Wuerzburg
% Last revision: 12-May-2025

% ------------- BEGIN CODE -------------

clear, clc

% Load data
load('Z:\Data\Roadrunner\Electrophysiology_treadmill\walking_data_orig.mat')

data = [];

% Set sampling rates 
ephys_sampling_rate = 20000;
treadmill_sampling_rate = 50;
dt_ephys = 1/ephys_sampling_rate;
dt_treadmill = 1/treadmill_sampling_rate;

recordings = 1:numel(analysis);

% Loop over recordings
for recording = recordings

    % Get velocities 
    forward_velocity = analysis(recording).xvelocity_in_mm;
    lateral_velocity = analysis(recording).yvelocity_in_mm;
    rotational_velocity = analysis(recording).zvelocity_in_degree_per_s;
    
    % Downsample velocities
    forward_velocity = forward_velocity(1 : ephys_sampling_rate/treadmill_sampling_rate : end);
    lateral_velocity = lateral_velocity(1 : ephys_sampling_rate/treadmill_sampling_rate : end);
    rotational_velocity = rotational_velocity(1 : ephys_sampling_rate/treadmill_sampling_rate : end);

    n_frames = length(forward_velocity);
        
    % Filter out baseline noise
    filter_span = 0.3; % s
    forward_velocity_filt = smooth(forward_velocity, filter_span/dt_treadmill);
    lateral_velocity_filt = smooth(lateral_velocity, filter_span/dt_treadmill);
    rotational_velocity_filt = smooth(rotational_velocity, filter_span/dt_treadmill);

    % Calculate translational speed
    translational_speed_filt = abs(forward_velocity_filt) + abs(lateral_velocity_filt);
    
    % Calculate rotational speed
    rotational_speed_filt = abs(rotational_velocity_filt);

    % Detect bouts based on speed
    movement = zeros(n_frames,1);
    
        % Detect frames where translational or rotational speed is above
        % threshold
        translational_speed_thresh = 0.5; % mm/s
        rotational_speed_thresh = 10; % deg/s
        
        translational_movement = movement;
        rotational_movement = movement;
        
        translational_movement(translational_speed_filt > translational_speed_thresh) = 1;
        rotational_movement(rotational_speed_filt > rotational_speed_thresh) = 1;
        
        movement(translational_movement==1 | rotational_movement==1) = 1;
    
        % Fill short gaps 
        % (Adds a few extra bouts; see trial 13 for an example) 
        win_size = 0.1; % s
        movement = binary_replace_filter(movement, win_size/dt_treadmill);
        
        % Filter out short bouts
        win_size = 0.3; % s
        movement_fwd = binary_hysteresis_filter(movement, win_size/dt_treadmill);
        movement_bwd = binary_hysteresis_filter(flipud(movement), win_size/dt_treadmill);
        movement = double(movement_fwd | flipud(movement_bwd));

    % Create time vectors
    time_treadmill = linspace(0,dt_treadmill*n_frames, n_frames)';

    n_frames_ephys = numel(analysis(recording).vm_smooth);
    time_ephys = linspace(0,dt_ephys*n_frames_ephys, n_frames_ephys)';

    % Store data
    data(recording).file = analysis(recording).file;
    data(recording).membrane_potential = analysis(recording).vm_smooth;
    data(recording).spike_events = analysis(recording).spikes_filt;
    data(recording).forward_velocity = forward_velocity_filt;
    data(recording).lateral_velocity = lateral_velocity_filt;
    data(recording).rotational_velocity = rotational_velocity_filt;
    data(recording).translational_speed = translational_speed_filt;
    data(recording).rotational_speed = rotational_speed_filt;
    data(recording).movement = movement;
    data(recording).time_ephys = time_ephys; % Note: 'time' adds about 200 MB
    data(recording).time_treadmill = time_treadmill;

end

%save('C:\Users\Chris\Desktop\Sirin\walking_data.mat', 'data', '-v7.3')
