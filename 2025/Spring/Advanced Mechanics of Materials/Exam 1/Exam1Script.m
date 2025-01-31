%% Brandon Lim, Exam 1

clear, clc, close all

A = [30 0 20; 0 0 0; 20 0 0]
[sigma1, sigma2, sigma3, ~] = principalStress3D(A)

transformVec = [cosd(45), cosd(45) cosd(45)]
[sigma, tau] = NormalXShearPerpendicular(A,transformVec)
