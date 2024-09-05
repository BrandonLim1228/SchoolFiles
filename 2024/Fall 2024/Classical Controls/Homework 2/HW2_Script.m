%% Problem 3
clear, clc, close all
%Initializing Variables
    k = 5.2;
    Wn = 60*2*pi; %rad/sec
    zeta = 0.001;
    t = linspace(0,3,1000);
%Creating Transfer Function
    Gs = tf([(k * (Wn^2))],[1, 2*zeta*Wn, Wn^2]);
%Creating input 
    u = zeros(size(t));
    u(0 <= t & t < 1) = t(0 <= t & t < 1);
    u(1 <= t & t< 2) = 1;
    u(2 <= t & t< 3) = 1-u(0 <= t & t< 1);
%Plotting part a
    figure
    lsim(Gs,u,t)
%Plotting part c
    figure
    step(Gs)