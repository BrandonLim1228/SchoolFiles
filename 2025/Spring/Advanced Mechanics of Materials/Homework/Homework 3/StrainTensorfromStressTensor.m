function [epsilonTensor] = StrainTensorfromStressTensor(E1, E2, E3, v12, v13, v23, G13, G23, G12,sigmaTensor)
v21 = v12;
v31 = v13;
v32 = v23;
sigmaVec = [sigmaTensor(1,1); sigmaTensor(2,2); sigmaTensor(3,3); sigmaTensor(2,3); sigmaTensor(1,3); sigmaTensor(1,2)];
transformMatrix = [1/E1 -v21/E2 -v31/E3 0 0 0; -v12/E1 1/E2 -v32/E2 0 0 0; -v13/E1 -v23/E2 1/E3 0 0 0; 0 0 0 1/G23 0 0; 0 0 0 0 1/G13 0; 0 0 0 0 0 1/G12];

epsilonTensor = transformMatrix * sigmaVec;
end