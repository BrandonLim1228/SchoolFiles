clear,clc,close all

K = 5.2;
Wn = 60*2*pi;
zeta = 0.001;

Gs = tf(K*Wn^2,[1, 2*zeta*Wn, Wn^2])
t = linspace(0,10,1000);

u = zeros(size(t));
u(0<=t & t<1) = t(0<=t & t<1);
u(1<=t & t<2) = 1;
u(2<=t & t<3) = 1-u(0<=t & t<1);


figure
lsim(Gs,u,t)

figure
step(Gs)