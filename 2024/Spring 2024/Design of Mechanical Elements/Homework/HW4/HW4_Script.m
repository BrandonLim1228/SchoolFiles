%% Brandon Lim
%HW4 Design of Mechanical Elements  
%% Problem 4
clear,clc,close all

w = linspace(0,0.25,10);
sigmaNot = 620;
m = 0.25;

epsiloni = log(1./(1-w));
yieldStrengthPrime = sigmaNot .* (epsiloni.^m);

plot(w,yieldStrengthPrime);
xlabel("Amount of Cold Work")
ylabel("Yield Strength [MPA]")
title("Cold Working Amount Vs Yield Strength of 1080 Annealed Steel")