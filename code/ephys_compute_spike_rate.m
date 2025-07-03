function spike_rate = ephys_compute_spike_rate(spike_events, sampling_rate, sd)
%COMPUTE_SPIKE_RATE estimates a continuous spike rate from spike times using Gaussian kernel smoothing 
% 
%   spike_rate = EPHYS_COMPUTE_SPIKE_RATE(spike_events, sampling_rate, sd) 
%   estimates a continuous spike rate from spike times using Gaussian kernel smoothing
%   
%   spike_events   = binary vector with ones indicating spikes  
%   sampling_rate  = sampling rate in Hz 
%   sd             = standard deviation of Gaussian kernel in seconds
% 
%   CJ Dallmann, University of Wuerzburg, 07/2025

sd = sd*sampling_rate;
width = 4*sd*2; % Extend kernel to 4x standard deviation in each direction to avoid clipping

alpha = (width-1) / (2*sd);
w = gausswin(width, alpha);
w = w/sum(w);
spike_rate = conv(spike_events, w, 'same');
spike_rate = spike_rate / (1/sampling_rate);

end




