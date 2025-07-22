% EPHYS_PLOT_RECORDING.m plots electrophysiology and treadmill data of a specific recording 
% 
% Files required: 
%    walking_data.mat
%
% Functions/packages required:
% 

% Author: Chris J. Dallmann 
% Affiliation: University of Wuerzburg
% Last revision: 21-July-2025

% ------------- BEGIN CODE -------------

%clear
%clc

% Load data
%dataset = 'treadmill_ephys_rr_gfp_flight.mat';
%load(['Z:\Data\Roadrunner\',dataset])

% Set recording
recording = 14;

% Plot data
figure
disp(data(recording).file)

if contains(dataset,'walking')
    s1 = subplot(511);
else
    s1 = subplot(411);
end
    hold on
    plot(data(recording).time_ephys, data(recording).membrane_potential, 'k')
    membrane_potential_filt = smooth(data(recording).membrane_potential, 0.02*20000);
    plot(data(recording).time_ephys, membrane_potential_filt, 'color', [.5,.5,.5])
    plot(data(recording).time_ephys(data(recording).spike_events>0), data(recording).membrane_potential(data(recording).spike_events>0), 'mo')
    hold off
    set(gca,'Color','none','XTickLabel','','ylim',[min(data(recording).membrane_potential)-2, max(data(recording).membrane_potential)+2])
    ylabel('Voltage (mv)')
    grid on
    box off

if contains(dataset,'walking')
    s2 = subplot(512);
else
    s2 = subplot(412);
end
    spike_events = data(recording).spike_events;
    sampling_rate = 20000;
    
    % Convolved spike rate 
    sd = 0.15; % s
    spike_rate = ephys_compute_spike_rate(spike_events, sampling_rate, sd);
    plot(data(recording).time_ephys, spike_rate, 'k')   
    
    set(gca,'Color','none','XTickLabel','')
    ylabel('Spike rate (Hz)')
    grid on
    box off

if contains(dataset,'walking')
    s3 = subplot(513);
    plot(data(recording).time_treadmill, data(recording).movement, 'k')
else
    s3 = subplot(413);
    plot(data(recording).time_ephys, data(recording).movement, 'k')
end
    set(gca,'Color','none','XTickLabel','','ytick',[0,1],'ylim',[-.5,1.5])
    ylabel('Moving')
    grid on
    box off

if contains(dataset,'walking')
    s4 = subplot(514);
    plot(data(recording).time_treadmill, data(recording).translational_speed, 'k')
    set(gca,'Color','none','XTickLabel','','ylim',[-.5,15])
    ylabel('Translational speed (mm/s)')
else
    s4 = subplot(414);
    hold on
    plot(data(recording).time_ephys, data(recording).tachometer, 'k')
    plot(data(recording).time_ephys(data(recording).wingbeats), data(recording).tachometer(data(recording).wingbeats), 'mo')
    set(gca,'Color','none','ylim',[-10,10])
    ylabel('Tachometer')
    xlabel('Time (s)')

    linkaxes([s1,s2,s3,s4],'x')
end
    grid on
    box off

if contains(dataset,'walking')
    s5 = subplot(515);
    plot(data(recording).time_treadmill, data(recording).rotational_speed, 'k')
    set(gca,'Color','none','ylim',[-.5,300])
    ylabel('Rotational speed (mm/s)')
    set(gca,'Color','none')
    xlabel('Time (s)')
    grid on
    box off

    linkaxes([s1,s2,s3,s4,s5],'x')
end

%zoom_in = [280,340];
%set(s1,'xlim',zoom_in)
