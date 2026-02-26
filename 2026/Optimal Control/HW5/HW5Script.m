clear,clc,close all
syms s

%Original System
A = [-1.169 -50.3 -49.94 -685.3 -391.7 -1952;
    1 0 0 0 0 0;
    0 1 0 0 0 0;
    0 0 1 0 0 0;
    0 0 0 1 0 0;
    0 0 0 0 1 0];
B = [1;0;0;0;0;0];
C = [0 11.88 4.977 539.6 129.9 5625];
D = 0;
SI = [s 0 0 0 0 0;
    0 s 0 0 0 0;
    0 0 s 0 0 0;
    0 0 0 s 0 0;
    0 0 0 0 s 0;
    0 0 0 0 0 s];

%Transfer Function Calculation
Transfer_Function_Orig = simplify(C*(inv(SI-A))*B);

%Inverted A and B matricies for ff control
A_new = A-(B*inv(C*A*B)*C*A*A);
B_new = B*(inv(C*A*B));

%State Space Forms
sys_new = ss(A_new,B_new,C,D);
sys_org = ss(A,B,C,D);

%Eigen Values
eig(A);
eig(A_new);

%New Transfer Function
Transfer_Function_New = simplify(C*(inv(SI-A_new))*B_new);


%Acceleration Reference Input
t = linspace(0,10,1000);
yddot(t>=0 & t<1) = 1;
yddot(t>=1 & t<3) = -1;
yddot(t>=3 & t<4) = 1;
yddot(t>=4 ) = 0;

ydot = cumtrapz(t,yddot);


[yd, t, xref] = lsim(sys_new,yddot,t);
figure
hold on
plot(t, yd)
plot(t,ydot)
plot(t,xref)
legend("$Y_d$", "$\dot{Y}_d$", "$x_1$", "$x_2$", "$x_3$", "$x_4$", "$x_5$", "$x_6$","Interpreter", "Latex")
xlabel("Time [sec]"); ylabel("Response"); title("$y_d, \dot{y}_d, x_{ref}$ vs Time", "Interpreter","latex")

uff = inv(C*A*B) .* (yddot - C*A*A*xref');
figure
plot(t,uff)
xlabel("Time [sec]"); ylabel("$U_{ff}$", "Interpreter","latex"); title("Input vs Time")

[yopt,t,x] = lsim(sys_org,uff,t);
figure
hold on
plot(t,yopt)
plot(t,yd)
xlabel("Time [sec]"); ylabel("Response"); title("Desired Reference and True Reference vs Time")
legend("Output from $u_{ff}$", "Reference Input", "Interpreter","latex")
