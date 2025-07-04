% EPHYS_PLOT_RECORDING.m plots electrophysiology and treadmill data of a specific recording 
% 
% Files required: 
%    walking_data.mat
%
% Functions/packages required:
% 

% Author: Chris J. Dallmann 
% Affiliation: University of Wuerzburg
% Last revision: 04-July-2025

% ------------- BEGIN CODE -------------

clear
clc

% Load data
load('Z:\Data\Roadrunner\ephys_walking.mat')

% Set recording
recording = 1;

% Plot data
figure
disp(data(recording).file)

s1 = subplot(511);
    hold on
    plot(data(recording).time_ephys, data(recording).membrane_potential, 'k')
    plot(data(recording).time_ephys(data(recording).spike_events>0), data(recording).membrane_potential(data(recording).spike_events>0), 'mo')
    hold off
    set(gca,'Color','none','XTickLabel','','ylim',[min(data(recording).membrane_potential)-2, max(data(recording).membrane_potential)+2])
    ylabel('Voltage (mv)')
    grid on
    box off

s2 = subplot(512);
    hold on
    spike_events = data(recording).spike_events;
    sampling_rate = 20000;
    
    % Convolved spike rate 
    sd = 0.15; % s
    spike_rate = ephys_compute_spike_rate(spike_events, sampling_rate, sd);
    plot(data(recording).time_ephys, spike_rate, 'k')    

    set(gca,'Color','none','XTickLabel','')
    ylabel('Predicted spike rate (Hz)')
    grid on
    box off

s3 = subplot(513);
    hold on
    plot(data(recording).time_treadmill, data(recording).movement, 'k')
    set(gca,'Color','none','XTickLabel','','ytick',[0,1],'ylim',[-.5,1.5])
    ylabel('Moving')
    grid on
    box off

s4 = subplot(514);
    plot(data(recording).time_treadmill, data(recording).translational_speed, 'k')
    set(gca,'Color','none','XTickLabel','','ylim',[-.5,10])
    ylabel('Translational speed (mm/s)')
    grid on
    box off

s5 = subplot(515);
    plot(data(recording).time_treadmill, data(recording).rotational_speed, 'k')
    set(gca,'Color','none','ylim',[-.5,300])
    ylabel('Rotational speed (mm/s)')
    xlabel('Time (s)')
    grid on
    box off

linkaxes([s1,s2,s3,s4,s5],'x')
