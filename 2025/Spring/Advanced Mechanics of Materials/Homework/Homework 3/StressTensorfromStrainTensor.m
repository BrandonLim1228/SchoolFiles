function [sigmaTensor] = StressTensorfromStrainTensor(E,G,epsilonTensor)

v = (E/(2*G)) - 1 %Poissons Ratio
lambda = (v *E)/((1+v)*(1-2*v))
u = G;

epsVec = [epsilonTensor(1,1); epsilonTensor(2,2); epsilonTensor(3,3); 2*epsilonTensor(2,3); 2*epsilonTensor(3,1); 2*epsilonTensor(1,2)];
transMatrix = [2*u+lambda lambda lambda 0 0 0; lambda 2*u+lambda lambda 0 0 0; lambda lambda 2*u+lambda 0 0 0; 0 0 0 u 0 0; 0 0 0 0 u 0; 0 0 0 0 0 u]

sigmaTensor = transMatrix * epsVec;



end