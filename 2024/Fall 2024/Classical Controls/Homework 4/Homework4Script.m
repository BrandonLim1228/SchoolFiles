%Brandon Lim
%Homework 4
clear, clc, close all

%Problem 1
    Gone = tf([1,2],[1,3,2]);
    Gtwo = tf([-1,2],[1,3,2]);

    figure
        step(Gone)
        title("Step Response of G_1(s)")
    figure
        step(Gtwo)
        title("Step Response of G_2(s)")

%Problem 5
    Gcl = tf([(9/4)],[1,3,(9/4)])

    figure
        step(Gcl)
        title("Fastest Possible Step Response without Oscillations of Gcl with K = (9/4)")