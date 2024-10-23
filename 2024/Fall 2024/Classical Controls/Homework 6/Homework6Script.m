%Brandon Lim
%Homework 6 Classical Control Systems
clear, clc, close all

%Problem 1
    %Initialzing variable
        t = linspace(0,100,100);
    %Input 
        r = zeros(size(t));
        r(0 <= t & t < 10) = t(0 <= t & t < 10);
        r(10 <= t & t < 20) = 10-r(0 <= t & t < 10);
        r(20 <= t & t < 30) = t(0 <= t & t < 10);
        r(30 <= t & t < 40) = 10-r(0 <= t & t < 10);
    %Transfer function
        Gs = tf([75 75],[1 30 200 75])
    %Plotting time response of the output of the close-loop system (a)
        figure
        lsim(Gs,r,t)
    %Plotting tracking error as a function of time
        figure
        lsim(1/(1+Gs),r,t)