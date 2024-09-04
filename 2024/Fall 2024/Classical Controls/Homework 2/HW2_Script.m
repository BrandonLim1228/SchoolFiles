clear, clc, close all
k = 5.2;
Wn = 60*2*pi; %rad/sec
zeta = 0.001;

t = linspace(0,3,1000);
Gs = tf([(k * (Wn^2))],[1, 2*zeta*Wn, Wn^2]) %Transfer function of the plant

u = zeros(size(t));
u(0 <= t & t < 1) = t(0 <= t & t < 1);
u(1 <= t & t< 2) = 1;
u(2 <= t & t< 3) = 1-u(0 <= t & t< 1);

figure
lsim(Gs,u,t)
title("Problem 3: Part (a)")
ylabel("Output")

%% The output is following the shape of the input but is oscillating as it does so.
figure
step(Gs)

%% The output decays to a steady state final value of about 5.2
%% Using the FVT
%%