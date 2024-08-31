function [ Mag, Phase, freq ] = fft_sample_modified( data, sample_rate )
%Function does a fast fourier transform by inputing data(single sample set
%of  a signal) and sample rate (Sampling frequency in Hz) and outputting
%Magnitude(Volts), Phase(degrees), and frequency(Hz).

%Compute DFT using fft function
G = fft(data);

%Smallest measurable frequency
spectralResolution = sample_rate/length(data);

%Largest measurable frequency
f_Nyquist = sample_rate/2;

%Define range of frequencies
freq = 0:spectralResolution:f_Nyquist;

%Calculate magnitude in volts
Mag = abs(G(1:length(freq)))/length(data);
Mag(2:end-1) = 2*Mag(2:end-1);

%Calculate power of frequencies
Power = Mag.^2;

%Calculate Phase
Phase = angle(G)*180/pi;
end