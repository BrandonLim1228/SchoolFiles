clear, clc, close all
shearStress = [0 2.11 7.82 18.5 31.7];
shearingStrain = [0 50 100 150 200];

figure
plot(shearingStrain,shearStress, "ro")

shearStressPolyfit = polyfit(shearingStrain,shearStress,2)

xvec = [0:200];
yvec = 0.0008.*(xvec.^2) + 0.0044.*(xvec);

hold on 
plot(xvec,yvec)
xlabel("Shearing Strain Rate [s^-1]");
ylabel("Shear Stress [lb/ft^2]");
title("Shearing Strain Rate vs Shear Stress")

fprintf("Shearing Stress = 0.0008u^2 + 0.0044u")
