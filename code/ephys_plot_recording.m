% EPHYS_PLOT_RECORDING.m plots electrophysiology and treadmill data of a specific recording 
% 
% Files required: 
%    walking_data.mat
%
% Functions/packages required:
% 

% Author: Chris J. Dallmann 
% Affiliation: University of Wuerzburg
% Last revision: 30-June-2025

% ------------- BEGIN CODE -------------

%clc, clear

% Load data
%load('Z:\Data\Roadrunner\Electrophysiology_treadmill\walking_data.mat')

% Set recording
clc
recording = 1;

% Plot data
figure
disp(data(recording).file)
s1 = subplot(511);
    hold on
    plot(data(recording).time_ephys, data(recording).membrane_potential, 'k')
    plot(data(recording).time_ephys(data(recording).spike_events>0), data(recording).membrane_potential(data(recording).spike_events>0), 'mo')
    hold off
    set(gca,'Color','none','XTickLabel','')
    ylabel('Voltage (mv)')
    grid on
    box off
s2 = subplot(512);
    hold on
    spike_events = data(recording).spike_events;
    sampling_rate = 20000;
    
    sd = 0.1; % s
    spike_rate = ephys_compute_spike_rate(spike_events, sampling_rate, sd);
    plot(data(recording).time_ephys, spike_rate, 'g')

    sd = 0.15; % s
    spike_rate = ephys_compute_spike_rate(spike_events, sampling_rate, sd);
    plot(data(recording).time_ephys, spike_rate, 'b')

    win_size = 0.25; % s
    binned_spike_rate = [];
    n_win = 1;
    for win = 1 : win_size*sampling_rate : numel(spike_events)
        if (win+win_size*sampling_rate) < numel(spike_events)
            binned_spike_rate(n_win,:) = sum(spike_events(win:win+win_size*sampling_rate));
            n_win = n_win+1;
        end
    end
    binned_spike_rate = binned_spike_rate/win_size;
    time_binned = data(recording).time_ephys(1 : win_size*sampling_rate : numel(spike_events));
    plot(time_binned(1:end-1), binned_spike_rate, 'c')

    set(gca,'Color','none','XTickLabel','')
    ylabel('Predicted spike rate (Hz)')
    grid on
    box off
s3 = subplot(513);
    plot(data(recording).time_treadmill, data(recording).movement, 'k')
    set(gca,'Color','none','XTickLabel','','ytick',[0,1])
    ylabel('Moving')
    grid on
    box off
s4 = subplot(514);
    plot(data(recording).time_treadmill, data(recording).translational_speed, 'k')
    set(gca,'Color','none','XTickLabel','')
    ylabel('Translational speed (mm/s)')
    grid on
    box off
s5 = subplot(515);
    plot(data(recording).time_treadmill, data(recording).rotational_speed, 'k')
    set(gca,'Color','none')
    ylabel('Rotational speed (mm/s)')
    xlabel('Time (s)')
    grid on
    box off
linkaxes([s1,s2,s3,s4,s5],'x')

display(numel(find(diff(data(recording).movement)>0)))