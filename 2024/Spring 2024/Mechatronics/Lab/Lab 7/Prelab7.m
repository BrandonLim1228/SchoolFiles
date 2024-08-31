%Brandon Lim
%PreLab7
clear, clc, close all

load("Lab7_prelab4_noisydata.mat");

YIIRa = IIR_WA(data(:,2), 0.25);
YIIRb = IIR_WA(data(:,2), 0.1);
YFIRc = FIR_MA(data(:,2), 8);
YFIRd = FIR_MA(data(:,2), 25);

figure
plot(data(:,1),data(:,2)); %Raw Data
hold on 
plot(data(:,1), YIIRa) %IIR, alpha = 0.25
hold on 
plot(data(:,1), YIIRb) %IIR, alpha = 0.1
hold on 
plot(data(:,1), YFIRc) %FIR, N = 8
hold on 
plot(data(:,1), YFIRd) %FIR, N = 25

xlabel("Time [sec]");
ylabel("Voltage [V]");
title("Voltage vs Time | Brandon Lim u1244501")
legend("Unfiltered Data", "IIR: alpha = 0.25", "IIR: alpha = 0.1", "FIR:N = 8","FIR:N = 25")
