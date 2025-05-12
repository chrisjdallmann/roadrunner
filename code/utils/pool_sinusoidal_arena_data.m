% POOL_SINUSOIDAL_ARENA_DATA.m pools TRex data 
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

% Settings
config.data_dir = 'C:\Users\Chris\Desktop\RR\sinusoidal_stimuli\';
config.folder_names = { ...
    '2025-04-30_male_01_int9_light_1500', ...
    '2025-04-30_male_02_int9_light_1530', ...
    '2025-04-30_male_03_int9_light_1600'};
config.animal_ids = [1,2,3];
config.animal_sex = {'male','male','male'};

config.stimulus_duration = 5; % s
config.pre_duration = 5; % s
config.inter_duration = 5; % s
config.n_repetitions = 10;

config.daq_sampling_rate = 1000; % Hz
config.camera_sampling_rate = 20; % Hz

config.trial_duration = config.pre_duration + (config.stimulus_duration + config.inter_duration) * config.n_repetitions; 

% Initialize data structure
data_pooled.intensity = [];
data_pooled.animal_id = [];
data_pooled.animal_sex = [];
data_pooled.trial = [];
data_pooled.frame = [];
data_pooled.time = [];
% data_pooled.stimulus = [];
data_pooled.n_stimulus = [];
data_pooled.n_inter_stimulus_interval = [];
data_pooled.speed = [];

% Loop over folders
for folder = 1:length(config.folder_names)
    folder_name = config.folder_names{folder};

    dir_names = dir([config.data_dir,folder_name,'\*.mat']);
    trial_names = [];
    for trial = 1:length(dir_names)
        trial_names{trial} = dir_names(trial).name(1:end-4);
    end 
    clearvars dir_names

    % Loop over trials
    for trial = 1:length(trial_names)
        trial_name = trial_names{trial};
        n_frames = config.trial_duration*config.camera_sampling_rate;

        % Process tracking data
        T = readtable([config.data_dir,folder_name,'\',trial_name,'_camera_01_fly0.csv']); 
        speed = T.SPEED_wcentroid_cm_s_;
        speed = speed*10; % mm/s
        clearvars T
                
        % Process stimulus data
        load([config.data_dir,folder_name,'\',trial_name,'.mat']);
        intensity = trial_data.Dev2_ai1;
        clearvars trial_data
        intensity = intensity(1:config.daq_sampling_rate/config.camera_sampling_rate:end);
        intensity = intensity(1:n_frames);

        % Correct for missing values at the end
        if numel(speed)<n_frames
            speed = [speed; repmat(speed(end),n_frames-numel(speed),1)];
            intensity = [intensity; repmat(intensity(end),n_frames-numel(speed),1)];
        end

        % stimulus = zeros(n_frames,1);
        n_stimulus = zeros(n_frames,1);
        n_inter_stimulus_interval = zeros(n_frames,1);
        offset = 0;
        for repetition = 1:config.n_repetitions
            previous_offset = offset;
            if repetition == 1
                onset = config.pre_duration * config.camera_sampling_rate;
            else
                onset = previous_offset+1 + config.inter_duration*config.camera_sampling_rate;
            end
            offset = onset + (config.stimulus_duration)*config.camera_sampling_rate-1;

            % stimulus(onset:offset) = 1;
            n_stimulus(onset:offset,1) = repetition + config.n_repetitions*(trial-1);

            if repetition == config.n_repetitions
                next_onset = n_frames-1;
            else
                next_onset = offset+1 + config.inter_duration*config.camera_sampling_rate-1;
            end
            n_inter_stimulus_interval(offset+1:next_onset,1) = repetition + config.n_repetitions*(trial-1);

        end
        clearvars offset previous_offset onset next_onset

        % Populate data structure
        data_pooled.intensity = [data_pooled.intensity; intensity]; 
        data_pooled.animal_id = [data_pooled.animal_id; repmat(config.animal_ids(folder),n_frames,1)]; 
        data_pooled.animal_sex = [data_pooled.animal_sex; repmat(config.animal_sex(folder),n_frames,1)];
        data_pooled.trial = [data_pooled.trial; repmat(trial,n_frames,1)];
        data_pooled.frame = [data_pooled.frame; (1:n_frames)'];
        dt = 1/config.camera_sampling_rate;
        data_pooled.time = [data_pooled.time; linspace(dt,dt*n_frames,n_frames)'];
        % data_pooled.stimulus = [data_pooled.stimulus; n_stimulus];
        data_pooled.n_stimulus = [data_pooled.n_stimulus; n_stimulus];
        data_pooled.n_inter_stimulus_interval = [data_pooled.n_inter_stimulus_interval; n_inter_stimulus_interval];
        data_pooled.speed = [data_pooled.speed; speed];

        clearvars trial_name speed stimulus stimulus_number n_stimulus n_inter_stimulus_interval dt
    end
    clearvars folder_name trial_names
end
clearvars folder

% Save as csv
T = struct2table(data_pooled);
writetable(T,'Roadrunner_sinusoidal.csv')
disp('Data saved as Roadrunner_sinusoidal.csv')
