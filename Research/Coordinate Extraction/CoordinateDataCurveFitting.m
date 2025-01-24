clear, clc, close all
blueAirfoil = readmatrix("BlueAirfoil.txt")

figure
plot(blueAirfoil(:,1),blueAirfoil(:,2), ".")
grid on; grid minor