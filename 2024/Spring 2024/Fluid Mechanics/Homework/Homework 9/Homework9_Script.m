%% 8.6
clear, clc, close all

D = 3/1000; %Diameter in m
T = [0 10 20 30 40 50 60 70 80 90 100]; %Celcius 
v = [(1.785*10^-6) (1.306*10^-6) (1.003*10^-6) (0.8*10^-6) (0.658*10^-6) (0.553*10^-6) (0.474*10^-6) (0.413*10^-6) (0.364*10^-6) (0.326*10^-6) (0.294*10^-6)]; %Kinematic Viscocity [m2/s]

Q = 5.42 .* v;

plot(T,Q)
xlabel("Temperature [\circC]")
ylabel("Flow Rate [m^3/s]")
title("Flow Rate vs Temperature for Laminar Flow")



