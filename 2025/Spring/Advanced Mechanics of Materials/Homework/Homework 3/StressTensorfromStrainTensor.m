function [sigmaTensor] = StressTensorfromStrainTensor(E,G,epsilonTensor)

%Strain Values
epsilonX = epsilonTensor(1,1);
epsilonY = epsilonTensor(2,2);
epsilonZ = epsilonTensor(3,3);
gammaXY = 2 * epsilonTensor(1,2);
gammaYZ = 2 * epsilonTensor(2,3);
gammaXZ = 2 * epsilonTensor(1,3);

%Calculation Values (eq. 2.37, 2.38 from textbook)
v = (E/(2*G)) - 1; %Poissons Ratio
lambda = (v *E)/((1+v)*(1-2*v));
ee = epsilonX + epsilonY + epsilonZ;

%Outputs (eq. 2.36 from textbook) 
sigmaX = 2 * G * epsilonX + lambda * ee;
sigmaY = 2 * G * epsilonY + lambda * ee;
sigmaZ = 2 * G * epsilonZ + lambda * ee;
tauXY = G * gammaXY;
tauYZ = G * gammaYZ;
tauXZ = G * gammaXZ;

sigmaTensor = [sigmaX tauXY tauXZ; tauXY sigmaY tauYZ; tauXZ tauYZ sigmaZ];
end