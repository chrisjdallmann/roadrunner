function spike_rate = compute_spike_rate(spike_events, width, sd, scaling_factor)
%COMPUTE_SPIKE_RATE estimates a continuous spike rate from spike times using Gaussian kernel smoothing 
% 
%   spike_rate = COMPUTE_SPIKE_RATE(spike_events, width, sd, scaling_factor) 
%   estimates a continuous spike rate from spike times using Gaussian kernel smoothing
%   
%   spike_events   = vector of spike rate  
%   width          = width of Gaussian kernel in samples 
%   sd             = standard deviation of Gaussian kernel in samples
%   scaling_factor = scaling_factor for spike rate
% 
%   CJ Dallmann, University of Wuerzburg, 05/2025

alpha = (width-1) / (2*sd);
w = gausswin(width, alpha);
% w = w/sum(w);
w = w * scaling_factor; 
spike_rate = conv(spike_events, w, 'same');

end