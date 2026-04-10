clear, clc, close all

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
C = (180/pi)* eye(4);
D = [0 0;
    0 0;
    0 0;
    0 0];

sys = ss(A,B,C,D);

x0 = [0;0;0;0]; % Initial States
t = linspace(0,10,1000)'; % Roll time
eta = deg2rad(-20) * ones(length(t),1); %Roll input of 5 degrees aleron deflection
% c = [0.001791 -0.024 0.18 -0.086 -12.1];
% eta = deg2rad(polyval(c,t));
zeta = zeros(length(t),1);
u = [eta, zeta];
figure
plot(t,eta)

[y,t,x] = lsim(sys,u,t,x0);

psi_hist = cumtrapz(t, y(:,4));   % integrate yaw rate

figure
plot(t,y)
hold on
plot(t,psi_hist)
title("Pure Aileron Deflection to control roll"); xlabel("Time"); ylabel("Degrees or Degrees/sec")
legend("Roll Angle", "Side Slip Angle", "Roll Rate", "Yaw Rate", "Yaw Angle");


Rx = @(phi)[1 0 0;
            0 cosd(phi) -sind(phi);
            0 sind(phi) cosd(phi)];

Rz = @(psi)[cosd(psi) -sind(psi) 0;
            sind(psi)  cosd(psi) 0;
            0         0        1];

% Simple airplane geometry in body axes
% x forward, y right, z down

fuselage = [-0.8 1.0;   0   0;    0   0];
wing     = [ 0   0;   -0.8 0.8;   0   0];
htail    = [-0.5 -0.5; -0.25 0.25; 0 0];
vtail    = [-0.5 -0.5;  0    0;   0 0.25];

figure
axis equal
grid on
xlabel('X'), ylabel('Y'), zlabel('Z')
xlim([-2 2]), ylim([-2 2]), zlim([-2 2])
view(3)

for k = 1:10:length(t)

    phi_k = y(k,1);
    psi_k = psi_hist(k);

    R = Rz(psi_k) * Rx(phi_k);

    fus = R * fuselage;
    wng = R * wing;
    htl = R * htail;
    vtl = R * vtail;

    cla
    plot3(fus(1,:), fus(2,:), fus(3,:), 'LineWidth', 2)
    hold on
    plot3(wng(1,:), wng(2,:), wng(3,:), 'LineWidth', 2)
    plot3(htl(1,:), htl(2,:), htl(3,:), 'LineWidth', 2)
    plot3(vtl(1,:), vtl(2,:), vtl(3,:), 'LineWidth', 2)

    plot3(0,0,0,'o')   % center marker

    axis equal
    xlim([-1.2 1.2])
    ylim([-1.2 1.2])
    zlim([-1.2 1.2])
    view(35,25)
    grid on

    title(sprintf('t = %.2f s', t(k)))
    xlabel('X')
    ylabel('Y')
    zlabel('Z')

    drawnow
end

%% Optimal Control 
clear, clc, 
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
F = [5000 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 1];
Q = [1 0 0 0;
    0 0 0 0;
    0 0 0 0;
    0 0 0 1000];
R = [0.001 0;
    0 1];

%Time vector
t0 = 0;
tf = 10;
t = linspace(t0,tf,1000);

%Desired state trajectory over time (formulated as a function handle so it can
%work with ode45
zt = @(t) [deg2rad(3*t); 0; 0; 0];
ztf = [deg2rad(30); 0; 0; 0];

%Boundary conditions
x0 = [0;0;0;0];
Ptf = C'*F'*C;
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

%Solving optimal inputs
ricatti_coeff = deval(sol_p,t);
for i = 1:length(t)
    P_current = reshape(ricatti_coeff(:,i),4,4);
    K = inv(R)*B'*P_current;
    u_current = -K * x(:,i) + inv(R) * B' * g(:,i);
    u(:,i) = u_current;
end

psi = cumtrapz(t, x(4,:)); % integrate yaw rate

figure
hold on
plot(t,(180/pi).*x(1,:))
plot(t,psi.*(180/pi))
legend("Roll Angle", "Yaw Angle", "Location","northwest")
grid on

figure
plot(t,(180/pi).*u)
legend("Aileron Deflection Angle", "Rudder Defelection Angle")

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

%% Figure Generation for the paper
clc, close all
%Figure Defaults
set(groot, 'defaultLegendInterpreter', 'latex')
set(groot, 'defaultTextInterpreter', 'latex')
set(groot, 'defaultAxesTickLabelInterpreter', 'latex')
set(groot, 'defaultColorbarTickLabelInterpreter', 'latex')
set(groot, 'defaultAxesFontSize', 17)
set(groot, 'defaultAxesFontWeight', 'bold')
set(groot, 'defaultFigureColor', [1.0 1.0 1.0])
set(groot, 'defaultFigurePosition', [450 85 1176 864])

z = [3*t; zeros(length(t),1)'; zeros(length(t),1)'; zeros(length(t),1)'];

figure
hold on
plot(t,z(1,:),"--", "Color", [0 0 204]./255, "LineWidth",2)
plot(t,z(4,:), "--", "Color", [255 153 51]./255, "LineWidth",2)
xlabel("Time [sec]"); ylabel("Angle [$^\circ$]"); title("Desired State Trajectory vs Time");
legend("Roll Angle", "Yaw Angle", "Location","southoutside", "Orientation","horizontal")
ylim([-1 30]); grid on

exportgraphics(gcf,'Desired State Trajectory.pdf','ContentType','vector')