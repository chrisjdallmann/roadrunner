function [kernel, lags] = compute_wiener_kernel(input,output,sampling_rate,filter_width)
%COMPUTE_WIENER_KERNEL computes the Wiener kernel between an input and output signal
% 
%   kernel = COMPUTE_WIENER_KERNEL(input, output, sampling_rate) 
%   estimates a continuous spike rate from spike times using Gaussian kernel smoothing
%   
%   input         = vector of inputs  
%   output        = vector of outputs 
%   sampling_rate = sampling rate of input and output signal in Hz
% 
%   CJ Dallmann, University of Wuerzburg, 05/2025
% 
%   Code based on Yang et al. (2024), Cell, https://doi.org/10.1016/j.cell.2024.08.033

% % Example data
% filter_width = 1;
% sampling_rate = 100;
% time = 0:1/sampling_rate:50;
% input = sin(2*pi*(time-0.2));
% output = sin(2*pi*time);

window_samples = filter_width*sampling_rate;
n_segments = length(input) - window_samples + 1;
input_segments = zeros(n_segments, window_samples);
output_segments = input_segments;

% Loop over segments
for segment = 1:n_segments
    end_index = segment + window_samples - 1;
    input_segments(segment,:) = input(segment:end_index);
    output_segments(segment,:) = output(segment:end_index);
end

% Convert into frequency domain
n = 2^nextpow2(2*window_samples-1);
in_fft = fft(input_segments, n, 2);
out_fft = fft(output_segments, n, 2);
in_conj = conj(in_fft); % Complex conjugate of input

% Calculate first-order Wiener kernel (<Y(w)X*(w)>/<X(w)X*(w)>)
numerator = mean(out_fft .* in_conj, 1);
denominator = mean(in_fft .* in_conj, 1);
    
kernelFFT = numerator ./ denominator;
   
kernelTime = real(ifft(kernelFFT,[],2));
    
% Keep only lags we want and move negative lags before positive lags
max_length = window_samples-1;
kernel = [kernelTime(n - max_length + (1:max_length)), kernelTime(1:max_length+1)];
    
% Calculate lags
lags = ([fliplr(1:max_length) * -1, 0:max_length]) / sampling_rate;

end