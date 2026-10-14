% Problem 1
clear, clc, close all

%Initial Conditions
x0 = [1;2];

%Final State Weights
f11 = 1000;
f22 = 1000;

%Reversed time vector for backwards solving
t_rev = linspace(5,0,5000);

%Final Conditions
final_cond = [f11; 0; f22; 4*f11; 2*f22];

%Solving for P backwards in time and then flipping the solution
[t,z] = ode45(@odefun, t_rev ,final_cond);
t_up = flip(t);
z_up = flip(z,1);

%Solving for the optimal states from P
[t_x, x] = ode45(@(t,x) dynamics(t,x,t_up,z_up), flip(t_rev), x0);

%Returning the optimal input from the states and P
for i = 1:length(t_x)
    P12 = interp1(t_up, z_up(:,2), t_x(i));
    P22 = interp1(t_up, z_up(:,3), t_x(i));
    g2  = interp1(t_up, z_up(:,5), t_x(i));
    u(i) = -(5/4)*(P12*x(i,1) + P22*x(i,2) - g2);
end

%Optimal Dynamics
function dxdt = dynamics(t,x,t_up,z_up)
P12 = interp1(t_up, z_up(:,2), t);
P22 = interp1(t_up, z_up(:,3), t);
g2  = interp1(t_up, z_up(:,5), t);

u = -(5/4)*(P12*x(1) + P22*x(2) - g2);

dx1 = x(2);
dx2 = -2*x(1) + 4*x(2) + 5*u;

dxdt = [dx1; dx2];
end

%Optimal Gains
function odes = odefun(t,z)
    P11 = z(1);
    P12 = z(2);
    P22 = z(3);
    g1 = z(4);
    g2 = z(5);

    dP11 = 4*P12 + (25/4)*P12^2 -5;
    dP12 = 2*P22 - P11 - 4*P12 + (25/4)*P12*P22;
    dP22 = -2*P12-8*P22+(25/4)*P22^2-2;
    dg1 = (25/4)*P12*g2 + 2*g2;
    dg2 = (25/4)*P22*g2 - 4*g2-g1;
    
    odes = [dP11; dP12; dP22; dg1; dg2];
end

%Plotting
figure
plot(t_x,x)
title("Optimal State Progression"); xlabel("Time [sec]"); ylabel("State"); legend("x_1", "x_2", "Location","southeast")
figure
plot(t_up, z_up(:,1:3))
title("Ricatti Coefficients vs Time"); xlabel("Time [sec]"); ylabel("Ricatti Coefficients"); legend("P_{11}", "P_{12}", "P_{22}", "Location","northeast")
figure
plot(t_x,u)
title("Optimal Input vs Time"); xlabel("Time [sec]"); ylabel("Input");


%%
clear, clc, close all

sys = tf([1500], [1 21.67 33.4 0]);

t = linspace(0,5,1000);
ramp = t;
parabola = t.^2;

[y_step,tOut] = step(sys,t);
[y_ramp,tOut] = lsim(sys,ramp,t);
[y_para,tOut] = lsim(sys,parabola,t);

figure
plot(tOut,y_step)
hold on
plot(tOut,y_ramp)
hold on
plot(tOut,y_para)
title("Open Loop Response"); xlabel("Time [sec]"); ylabel("Rotational Position $\theta$","Interpreter","latex"); legend("Step Input", "Ramp Input", "Parabolic Input", "Location", "northwest")

tf2ss([1500], [1 21.67 33.4 0])

%% Part B
clear,clc,close all
%State Matrix Equation
A = [-21.67 -33.4 0;
      1      0    0;
      0      1    0];

B = [1500; 0; 0];
C = eye(3);
%Time
tf = 1;
t = linspace(0,tf,1000);
%Weightings
R = 1;
Q = zeros(3);
F = [0 0 0; 
    0 0 0; 
    0 0 1];
%Initial and Final Conditions for States
x0 = [0;0;0];
xf = [0;0;pi/4];
%Preliminary Calculations
E = B*(1/R)*B';
V = C'*Q*C;
W = C'*Q;
%Solving For Riccatti Coefficients
[sol_P] = ode45(@(t,p) pFun(t, p, A, E, V), [tf,0], F(:));
P = deval(sol_P,t);
%Solving for final state contribution
sol_g = ode45(@(t,g) gFun(t,g,sol_P,A,E), [tf 0], F*xf);
G = deval(sol_g,t);
%Solving for states
sol_x = ode45(@(t,x) xFun(t,x,sol_P,sol_g,A,E), [0 tf], x0);
X = deval(sol_x,t);
%Solving for gains and optimal input
for i = 1:length(t)
    Pi = reshape(P(:,i),3,3);
    gi = G(:,i);
    xi = X(:,i);
    Ki = (1/R)*B'*Pi;
    K(:,i) = Ki(:);
    u(i) = -Ki*xi + (1/R)*B'*gi;
end
%Plotting
figure
subplot(1,3,1)
plot(t,K')
title("Gains vs time"); xlabel("Time [sec]"); ylabel("Gains"); 
subplot(1,3,2)
plot(t,u')
title("Input vs time"); xlabel("Time [sec]"); ylabel("Input"); 
subplot(1,3,3)
plot(t,X(3,:).*(180/pi))
title("Output vs time"); xlabel("Time [sec]"); ylabel("Rotational Position [deg]"); 
sgtitle("$Q = 0, F \neq 0$", 'interpreter', 'latex')
%%
%State Matrix Equation
A = [-21.67 -33.4 0;
      1      0    0;
      0      1    0];

B = [1500; 0; 0];
C = eye(3);

%Time
tf = 1;
t = linspace(0,tf,1000);

%Weightings
R = 1;
Q = [0 0 0; 
    0 0 0; 
    0 0 1];
F = [0 0 0; 
    0 0 0; 
    0 0 0];

%Initial and Final Conditions for States
x0 = [0;0;0];
xf = [0;0;pi/4];

%Preliminary Calculations
E = B*(1/R)*B';
V = C'*Q*C;
W = C'*Q;

%Solving For Riccatti Coefficients
[sol_P] = ode45(@(t,p) pFun(t, p, A, E, V), [tf,0], F(:));
P = deval(sol_P,t);
%Solving for final state contribution
sol_g = ode45(@(t,g) gFun(t,g,sol_P,A,E), [tf 0], F*xf);
G = deval(sol_g,t);
%Solving for states
sol_x = ode45(@(t,x) xFun(t,x,sol_P,sol_g,A,E), [0 tf], x0);
X = deval(sol_x,t);

%Solving for gains and optimal input
for i = 1:length(t)
    Pi = reshape(P(:,i),3,3);
    gi = G(:,i);
    xi = X(:,i);
    Ki = (1/R)*B'*Pi;
    K(:,i) = Ki(:);
    u(i) = -Ki*xi + (1/R)*B'*gi;
end

%Plotting
figure
subplot(1,3,1)
plot(t,K')
title("Gains vs time"); xlabel("Time [sec]"); ylabel("Gains"); 
subplot(1,3,2)
plot(t,u')
title("Input vs time"); xlabel("Time [sec]"); ylabel("Input"); 
subplot(1,3,3)
plot(t,X(3,:).*(180/pi))
title("Output vs time"); xlabel("Time [sec]"); ylabel("Rotational Position [deg]"); 
sgtitle("$Q \neq 0, F = 0$", 'interpreter', 'latex')

%%
%State Matrix Equation
A = [-21.67 -33.4 0;
      1      0    0;
      0      1    0];

B = [1500; 0; 0];
C = eye(3);

%Time
tf = 1;
t = linspace(0,tf,1000);

%Weightings
R = 1;
Q = [0 0 0; 
    0 0 0; 
    0 0 1];
F = [0 0 0; 
    0 0 0; 
    0 0 1];

%Initial and Final Conditions for States
x0 = [0;0;0];
xf = [0;0;pi/4];

%Preliminary Calculations
E = B*(1/R)*B';
V = C'*Q*C;
W = C'*Q;

%Solving For Riccatti Coefficients
[sol_P] = ode45(@(t,p) pFun(t, p, A, E, V), [tf,0], F(:));
P = deval(sol_P,t);
%Solving for final state contribution
sol_g = ode45(@(t,g) gFun(t,g,sol_P,A,E), [tf 0], F*xf);
G = deval(sol_g,t);
%Solving for states
sol_x = ode45(@(t,x) xFun(t,x,sol_P,sol_g,A,E), [0 tf], x0);
X = deval(sol_x,t);

%Solving for gains and optimal input
for i = 1:length(t)
    Pi = reshape(P(:,i),3,3);
    gi = G(:,i);
    xi = X(:,i);
    Ki = (1/R)*B'*Pi;
    K(:,i) = Ki(:);
    u(i) = -Ki*xi + (1/R)*B'*gi;
end

%Plotting
figure
subplot(1,3,1)
plot(t,K')
title("Gains vs time"); xlabel("Time [sec]"); ylabel("Gains"); 
subplot(1,3,2)
plot(t,u')
title("Input vs time"); xlabel("Time [sec]"); ylabel("Input"); 
subplot(1,3,3)
plot(t,X(3,:).*(180/pi))
title("Output vs time"); xlabel("Time [sec]"); ylabel("Rotational Position [deg]"); 
sgtitle("$Q \neq 0, F \neq 0$", 'interpreter', 'latex')
function dpdt = pFun(t,p,A,E,V)
    P = reshape(p,3,3);
    dP = -A'*P - P*A + P*E*P - V;
    dpdt = dP(:);
end
function dgdt = gFun(t,g,sol_P,A,E)
    P = reshape(deval(sol_P,t),3,3);
    dgdt = -(A' - P*E)*g;
end
function dxdt = xFun(t,x,sol_P,sol_g,A,E)
    P = reshape(deval(sol_P,t),3,3);
    g = deval(sol_g,t);
    dxdt = (A - E*P)*x + E*g;
end

