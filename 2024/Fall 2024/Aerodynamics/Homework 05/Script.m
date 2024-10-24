clear, clc, close all
Gamma1 = 1; Gamma2 = 2; l=1;
[X, Y] = meshgrid([-2:0.15:3] ,[-2:0.15:3]);
Z = X + i*Y;
W = (i./(2*pi)) .* (((Gamma2-Gamma1)./l) .* (-Z .* (log((Z-l)./Z) -l)) + Gamma1 .* (log(Z./(Z-1))));
u = real(W); v = -imag(W);
figure
quiver(X,Y,u,v,0)
axis image
axis tight
title('Vortex sheet between (0,0) and (1,0)')