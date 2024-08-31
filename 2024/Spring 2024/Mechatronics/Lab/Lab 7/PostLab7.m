% Brandon Lim u1244501
% Post Lab 7
clear,clc,close all

underfiltered = load("UnderFiltered.mat").rawdata;
tunder = underfiltered(:,1);
underraw = underfiltered(:,2)./(10.^5);
underfil = underfiltered(:,3)./(10.^5);

wellfiltered = load("WellFiltered.mat").rawdata;
twell = wellfiltered(:,1);
wellraw = wellfiltered(:,2)./(10.^5);
wellfil = wellfiltered(:,3)./(10.^5);

overfiltered = load("OverFiltered.mat").rawdata;
tover = overfiltered(:,1);
overraw = overfiltered(:,2)./(10.^5);
overfil = overfiltered(:,3)./(10.^5);

subplot(3,1,1)

%underfiltered
plot(tunder,underraw,".")
hold on
plot(tunder,underfil,".")
xlabel("Time[s]")
ylabel("Voltage [V]")
title("Voltage vs Time | Brandon Lim u1244501")
legend("Raw Data", "IIR-Alpha = 0.9")

subplot(3,1,2)
%wellfiltered
plot(twell,wellraw,".")
hold on
plot(twell,wellfil,".")
xlabel("Time[s]")
ylabel("Voltage [v]")
title("Voltage vs Time | Brandon Lim u1244501")
legend("Raw Data", "IIR-Alpha = 0.1")

subplot(3,1,3)
%overfiltered
plot(tover,overraw,".")
hold on
plot(tover,overfil,".")
xlabel("Time[s]")
ylabel("Voltage [v]")
title("Voltage vs Time | Brandon Lim u1244501")
legend("Raw Data", "IIR-Alpha = 0.001")

%% Brandon Lim u1244501
clear, clc, close all

sensorVol = [1.9 1.46 1.185 0.825 0.623 0.5 0.319 0.234 0.158 0.097 0.06 0.05];
dist = [2 3 4 6 8 10 14 18 22 26 30 34];

figure
plot(dist,sensorVol,"-o")
xlabel("Distance [cm]")
ylabel("Sensor Voltage [v]")
title("Sensor Voltage vs Distance | Brandon Lim u1244501")

%% Brandon Lim u1244501
clear, clc, close all

actualdis = [2.5 3.5 5 7 9 12 16 20 24 28 32 36];
compdis = [3.32 4.03 5.15 6.51 8.27 11 14.5 22.6 25.35 28.77 38.65 55.8];

figure
plot(actualdis,compdis,"o")
xlabel("Actual Distance [cm]")
ylabel("Computed Distance [cm]")
title("Actual Distance vs Computed Distance | Brandon Lim u1244501")

















