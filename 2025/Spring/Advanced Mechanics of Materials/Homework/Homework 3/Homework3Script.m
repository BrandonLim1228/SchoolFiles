%% Problem 4
clear, clc, close all

E = 200 * 10^9;
G = 80 * 10^9;
epsilonTensor = [200 100 0; 100 300 400; 0 400 0] * 10^-6;
[sigmaTensor] = StressTensorfromStrainTensor(E,G,epsilonTensor)
