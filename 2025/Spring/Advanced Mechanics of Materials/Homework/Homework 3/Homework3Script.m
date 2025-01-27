%% Problem 4
clear, clc, close all

E = 200 * 10^9; %Youngs Modulus 
G = 80 * 10^9; %Shear Modulus 
epsilonTensor = [200 100 0; 100 300 400; 0 400 0] * 10^-6; %Given Strain Tensor
[sigmaTensor_Pa] = StressTensorfromStrainTensor(E,G,epsilonTensor) %Function call

%% Problem 5
clear, clc, close all
format
sigmaTensor = [-60 0 0; 0 -50 0; 0 0 -40] * (10^6);
E1 = 200*10^9; E2 = 200*10^9; E3 = 200*10^9;
v12 = 0.3; v23 = 0.3; v13 = 0.3;
G13 = 0; G23 = 0; G12 = 0; 

[epsilonTensor] = StrainTensorfromStressTensor(E1, E2, E3, v12, v13, v23, G13, G23, G12,sigmaTensor)

%% Problem 6
clear, clc, close all

format longG
A = [7 1.4 0; 1.4 2.1 0; 0 0 -2.8] * (10^6) %Pa

E1 = 15290 * 10^6; % Pa
E2 = 1195 * 10^6; % Pa
E3 = 765 * 10^6; % Pa
G12 = 1130 * 10^6; % Pa
G13 = 1040 * 10^6; % Pa
G23 = 260 * 10^6; % Pa
v12 = 0.426;
v13 = 0.451;
v23 = 0.697;

[sigma1, sigma2, sigma3, tauMax] = principalStress3D(A)

[epsilonTensor] = StrainTensorfromStressTensor(E1, E2, E3, v12, v13, v23, G13, G23, G12,A)