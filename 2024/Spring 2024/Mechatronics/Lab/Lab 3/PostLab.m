clear, clc, close all
load('Lab3SquareWave.mat'); %Loading Data

subplot(2,1,1)
plot(timeData,rawData(:,1)) %Plotting the voltage vs the time
title("Voltage vs Time")
ylabel("Magnitude [V]")
xlabel("Time [s]")

sample_rate = 500; %initializing a sample rate
[ Mag, Phase, freq ] = fft_sample(rawData, sample_rate ); %doing a fast fourier transform to find magnitude, phase, and frequency of the data

subplot(2,1,2)
plot(freq,Mag) %Plotting freq vs magnitude for spectral analysis
title("Frequency vs Magnitude")
ylabel("Magnitude [Volts]")
xlabel("Frequency [Hz]")
text(150,5.5,"Brandon Lim u1244501")
%%
clear, clc, close all
load('Lab3SquareWave.mat');
%Reconstructing with harmonics
G = fft(rawData); %Fast foward Transform of the data

%Only indexing first five harmonics of data
Gfive = G; 
Gfive(100:end) = 0;

%Indexing first ten harmonics of data
Gten = G;
Gten(200:end) = 0;

%inversing the fast fourier transform of our individual harmonic data sets
%to get 
yfiveH = ifft(Gfive);
ytenH = ifft(Gten);
y = ifft(G)
x = timeData

figure
plot(x,real(yfiveH) .* 2,"k")
hold on
plot(x,real(yfiveH) .* 2,"r")
hold on
plot(x,real(y),"g")
legend("5 Harmonics","10 Harmonics","All Harmonics")
title("Brandon Lim U1244501 Approximations of Data Using Different #Harmonics")
xlabel("Time[s]")
ylabel("Voltage [V] hello")
text(0.6,-5.5,"Brandon Lim u1244501")
%%
clear, clc
Measured = [125 250 374 494 388 259 133 1 136 222 370 492 362 239 135 1];
Actual = [125 250 374 505 610 741 866 1000 1135 1222 1370 1492 1638 1761 1865 2000];
plot(Actual, Measured)
xlabel("Actual Frequency [Hz]")
ylabel("Measured Frequency [Hz]")
title("Actual vs Measured Frequency")
text(0,10,"Brandon Lim u1244501")








