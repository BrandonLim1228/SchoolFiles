function [sf, tauMax] = MaximumShearStress(sigma1,sigma3,sigmaYield)

tauMax = (1/2) * (sigma1 - sigma3);

sf = tauMax/(sigmaYield/2);

end