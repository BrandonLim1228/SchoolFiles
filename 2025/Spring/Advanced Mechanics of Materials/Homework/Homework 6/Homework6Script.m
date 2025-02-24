clear, clc, close all

theta = -30:0.01:30; %deg
alpha = 15; %deg
P = 1; %N
L = 1; %m

sigmaR = (-P.*(cosd(theta)))./(L.*(alpha +0.5.*sind(2*alpha)));
sigmaT = 0;
tauRT = 0;

sigmaX = sigmaR .* (cosd(theta).^2) + sigmaT .* (sind(theta).^2) - 2.* tauRT .* (cosd(theta).*sind(theta));
sigmaY = sigmaR .* (sind(theta).^2) + sigmaT .* (cosd(theta).^2) + 2.* tauRT .* (cosd(theta).*sind(theta));
tauXY = (sigmaR - sigmaT) .* sind(theta) .* cosd(theta);

plot(theta, sigmaX)
hold on
plot(theta, sigmaY)
plot(theta, tauXY)
hold off
xlabel("Theta [deg]")
ylabel("Stress [Pa]")
title("Stress Vs Theta")
legend("SigmaX", "SigmaY", "SigmaZ")