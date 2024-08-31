% 2/26/24 Data
clear, clc, close all
distance = log([4:30]); %cm
sensor_value = log([525.9, 443, 387.5, 331, 292, 258, 223.5, 204.6, 180.6, 157.3, 140.5, 145, 137, 128, 120, 116, 108, 104, 99, 95, 92, 87, 84, 80, 76, 73]); %

plot(distance,sensor_value, "o")
xlabel("ln(distance)");
ylabel("ln(sensor value");
title("Distance vs Sensor Value");

%%
clear, clc, close all

actual_distance = ([4.5:30.5]); %cm

calculated_distance = [5, 5.77, 6.58, 7.46, 8.18, 9.26, 10.15, 11, 11.9, 12.8, 13.75, 14.8, 15.87, 17, 18.24, 18.89, 20.36, 21.18, 23, 24.06, 25.19, 26.43, 27.8, 29.3, 29.3, 30.5, 32.85]; %cm

plot(actual_distance,calculated_distance,"o");
xlabel("Actual Distance [cm]")
ylabel("Computed Distance [cm]")
title("Actual vs Computed Distance")