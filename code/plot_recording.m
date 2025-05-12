% PLOT_RECORDING.m plots electrophysiology and treadmill data of a specific recording 
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

clc, clear

% Load data
load('Z:\Data\Roadrunner\Electrophysiology_treadmill\walking_data.mat')

% Set recording
recording = 1;

% Plot data
figure
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
    spike_events = data(recording).spike_events;
    sampling_rate = 20000;
    width = 2; % s
    sd = 0.2; % s
    scaling_factor = 2;
    spike_rate = compute_spike_rate(spike_events, width*sampling_rate, sd*sampling_rate, scaling_factor);
    plot(data(recording).time_ephys, spike_rate, 'k')
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