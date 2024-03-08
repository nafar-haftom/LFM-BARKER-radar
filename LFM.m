% FMCW Radar Simulation with AWGN (Stationary Obstacle)
% Parameters
c = 3e8; % Speed of light (m/s)
f0 = 77e9; % Starting frequency (Hz)
B = 4e9; % Frequency sweep bandwidth (Hz)
Tp = 50e-6; % Sweep time (s)
Fs = 2*B; % Sampling frequency (Hz)
R = 100; % Range to the target (m)
SNRdB = 20; % Signal-to-Noise Ratio (in dB)
% Time and frequency vectors
t = 0:1/Fs:Tp-1/Fs; % Time vector
f = linspace(-Fs/2, Fs/2, length(t)); % Frequency vector
% Generate transmitted signal
Tx = cos(2*pi*(f0*t + (B/Tp/2)*t.^2)); % Transmitted signal
% Calculate the delay due to target range
tdelay = 2*R/c; % Delay due to target range
% Generate received signal with AWGN
Rx = cos(2*pi*(f0*(t - tdelay) + (B/Tp/2)*(t - tdelay).^2)); % Received signal without noise
noise = randn(size(Rx)); % AWGN
Rx = Rx + 10^(-SNRdB/20)*rms(Rx)*noise; % Received signal with AWGN
% filtering recived signal 
matched_filter = fliplr(conj(Tx)); % Matched filter template
RX = conv(Rx, matched_filter, 'same'); % Range compressed signal
% Perform signal processing
mixer_out = Tx .* Rx; % Mixing the transmitted and received signals
range_fft = fftshift(fft(mixer_out)); % Range FFT
% Find the peak in the range FFT
[~, peak_index] = max(abs(range_fft));
peak_frequency = f(peak_index);
% Calculate the estimated range
estimated_range = (c * peak_frequency * Tp) / (2 * B);
% Print the estimated range
disp(['Estimated Range: ' num2str(estimated_range) ' meters']);
% Plotting
figure;
plot(t, abs(range_fft).^2);
xlabel('Time');
ylabel('Amplitude');
title('Range FFT');
