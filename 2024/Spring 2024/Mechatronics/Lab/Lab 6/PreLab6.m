%Brandon Lim
clear, clc, close all
freq = 1:1000;
freqEx = [1 5 10.26 20 50 100 1000]; %hz
Rtwo = 33000; %ohms
Rone = 10000; %ohms
c = 470*10^-9; %farads

wc = 1/(Rtwo * c * 2 * pi); %rad/sec
MagX = [10.26 9.27 7.34 3.61 -3.61 -8.84 -25.25];

mag = (Rtwo./Rone) .* (1./sqrt(1+(freq./wc).^2));
magDec = 20.*log10(mag);

phaseTheo = 180 - (atan(freq/wc) * (180/pi));
phaseEx = [175 154 136 118 100 97.5 88];

subplot(2,1,1)
semilogx(freq,magDec,"-k");
xlabel("Frequency [Hz]");
ylabel("Magnitude [dB]");
title("Frequency Vs Gain of a 1st Order LPF: Brandon Lim")
hold on 
semilogx(freqEx,MagX,"o")
hold on
xline(10.26)
legend("Theoretical", "Experimental", "CutOff Freq")

subplot(2,1,2)
semilogx(freq,phaseTheo)
xlabel("Frequency [Hz]");
ylabel("Phase Shift [deg]");
title("Frequency Vs Phase Shift of a 1st Order LPF: Brandon Lim")
hold on 
semilogx(freqEx,phaseEx,"o")
xline(10.26)
legend("Theoretical", "Experimental", "CutOff Freq")
%% Brandon Lim
clear, clc, close all

MagEx2 = [4.04 3.57 1.47 -6 -21.5 -31.2 -37.7];
MagEx1 = [10.26 9.27 7.34 3.61 -3.61 -8.84 -25.25];
freqEx = [1 5 10.26 20 50 100 1000];

phaseEx1 = [175 154 136 118 100 97.5 88];
phaseEx2 = [-7 -41 -82 -128 -160 -170 -177];

subplot(2,1,1)
semilogx(freqEx, MagEx1,"-or")
hold on 
semilogx(freqEx, MagEx2,"-ob")
xlabel("Frequency [Hz]");
ylabel("Magnitude [dB]");
title("Frequency Vs Gain of a 2nd Order LPF: Brandon Lim")
legend("1st Order LPF","2nd Order LPF")

subplot(2,1,2)
semilogx(freqEx, phaseEx1,"-or");
hold on 
semilogx(freqEx, phaseEx2,"-ob");
xlabel("Frequency [Hz]");
ylabel("Magnitude [dB]");
title("Frequency Vs Phase of a 2nd Order LPF: Brandon Lim")
legend("1st Order LPF","2nd Order LPF")
