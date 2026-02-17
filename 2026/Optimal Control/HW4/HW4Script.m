clear, clc, close all

syms x1(t) x2(t) l1(t) l2(t)

ode1 = diff(x1) == x2;
ode2 = diff(x2) == -9*l2-2*x1;
ode3 = diff(l1) == 2*l2;
ode4 = diff(l2) == -l1;
odes = [ode1;ode2;ode3;ode4]

s = dsolve(odes)
%%
syms u(t) v(t)
ode1 = diff(u) == 3*u + 4*v;
ode2 = diff(v) == -4*u + 3*v;
odes = [ode1; ode2]
S = dsolve(odes)

%%
clear,clc

syms l1(t) l2(t)
ode1 = diff(l1) == 2*l2;
ode2 = diff(l2) == -l1;
odes = [ode1; ode2]
S = dsolve(odes)
%%
clear,clc

%State equations
syms x1 x2 p1 p2 u;
Dx1 = x2;
Dx2 = -2*x1+3*u;

syms v;
v = 0.5*u^2;

syms p1 p2 H;
H = v + p1*Dx1 + p2*Dx2;

Dp1 = -diff(H,x1);
Dp2 = -diff(H,x2);
du = diff(H,u);

sol_u = solve(du, u);

Dx2 = subs(Dx2,u,sol_u);

% eq1 = strcat('Dx1 = ', Dx1);
% eq2 = strcat('Dx2 = ', Dx2);
% eq3 = strcat('Dp1 = ', Dp1);
% eq4 = strcat('Dp2 = ', Dp2);

sol_h = dsolve(Dx1,Dx2,Dp1,Dp2)

%%
clear, clc

A = [0 1 0 0; -2 0 0 0; 0 0 0 2; 0 0 -1 0];
[V,D] = eig(A)
%%
clear,clc

A = [0 1 0 0; -2 0 0 0; 0 0 0 2; 0 0 -1 0];

f = @(t,x) A*x;
[t,X] = ode45(f,[0 pi/2],[0;1;1;1]);

figure
plot(t,X(:,1))
hold on
plot(t,X(:,2))

figure
plot(t,X(:,3))
hold on
plot(t,X(:,4))