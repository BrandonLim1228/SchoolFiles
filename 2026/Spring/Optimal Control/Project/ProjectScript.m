clear, clc

%Figure Defaults
set(groot, 'defaultLegendInterpreter', 'latex')
set(groot, 'defaultTextInterpreter', 'latex')
set(groot, 'defaultAxesTickLabelInterpreter', 'latex')
set(groot, 'defaultColorbarTickLabelInterpreter', 'latex')
set(groot, 'defaultAxesFontSize', 17)
set(groot, 'defaultAxesFontWeight', 'bold')
set(groot, 'defaultFigureColor', [1.0 1.0 1.0])
set(groot, 'defaultLineLineWidth', 2)

blue = [0 76 153]./255;
lblue = [0 102 204]./255;
green = [76 153 0]./255;
lgreen = [102 204 0]./255;
grey = [96 96 96]./255;
lgrey = [192 192 192]./255;

% States (In order):
%     Phi - Roll angle
%     Beta - Side slip angle
%     p - Roll rate
%     r - yaw rate
% Inputs (In order):
%     eta - aileron deflection angle (radians)
%     zeta - rudder deflection angel (radians)
A = [0 0 1 0.078; 
    0.064 -0.202 0.078 -0.99;
    0 -22.92 -2.25 0.54;
    0 6 -0.04 -0.31];
B = [0 0;
    0.0002 0.0005;
    -0.4623 0.0569;
    -0.0244 -0.0469];
C = eye(4);
D = [0 0;
    0 0;
    0 0;
    0 0];

sys = ss(A,B,C,D);

% Initial States
x0 = [0;0;0;0]; 
% Roll time
t = linspace(0,10,1000)';

% Control Surface Inputs
delta_a = deg2rad(-10.5)*ones(length(t),1); %Constant 20 degree deflection in aileron in rad
delta_r = zeros(length(t),1); %No rudder input
u = [delta_a delta_r];

% Simulation
[y,t,x] = lsim(sys,u,t,x0);

% Histories
phi_raw = rad2deg(y(:,1)); % deg
psi_raw = cumtrapz(t,rad2deg(y(:,4))); % deg

z = [(2*t),zeros(length(t),1), zeros(length(t),1), zeros(length(t),1)];

%Plotting Progression
figure
subplot(1,2,1)
title("States vs Time");xlabel("Time [sec]"); ylabel("Attitude Angle [$^\circ$]")
ylim([0 35]); grid on
hold on
plot(t,z(:, 1),"--", "Color", blue)
plot(t,phi_raw, "-","Color", blue)
plot(t,z(:,4), "--", "Color", green)
plot(t,psi_raw,"-", "Color", green)
legend("$\phi_{des}$", "$\phi_{act}$", "$\psi_{des}$","$\psi_{act}$", "numColumns",2, "Location","northwest")

subplot(1,2,2)
title("Input vs Time");xlabel("Time [sec]"); ylabel("Defletion Angle [$^\circ$]")
ylim([-40 40]); grid on
hold on
plot(t,rad2deg(u(:,1)), "Color", grey)
plot(t,rad2deg(u(:,2)), "Color", lgrey)
yline(30,"--k");yline(-30,"--k")
legend("$\delta_{a}$", "$\delta_{r}$", "$\delta_{lim}$", "Location","northwest")

set(gcf,'Units','inches','Position',[0 0 10 6])  % width x height


%% Optimal Control 
clear, clc, close all
%Figure Defaults
set(groot, 'defaultLegendInterpreter', 'latex')
set(groot, 'defaultTextInterpreter', 'latex')
set(groot, 'defaultAxesTickLabelInterpreter', 'latex')
set(groot, 'defaultColorbarTickLabelInterpreter', 'latex')
set(groot, 'defaultAxesFontSize', 17)
set(groot, 'defaultAxesFontWeight', 'bold')
set(groot, 'defaultFigureColor', [1.0 1.0 1.0])
set(groot, 'defaultLineLineWidth', 2)

blue = [0 76 153]./255;
lblue = [0 102 204]./255;
green = [76 153 0]./255;
lgreen = [102 204 0]./255;
grey = [96 96 96]./255;
lgrey = [192 192 192]./255;



%States (In order):
    % Phi - Roll angle
    % Beta - Side slip angle
    % p - Roll rate
    % r - yaw rate
%Inputs (In order):
    % eta - aileron deflection angle (radians)
    % zeta - rudder deflection angel (radians)
A = [0 0 1 0.078; 
    0.064 -0.202 0.078 -0.99;
    0 -22.92 -2.25 0.54;
    0 6 -0.04 -0.31];
B = [0 0;
    0.0002 0.0005;
    -0.4623 0.0569;
    -0.0244 -0.0469];
C = eye(4);
D = [0 0;
    0 0;
    0 0;
    0 0];
sys = ss(A,B,C,D);


%Cost Function Weightings
F = [10500 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 10000];
Q = [1 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 10000];
R = [1 0;
    0 1];
%Time vector
t0 = 0;
tf = 10;
t = linspace(t0,tf,1000);

%Desired state trajectory over time (formulated as a function handle so it can
%work with ode45
zt = @(t) [deg2rad(2*t); 0; 0; 0];
ztf = [deg2rad(20); 0; 0; 0];

%Boundary conditions
x0 = [0;0;0;0];
Ptf = C'*F*C;
Gtf = C'*F*ztf;

%Hamiltonian Simplification Matricies
E = B*inv(R)*B';
V = C'*Q*C;
W = C'*Q;

%Solving riccati coeffiicients backwards in time
sol_p = ode45(@(t,P) pFun(t,A,P,E,V), [tf t0], Ptf(:));
%Solving non-homogenous vecotr differnetial equation backwards in time
sol_g = ode45(@(t,g) gFun(t,A,E,sol_p,W,zt,g), [tf t0], Gtf(:));
g = deval(sol_g,t);
% %Solving optimal states fowards in time
sol_x = ode45(@(t,x) xFun(t,A,E,sol_p,x,sol_g), [t0 tf], x0);
x = deval(sol_x,t);
%Solving for h backwards in time
htf = -ztf'*Ptf*ztf;
sol_h = ode45(@(t,h) hFun(t,E,sol_g,zt,Q), [tf t0], htf(:));
h = deval(sol_h,t);


%Solving optimal inputs and cost
ricatti_coeff = deval(sol_p,t);
for i = 1:length(t)
    P_current = reshape(ricatti_coeff(:,i),4,4);
    K = inv(R)*B'*P_current;
    u_current = -K * x(:,i) + inv(R) * B' * g(:,i);
    u(:,i) = u_current;

    Jstar(i) = (1/2)*x(:,i)'*P_current*x(:,i) - x(:,i)'*g(:,i) + h(i);
end

%Integrating yaw rate to get yaw
psi = cumtrapz(t, x(4,:)); 

%Output States in Degrees
psi_opt = rad2deg(psi)';
phi_opt = rad2deg(x(1,:))';


z = [2*t; zeros(length(t),1)'; zeros(length(t),1)'; zeros(length(t),1)'];

figure
subplot(1,2,1)
title("Optimal States vs Time");xlabel("Time [sec]"); ylabel("Attitude Angle [$^\circ$]")
ylim([0 22]); grid on
hold on
plot(t,z(1,:),"--", "Color", blue)
plot(t,phi_opt, "-","Color", blue)
plot(t,z(4,:), "--", "Color", green)
plot(t,psi_opt,"-", "Color", green)
legend("$\phi_{des}$", "$\phi_{act}$", "$\psi_{des}$","$\psi_{act}$", "numColumns",2, "Location","northwest")

subplot(1,2,2)
title("Optimal Input vs Time");xlabel("Time [sec]"); ylabel("Defletion Angle [$^\circ$]")
ylim([-40 40]); grid on
hold on
plot(t,(180/pi).*u(1,:), "Color", grey)
plot(t,(180/pi).*u(2,:), "Color", lgrey)
yline(30,"--k");yline(-30,"--k")
legend("$\delta_{a}$", "$\delta_{r}$", "$\delta_{lim}$", "Location","northwest")

set(gcf,'Units','inches','Position',[0 0 10 6])  % width x height
%exportgraphics(gcf,'W3.pdf','ContentType','vector')

function dpdt = pFun(t,A,P,E,V)
    [n,n] = size(A);
    P = reshape(P,n,n);
    dP = -P*A-A'*P+P*E*P-V;
    dpdt = dP(:);
end

function dgdt = gFun(t,A,E,P,W,z,g)
    [n,n] = size(A);
    P = reshape(deval(P,t),n,n);
    z_current = z(t);
    dgdt = -[A-E*P]'*g - W*z_current;
end

function dxdt = xFun(t,A,E,P,x,g)
    [n,n] = size(A);
    P = reshape(deval(P,t),n,n);
    g = deval(g,t);
    dxdt = [A-E*P]*x + E*g;
end

function dhdt = hFun(t,E,g,z,Q)
    g = deval(g,t);
    z_current = z(t);

    dhdt = -(1/2) * g'*E*g - (1/2) * z_current'*Q*z_current;
end
%%
orange = [245, 170, 66]./255;
purple = [90, 30, 168]./255;
red = [168, 46, 30]./255;

figure
subplot(1,2,1)
title("Optimal States vs Time");xlabel("Time [sec]"); ylabel("Attitude Angle [$^\circ$]")
ylim([-1 22]); grid on
hold on
plot(t,phi_opt, "-","Color", blue)
plot(t,rad2deg(x(2,:)), "-", "Color", orange)
plot(t,rad2deg(x(3,:)),"-", "Color", purple)
plot(t,rad2deg(x(4,:)),"-", "Color", red)
plot(t,psi_opt,"-", "Color", green)
legend( "$\phi$","$\beta$", "$p$","$r$","$\psi$", "Location","northwest")

subplot(1,2,2)
title("Optimal Input vs Time");xlabel("Time [sec]"); ylabel("Defletion Angle [$^\circ$]")
ylim([-40 40]); grid on
hold on
plot(t,(180/pi).*u(1,:), "Color", grey)
plot(t,(180/pi).*u(2,:), "Color", lgrey)
yline(30,"--k");yline(-30,"--k")
legend("$\delta_{a}$", "$\delta_{r}$", "$\delta_{lim}$", "Location","northwest")