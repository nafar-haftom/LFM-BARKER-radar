%% Barker with TARGET
clear
clc
close all

% Create PhaseCodedWaveform object
myWav = phased.PhaseCodedWaveform('Code', 'Barker')

% Generate Barker coded sinusoidal signal
x = step(myWav);
figure;
plot(x)
title('Barker coded sinusoidal Signal')
xlabel('t') 
ylabel('Amplitude Barker Signal') 
figure;
ambgfun(x,myWav.SampleRate,myWav.PRF,'Cut','Doppler')
xlabel('frequency') 
ylabel('Amplitude of Barker Signal in Fourier') 
% Design a stationary target at 10Mm
targetRange = 10000000; % Range to the target (m)
c = physconst('LightSpeed'); % Speed of light (m/s)
targetDelay = 2 * targetRange / c; % Calculate delay

% Apply delay to the signal
targetSignal = circshift(x, round(targetDelay * myWav.SampleRate));
% Signal Attenuation
targetSignal = targetSignal/10;
% Add collision with target to white noise
SNR_dB = 10; % Desired SNR (in dB)
signalPower = mean(abs(targetSignal).^2);
noisePower = signalPower / (10^(SNR_dB/10));
disp("noise pwer is:")
disp(noisePower)
% Generate white Gaussian noise
noise = sqrt(noisePower) * randn(size(targetSignal));

% Add noise to the target signal
noisySignal = targetSignal + noise;
figure;
plot(noisySignal)
title('Signal with noise')
xlabel('t') 
ylabel('Amplitude Barker Signal with white noise') 
% Convert data type to numeric
noisySignal = double(noisySignal);
barkerCode = double(x);

% Pass the signal through a match filter
matchedSignal = conv(noisySignal, fliplr(barkerCode), 'same');
figure;
plot(matchedSignal)
title('Signal after Matched Filter')
xlabel('t') 
ylabel('Amplitude of Matched Filter') 
% Calculate the output SNR
outputSNR_dB = 10 * log10(mean(abs(matchedSignal).^2) / noisePower);

disp("output SNR is:")
disp(outputSNR_dB)
%% without TARGET
% Create PhaseCodedWaveform object
myWav = phased.PhaseCodedWaveform('Code', 'Barker')

% Generate Barker coded sinusoidal signal
x = step(myWav);
figure;
plot(x)
title('Barker coded sinusoidal Signal')
xlabel('t') 
ylabel('Amplitude Barker Signal') 
figure;
ambgfun(x,myWav.SampleRate,myWav.PRF,'Cut','Doppler')
xlabel('frequency') 
ylabel('Amplitude of Barker Signal in Fourier') 
% input noise
noisePower = 4e-4;
disp("noise pwer is:")
disp(noisePower)
%generating noise
noisySignal = wgn (1,length(x), 10*log(noisePower));
figure;
plot(noisySignal)
title('Signal with noise')
xlabel('t') 
ylabel('Amplitude Barker Signal with white noise') 
% Convert data type to numeric
noisySignal = double(noisySignal);
barkerCode = double(x);

% Pass the signal through a match filter
matchedSignal = conv(noisySignal, fliplr(barkerCode), 'same');
figure;
plot(matchedSignal)
title('Signal after Matched Filter')
xlabel('t') 
ylabel('Amplitude of Matched Filter') 
% Calculate the output SNR
outputSNR_dB = 10 * log10(mean(abs(matchedSignal).^2) / noisePower);

disp("output SNR is:")
disp(outputSNR_dB)


