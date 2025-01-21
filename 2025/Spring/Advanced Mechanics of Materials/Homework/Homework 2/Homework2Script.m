%Brandon Lim
clear, clc, close all
%% Problem 1
clear, clc, close all
A = [12 4 2; 4 -8 -1; 2 -1 6];
[~,~,~,tauMax] = principalStress3D(A)

%% Problem 2
clear, clc, close all
A = [60 20 10; 20 -40 -5; 10 -5 30];
[sigma1, sigma2, sigma3, ~] = principalStress3D(A)


%% Problem 3
clear, clc, close all
A = [10 0 0; 0 -4 0; 0 0 8];
B = [1 0 0; 0 1/2 sqrt(3)/2; 0 -sqrt(3)/2 1/2];
C = [2/sqrt(5) -1/sqrt(5) 0; 1/sqrt(5) 2/sqrt(5) 0; 0 0 1];
[tensorP] = StressTransformation3D(A,B)

[tensorPP] = StressTransformation3D(A,C)

%% Problem 4
clear, clc, close all
A = [40 40 30; 40 20 0; 30 0 20];
B = [cosd(40) cosd(75) cosd(54)];
[sigma, tau] = NormalXShearPerpendicular(A,B)


%% Problem 8
clear, clc, close all
A = [200 300 200; 300 -100 500; 200 500 -400];
J3 = det(A);

B = [cosd(30) cosd(60) 0; 0 0 0; 0 0 0];
[strainP] = StrainTransformation3D(A,B)

[epsilon1, epsilon2, epsilon3, tauMax] = PrincipalStrain3D(A)