clear, clc, close all

A = [250 -150 0; -150 -50 0; 0 0 0];
[sigma1, sigma2, sigma3, tauMax] = principalStress3D(A)

v = 0.33;
E = 72*10^9;

transMat = [1 -v -v 0 0 0; -v 1 -v 0 0 0; -v -v 1 0 0 0; 0 0 0 1+v 0 0; 0 0 0 0 1+v 0; 0 0 0 0 0 1+v];
sigmaVec = [250 -50 0 0 0 -150]';
B = transMat * sigmaVec

C = [B(1) B(end) 0; B(end) B(2) 0; 0 0 B(3)]
[epsilon1, epsilon2, epsilon3, tauMax] = PrincipalStrain3D(C)
% [epsilon1, epsilon2, epsilon3, tauMax] = PrincipalStrain3D(Ae)
%%
clear, clc, close all

A = [20 0 0; 0 50 -60; 0 -60 0]
[sigma1, sigma2, sigma3, tauMax] = principalStress3D(A)
