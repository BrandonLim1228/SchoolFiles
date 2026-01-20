clear,clc,close all

%% P1 
Gs = tf(4,[1 102]);
step(Gs)
%% P2
Gs = tf(2,[1 1 2]);
step(Gs)