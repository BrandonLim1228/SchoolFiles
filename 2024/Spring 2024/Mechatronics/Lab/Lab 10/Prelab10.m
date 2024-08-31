%Brandon Lim u1244501
clear, clc, close all
load("Lab10_motordata.mat");

figure
plot(((Speed./(2*pi)).*60),Torque,".")
xlabel("Speed [RPM]")
ylabel("Torque [N-m]")
title("Speed vs Torque | Brandon Lim u1244501")
hold on
plot(Speed(end),Torque(end), "ro")
plot((Speed(1)/(2*pi)*60),Torque(1), "ko")
fit1 = fitlm(((Speed./(2*pi)).*60),Torque)
plot(((Speed./(2*pi)).*60),(0.10321-0.00023674.*(((Speed./(2*pi)).*60))))
hold off
NoLoad = 0.10321/0.00023674
Tstall = 0.10321
legend("","Stall Torque = 0.1032 Nm","No Load Speed = 435.96")

figure
eta = (Torque .* Speed) ./ (Volt .* Current);
plot(((Speed./(2*pi)).*60),eta,".") 
xlabel("Speed [RPM]")
ylabel("Efficiency")
title("Speed vs Efficiency | Brandon Lim u1244501")