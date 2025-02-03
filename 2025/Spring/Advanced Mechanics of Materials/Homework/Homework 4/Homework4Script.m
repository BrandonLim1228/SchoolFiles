%Brandon Lim
clear, clc, close all

A = [0 -80 0; -80 100 0; 0 0 0];
sigmaPrinc = eig(A); sigma1 = sigmaPrinc(3); sigma3 = sigmaPrinc(1);
sigmaYield = 250;
[sf, tauMax] = MaximumShearStress(sigma1,sigma3,sigmaYield)