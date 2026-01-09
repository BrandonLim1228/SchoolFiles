%% P1
clear,clc,close all
data = readmatrix("Blasius_Soln.txt");

nondimY = data(2:end,1);
nondimU = data(2:end,2);

figure
plot(nondimU,nondimY)
xlabel("$\frac{u}{U}$","Interpreter","latex", "FontSize",18); ylabel("$\frac{y}{\delta}$","Interpreter","latex", "FontSize",18); title("Blassius Solution for a Laminar BL")

delta_star = trapz(nondimY,(1-nondimU));
theta = trapz(nondimY, (nondimU.*(1-nondimU)));

dudy0 = (nondimU(2) - nondimU(1))/(nondimY(2) - nondimY(1));
CfRe_delta = 2*dudy0;



%% P3
close all
lin = nondimY;
quad = 2.*nondimY - nondimY.^2;
cub = (3/2).*nondimY - (1/2).*nondimY.^3;
quar = 2.*nondimY - 2.*(nondimY.^3) + nondimY.^4;
sinu = sin((pi/2).*nondimY);

figure
hold on
plot(lin,nondimY)
plot(quad,nondimY)
plot(cub,nondimY)
plot(quar,nondimY)
plot(sinu,nondimY)
plot(nondimU,nondimY, "k","LineWidth",1)
legend("Linear Approximation", "Quadratic Approximation", "Cubic Approximation", "Quartic Approximation", "Sinusoidal Approximation", "Blassius Solution", "Location", "southeast")

delta_star_lin = trapz(nondimY,(1-lin))
theta_lin = trapz(nondimY, (lin.*(1-lin)))
dudy0 = (lin(2) - lin(1))/(nondimY(2) - nondimY(1));
CfRe_delta_lin = 2*dudy0
abs(delta_star_lin-delta_star)/delta_star
abs(theta_lin-theta)/theta
abs(CfRe_delta_lin-CfRe_delta)/CfRe_delta

delta_star_quad = trapz(nondimY,(1-quad))
theta_quad = trapz(nondimY, (quad.*(1-quad)))
dudy0 = (quad(2) - quad(1))/(nondimY(2) - nondimY(1));
CfRe_delta_quad = 2*dudy0
abs(delta_star_quad-delta_star)/delta_star
abs(theta_quad-theta)/theta
abs(CfRe_delta_quad-CfRe_delta)/CfRe_delta

delta_star_cub = trapz(nondimY,(1-cub))
theta_cub = trapz(nondimY, (cub.*(1-cub)))
dudy0 = (cub(2) - cub(1))/(nondimY(2) - nondimY(1));
CfRe_delta_cub = 2*dudy0
abs(delta_star_cub-delta_star)/delta_star
abs(theta_cub-theta)/theta
abs(CfRe_delta_cub-CfRe_delta)/CfRe_delta

delta_star_quar = trapz(nondimY,(1-quar))
theta_quar = trapz(nondimY, (quar.*(1-quar)))
dudy0 = (quar(2) - quar(1))/(nondimY(2) - nondimY(1));
CfRe_delta_quar = 2*dudy0
abs(delta_star_quar-delta_star)/delta_star
abs(theta_quar-theta)/theta
abs(CfRe_delta_quar-CfRe_delta)/CfRe_delta

delta_star_sinu = trapz(nondimY,(1-sinu))
theta_sinu = trapz(nondimY, (sinu.*(1-sinu)))
dudy0 = (sinu(2) - sinu(1))/(nondimY(2) - nondimY(1));
CfRe_delta_sinu = 2*dudy0
abs(delta_star_sinu-delta_star)/delta_star
abs(theta_sinu-theta)/theta
abs(CfRe_delta_sinu-CfRe_delta)/CfRe_delta