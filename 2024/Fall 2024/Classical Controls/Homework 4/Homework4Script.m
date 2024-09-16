%Brandon Lim
%Homework 4
clear, clc, close all

Gone = tf([1,2],[1,3,2]);
Gtwo = tf([-1,2],[1,3,2]);

figure
    step(Gone)
    title("Step Response of G_1(s)")
figure
    step(Gtwo)
    title("Step Response of G_2(s)")
figure
    step(tf([1],[1,1]))
figure
    step(tf([3],[1,1])+tf([-4],[1,2]))