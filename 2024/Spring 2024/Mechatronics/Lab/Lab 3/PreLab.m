clear, clc, close all
load('Lab3_prelab_6.mat');
sample_rate = 500; %Hz
[ Mag, phase, freq ] = fft_sample(data, sample_rate );

figure
plot(freq,Mag);
title("Frequency vs Magnitude")
ylabel("Magnitude [Volts]")
xlabel("Frequency [Hz]")
