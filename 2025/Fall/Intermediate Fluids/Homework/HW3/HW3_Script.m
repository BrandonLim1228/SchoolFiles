%% Homework 3 Brandon Lim

%% Problem 1 Part C
clear,clc,close all

y_tilda = linspace(0,1,10);
P_tilda = [15, 10, 5, 0, -5, -10, -15];

figure
hold on
for i = 1:length(P_tilda)
    u_tilda = (-P_tilda(i) .* (1./2) .* y_tilda.^2) + (1+P_tilda(i) .* (1./2)) .* y_tilda;
    plot(u_tilda,y_tilda)
end
legend({'$\tilde{P}=15$', '$\tilde{P}=10$', '$\tilde{P}=5$', '$\tilde{P}=0$','$\tilde{P}=-5$', '$\tilde{P}=-10$', '$\tilde{P}=-15$'},"Interpreter","latex","Location","eastoutside")
ylabel("$\frac{y}{b}$","Interpreter","latex"); xlabel("$\frac{u}{U}$","Interpreter","latex"); title("Problem 1 Part C")

%% Problem 3 Part D
clear,clc,close all

y_tilda = linspace(0,1,10);
alpha = 60; %deg

u_tilda = sind(alpha).*(y_tilda - (1./2) .* (y_tilda.^2));
plot(u_tilda,y_tilda)
ylabel("$\frac{y}{h}$","Interpreter","latex"); xlabel("$\frac{\mu u}{\rho gh^2}$","Interpreter","latex"); title("Problem 3 Part d")

%% Problem 4 Part C
clear,clc,close all
y_tilda = linspace(0,1,10);
phsi = linspace(0,1,10);

figure
hold on
for i = 1:length(phsi)
    T_tilda = phsi(i) .* (-12.*y_tilda.^4 + 24.*y_tilda.^3-18.*y_tilda.^2+6.*y_tilda) + y_tilda;
    plot(T_tilda,y_tilda)
end

legend({'$\tilde{Phsi}=0.00$', '$\tilde{Phsi}=0.11$', '$\tilde{Phsi}=0.22$', '$\tilde{Phsi}=0.33$','$\tilde{Phsi}=0.44$', '$\tilde{Phsi}=0.55$', '$\tilde{Phsi}=0.66$','$\tilde{Phsi}=0.77$','$\tilde{Phsi}=0.99$','$\tilde{Phsi}=1.00$'},"Interpreter","latex","Location","eastoutside")
ylabel("$\frac{y}{h}$","Interpreter","latex"); xlabel("$\frac{T-T_o}{\delta T}$","Interpreter","latex"); title("Problem 4 Part C")
