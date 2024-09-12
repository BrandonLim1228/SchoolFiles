clear, clc, close all
z = linspace(0.1,20,1000);
r = linspace(0.1,20,1000);
thetavec = linspace(0.1,20,1000);

rho = 2 ./ r;
theta = 5.*z;
Z = 2.*r;


[X,Y,Z] = pol2cart(theta,rho,Z);
[P,Q,R] = pol2cart(thetavec,r,z);

quiver3(X,Y,Z,P,Q,R)


