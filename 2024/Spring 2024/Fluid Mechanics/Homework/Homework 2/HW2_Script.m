%%Brandon Lim 
clear, clc ,close all
format longg

rhoSurf = 1700; %kg/m^3
hbot = 5; %m
g = 9.81; %m/s

fun = @(h) sqrt(1+(sin((h/hbot)*(pi/2)).^2)); %Creating integrand function
int = integral(fun,0,5); %Computing the integral

pBot = int * rhoSurf * g; %Computing the pressure at the bottom

fprintf("The intergrand calculated to be %f meters and the pressure at the bottom is %f pascals",int,pBot)