function [strainP] = StrainTransformation3D(A,transformMatrix)
l = transformMatrix(:,1);
m = transformMatrix(:,2);
n = transformMatrix(:,3);

epsilonX = A(1,1);
epsilonY = A(2,2);
epsilonZ = A(3,3);
gammaXY = A(1,2) * 2;
gammaYZ = A(3,2) * 2;
gammaXZ = A(3,1) * 2;

epsilonXp = epsilonX * l(1)^2 + epsilonY * m(1)^2 + epsilonZ * n(1)^2 + gammaXY * l(1) * m(1) + gammaYZ * m(1) * n(1) + gammaXZ * l(1) * n(1);
epsilonYp = epsilonX * l(2)^2 + epsilonY * m(2)^2 + epsilonZ * n(2)^2 + gammaXY * l(2) * m(2) + gammaYZ * m(2) * n(2) + gammaXZ * l(2) * n(2);
epsilonZp = epsilonX * l(3)^2 + epsilonY * m(3)^2 + epsilonZ * n(3)^2 + gammaXY * l(3) * m(3) + gammaYZ * m(3) * n(3) + gammaXZ * l(3) * n(3);

gammaXYp = 2 * (epsilonX * l(1) * l(2) + epsilonY * m(1) * m(2) + epsilonZ * n(1) * n(2)) + gammaXY * (l(1) * m(2) + m(1) * l(2)) + gammaYZ * (m(1) * n(2) + n(1) * m(2)) + gammaXZ * (n(1) * l(2) + l(1) * n(2));
gammaXZp = 2 * (epsilonX * l(1) * l(3) + epsilonY * m(1) * m(3) + epsilonZ * n(1) * n(3)) + gammaXY * (l(1) * m(3) + m(1) * l(3)) + gammaYZ * (m(1) * n(3) + n(1) * m(3)) + gammaXZ * (n(1) * l(3) + l(1) * n(3));
gammaYZp = 2 * (epsilonX * l(2) * l(3) + epsilonY * m(2) * m(3) + epsilonZ * n(2) * n(3)) + gammaXY * (l(2) * m(3) + m(2) * l(3)) + gammaYZ * (m(2) * n(3) + n(2) * m(3)) + gammaXZ * (n(2) * l(3) + l(2) * n(3));

strainP = [epsilonXp gammaXYp*(1/2) gammaXZp*(1/2); gammaXYp*(1/2) epsilonYp gammaYZp*(1/2); gammaXZp*(1/2) gammaYZp*(1/2) epsilonZp];

end