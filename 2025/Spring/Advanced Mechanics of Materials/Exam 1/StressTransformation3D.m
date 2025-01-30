function [tensorP] = StressTransformation3D(A,transformMatrix)

l = transformMatrix(:,1);
m = transformMatrix(:,2);
n = transformMatrix(:,3);

sigmaX = A(1,1);
sigmaY = A(2,2);
sigmaZ = A(3,3);
tauXY = A(1,2);
tauYZ = A(3,2);
tauXZ = A(3,1);

sigmaXp = sigmaX * (l(1)^2) + sigmaY * (m(1)^2) + sigmaZ * (n(1)^2) + 2 * ((tauXY * l(1) * m(1)) + (tauYZ * m(1) * n(1)) + (tauXZ * l(1) * n(1)));
sigmaYp = sigmaX * (l(2)^2) + sigmaY * (m(2)^2) + sigmaZ * (n(2)^2) + 2 * ((tauXY * l(2) * m(2)) + (tauYZ * m(2) * n(2)) + (tauXZ * l(2) * n(2)));
sigmaZp = sigmaX * (l(3)^2) + sigmaY * (m(3)^2) + sigmaZ * (n(3)^2) + 2 * ((tauXY * l(3) * m(3)) + (tauYZ * m(3) * n(3)) + (tauXZ * l(3) * n(3)));

tauXYp = (sigmaX * l(1) * l(2)) + (sigmaY * m(1) * m(2)) + (sigmaZ * n(1) * n(2)) + tauXY * (l(1) * m(2) + m(1) * l(2)) + tauYZ * (m(1) * n(2) + n(1) * m(2)) + tauXZ * (n(1) * l(2) + l(1) * n(2));
tauXZp = (sigmaX * l(1) * l(3)) + (sigmaY * m(1) * m(3)) + (sigmaZ * n(1) * n(3)) + tauXY * (l(1) * m(3) + m(1) * l(3)) + tauYZ * (m(1) * n(3) + n(1) * m(3)) + tauXZ * (n(1) * l(3) + l(1) * n(3));
tauYZp = (sigmaX * l(2) * l(3)) + (sigmaY * m(2) * m(3)) + (sigmaZ * n(2) * n(3)) + tauXY * (l(2) * m(3) + m(2) * l(3)) + tauYZ * (m(2) * n(3) + n(2) * m(3)) + tauXZ * (n(2) * l(3) + l(2) * n(3));

tensorP = [sigmaXp tauXYp tauXZp; tauXYp sigmaYp tauYZp; tauXZp tauYZp sigmaZp];
end