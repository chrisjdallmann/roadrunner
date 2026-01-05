% EPHYS_PLOT_RECORDING.m plots electrophysiology and treadmill data of a specific recording 
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
dataset = 'treadmill_ephys_rrn_gfp_pushing.mat';
recording = 1;

% Load data
load(['..\data\',dataset])

% Plot data
f = figure;
disp(data(recording).experiment)

if contains(dataset,'walking')
    n_panels = 5;
elseif contains(dataset,'flight')
    n_panels = 4;
elseif contains(dataset,'pushing')
    n_panels = 3;
end
s1 = subplot(n_panels,1,1);
    hold on
    plot(data(recording).time_ephys, data(recording).membrane_potential, 'k')
    plot(data(recording).time_ephys(data(recording).spike_events), data(recording).membrane_potential(data(recording).spike_events), 'm.')
    hold off
    set(gca,'Color','none','XTickLabel','','ylim',[min(data(recording).membrane_potential)-2, max(data(recording).membrane_potential)+2])
    ylabel('Voltage (mV)')
    grid on
    box off

s2 = subplot(n_panels,1,2);
    plot(data(recording).time_ephys, data(recording).spike_rate, 'k')   
    
    set(gca,'Color','none','XTickLabel','')
    ylabel('Spike rate (Hz)')
    grid on
    box off

s3 = subplot(n_panels,1,3);
    plot(data(recording).time_ephys, data(recording).movement, 'k')
    set(gca,'Color','none','ytick',[0,1],'ylim',[-.5,1.5])
    ylabel('Moving')
    grid on
    box off
    if n_panels == 3
        xlabel('Time (s)')
        linkaxes([s1,s2,s3],'x')
    else
        set(gca,'XTickLabel','')
    end

if contains(dataset,'walking') || contains (dataset,'flight')
    s4 = subplot(n_panels,1,4);
    if contains(dataset,'walking')
        plot(data(recording).time_treadmill, data(recording).translational_speed, 'k')
        set(gca,'Color','none','XTickLabel','','ylim',[-.5, max(data(recording).translational_speed)+1])
        ylabel('Translational speed (mm/s)')
    else
        plot(data(recording).time_ephys, data(recording).tachometer, 'k')
        set(gca,'Color','none','ylim',[-10,10])
        ylabel('Tachometer')
    end
    grid on
    box off
    if n_panels == 4
        xlabel('Time (s)')
        linkaxes([s1,s2,s3,s4],'x')
    end
end
    
if contains(dataset,'walking')
    s5 = subplot(n_panels,1,5);
    plot(data(recording).time_treadmill, data(recording).angular_speed, 'k')
    set(gca,'Color','none','ylim',[-.5, max(data(recording).angular_speed)+10])
    ylabel('Angular speed (mm/s)')
    set(gca,'Color','none')
    xlabel('Time (s)')
    grid on
    box off
    linkaxes([s1,s2,s3,s4,s5],'x')
end

%zoom_in = [280,340];
%set(s1,'xlim',zoom_in)