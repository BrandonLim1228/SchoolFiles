% Brandon Lim
% u1244501

clear, clc, close all

distance = [1.5 2.5 3.5 4.5 5.5 6.5 7.5 8.5 9.5 10.5 11.5 12.5 13.5 14.5 15.5];
voltage = [5 5 5 5 3.9 3.4 3.1 2.9 2.8 2.75 2.7 2.65 2.6 2.6 2.6];

figure
plot(distance, voltage, "-o")
xlabel("Distance [cm]")
ylabel("Voltage [V]")
title("Distance from Hall Sensor vs Sensor Voltage | Brandon Lim u1244501");
ylim([2, 5.5])

%% 2
clear, clc, close all

angle = [0:30:360];
voltage = [2.4 4.21 4.88 5 4.62 3.67 2.41 0.92 0.003 0.003 0.04 1.10 2.45];

figure
plot(angle,voltage, "o")
xlabel("Angle of Magnet in Comparison to Sensor [degree]")
ylabel("Sensor Voltage [V]")
title("Angle vs Sensor Voltage | Brandon Lim u1244501")

hold on
plot(angle, 2.7*sind(angle) + 2.45)
text(250,5,"V = 2.7 * sin(angle) + 2.45")


%% 3
clear, clc, close all
blueBlock = readmatrix("BLUEdata.csv");
for i = 1:3
    blueXBar(i) = mean(blueBlock(:,i));
    blueSTD(i) = std(blueBlock(:,i));
end
blueXBar
blueSTD

yellowBlock = readmatrix("YELLOWdata.csv");
for i = 1:3
    yellowXBar(i) = mean(yellowBlock(:,i));
    yellowSTD(i) = std(yellowBlock(:,i));
end
yellowXBar
yellowSTD

redBlock = readmatrix("REDdata.csv");
for i = 1:3
    redXBar(i) = mean(redBlock(:,i));
    redSTD(i) = std(redBlock(:,i));
end
redXBar
redSTD

for i = 1:3
    bluemax(i) = blueXBar(i) + (3 * blueSTD(i));
    bluemin(i) = blueXBar(i) - (3 * blueSTD(i));
    yellowmax(i) = yellowXBar(i) + (3 * yellowSTD(i));
    yellowmin(i) = yellowXBar(i) - (3 * yellowSTD(i));
    redmax(i) = redXBar(i) + (3 * redSTD(i));
    redmin(i) = redXBar(i) - (3 * redSTD(i));
end

bluemax
bluemin
yellowmax
yellowmin
redmax
redmin

