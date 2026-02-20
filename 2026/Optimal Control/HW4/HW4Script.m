clear, clc, close all

% Time mesh (integral bounds of time to evaluate solution over)
tmesh = linspace(0, pi/2, 100);

% Initial guess mapped onto time mesh (Can be anything, better guesses will just save computation resources)
solinit = bvpinit(tmesh, [0 0 0 0]);

% Solve BVP
sol = bvp4c(@bvpfcn, @bcfun, solinit);

% ODE Function
function dxdt = bvpfcn(t,x)
    A = [ 0  1  0  0;
        -2  0  0 -9;
        0  0  0  2;
        0  0 -1  0];
    dxdt = A*x;
end

%Boundary Condition Function
function res = bcfun(xa,xb)
    % Boundary Condition vector
    res = zeros(4,1);
    % Fromatted via matlab guidelines for bvp4c (Boundary conditions set equal to zero)
    % Initial conditions
    res(1) = xa(1);          % x1(0) = 0
    res(2) = xa(2) - 1;      % x2(0) = 1
    % Final conditions
    res(3) = xb(1) - xb(3);  % l1(tf) = x1(tf) - l1(tf) = 0
    res(4) = xb(4);          % l2(tf) = 0
end

figure
plot(sol.x,sol.y)
legend("$x_1$","$x_2$", "$\lambda_1$", "$\lambda_2$", "Interpreter","latex")
xlabel("Time"); ylabel("State Value"); title("Optimal Control States vs Time")