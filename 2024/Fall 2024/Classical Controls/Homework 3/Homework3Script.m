%Classical Control Systems Homework 3
%Brandon Lim
clear, clc, close all

%Problem 1, Part e and d
    %Creating Transfer Function
        num = 4;
        den = [1,102];
        G = tf(num,den);
    %Step response of the transfer function
        step(G)

%%
G = tf(0.33*10^2, [1, 2*0.0976*10 10^2])
step(G)