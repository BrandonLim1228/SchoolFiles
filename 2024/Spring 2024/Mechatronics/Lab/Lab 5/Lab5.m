% Brandon Lim
clear, clc, close all
%Low Pass Filter
w = logspace(0,5);
R = 4.6*1000; %ohms
C = 0.1 * 10^-6; %farads

freqVec = 2.*pi.*[10,20,40,150,338,500,700,1000,2000];
MagVec = [-0.14,-0.21,-0.428,-1.73,-4.08,-6.12,-8.36,-10.95,-16.43];
phaseVec = [-1.5, -3.079, -6.019, -21.54, -40.57, -51.31, -59.67, -66.4, -74];

wc = 1/(R*C); %Cutoff Frequency
magnitudeNorm = 1./sqrt(1+((w.^2)/(wc.^2)));
magnitudeDB = 20*log10(magnitudeNorm);

phaseShift = -atan(w./wc) .* 180./pi;

figure
subplot(2,1,1)
semilogx(w,magnitudeDB)
ylim([-40,2])
title("Frequency Response Plot of a Low-Pass Filter | Brandon Lim U1244501")
xlabel("Frequency [Hz]")
ylabel("Magnitude [dB]")
hold on 
subplot(2,1,1)
xline(wc)
hold on
subplot(2,1,1)
semilogx(freqVec,MagVec,"-o")
text(10^3,-30,0,"Fc")
legend("Theoretical","","Actual", "Location","southeast")

subplot(2,1,2)
semilogx(w,phaseShift)
ylim([-100,2])
xlabel("Frequency [Hz]")
ylabel("Phase Shift [deg]")
hold on 
subplot(2,1,2)
xline(wc)
hold on 
subplot(2,1,2)
semilogx(freqVec,phaseVec,"-o")
text(10^3,-60,0,"Fc")
legend("Theoretical","","Actual", "Location","northeast")

%% High Pass
clear, clc, close all
w = logspace(0,5);
R = 4.61*1000; %ohms
C = 0.1 * 10^-6; %farads

freqVec = 2.*pi.*[10,20,40,150,338,500,700,1000,2000];
MagVec = [-29.88 -26.38 -21.71 -11.45 -5.24 -3 -1.77 -0.935 -0.3];
phaseVec = [80 74.8 77.98 66.12 47.37 36.9 29.11 22.26 15.13];

wc = 1/(R*C); %Cutoff Frequency
magnitudeNorm = (w./wc)./(sqrt(1+((w.^2)/(wc^2))));
magnitudeDB = 20*log10(magnitudeNorm);

phaseShift = atan(wc./w) .* 180./pi;

figure
subplot(2,1,1)
semilogx(w,magnitudeDB)
ylim([-40,2])
title("Frequency Response Plot of a High-Pass Filter | Brandon Lim U1244501 ")
xlabel("Frequency [Hz]")
ylabel("Magnitude [dB]")
hold on 
subplot(2,1,1)
xline(wc)
hold on 
semilogx(freqVec,MagVec,"-o")
text(10^3,-30,0,"Fc")
legend("Theoretical","","Actual", "Location","southeast")


subplot(2,1,2)
semilogx(w,phaseShift)
ylim([-5,100])
xlabel("Frequency [Hz]")
ylabel("Phase Shift [deg]")
hold on 
subplot(2,1,2)
xline(wc)
hold on
semilogx(freqVec,phaseVec,"-o")
text(10^3,10,"Fc")
legend("Theoretical","","Actual", "Location","northeast")
