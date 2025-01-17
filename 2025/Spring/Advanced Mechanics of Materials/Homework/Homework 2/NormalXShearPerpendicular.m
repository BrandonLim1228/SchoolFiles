function [sigma, tau] = NormalXShearPerpendicular(A,transformVec)

l = transformVec(1)
m = transformVec(2)
n = transformVec(3)

sigmaX = A(1,1);
sigmaY = A(2,2);
sigmaZ = A(3,3);
tauXY = A(1,2);
tauYZ = A(3,2);
tauXZ = A(3,1);

sigma = sigmaX * (l^2) + sigmaY * (m^2) + sigmaZ * (n^2) + 2 * ((tauXY * l * m) + (tauYZ * m * n) + (tauXZ * l * n));
tau = sqrt((sigmaX * l + tauXY * m + tauXZ * n)^2 + (tauXY * l + sigmaY * m + tauYZ * n)^2 + (tauXZ * l + tauYZ * m + sigmaZ * n)^2 - sigma^2)
end 