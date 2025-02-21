%% Brandon Lim - HW6
clear, clc, close all

A = [-3 1 0 0; 0 -3 1 0; 0 0 -3 0; 0 0 0 -6];
B = [0; 0; 2; -2];
C = [1 0 0 0; 0 1 0 0; 0 0 1 0; 0 0 0 1];
D = 0;
x0 = [ 10; -8; -4; 5];
t = 0:0.001:3.5;
u1 = ones(size(t));
u2 = zeros(size(t));

sys = ss(A,B,C,D);
[y1,t,x1] = lsim(sys,u1,t,x0);
[y2,t,x2] = lsim(sys,u2,t,x0);

figure
plot(t,x1(:,1))
hold on
plot(t,x1(:,2))
plot(t,x1(:,3))
plot(t,x1(:,4))
hold off
xlabel("Time [sec]")
ylabel("Output")
title("Unit Step Response")
legend("X1", "X2", "X3", "X4")

figure
plot(t,x2(:,1))
hold on
plot(t,x2(:,2))
plot(t,x2(:,3))
plot(t,x2(:,4))
hold off
xlabel("Time [sec]")
ylabel("Output")
title("Zero Input Response")
legend("X1", "X2", "X3", "X4")