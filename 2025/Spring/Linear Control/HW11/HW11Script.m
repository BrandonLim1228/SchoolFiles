%Brandon Lim HW11
%% Problem 1
clear, clc, close all

A = [-3 5; 0 -2];
B = [1; -1];
C = [1 0];
D = 0;
sys = ss(A,B,C,D);
t = linspace(0,10,100);
u = ones(1,length(t));
x0_est = [0;0];
x0_act = [2;-2];
O = [C; C*A];

[yact,tact,xact] = lsim(sys,u,t,x0_act);
[yest,test,xest] = lsim(sys,u,t,x0_est);

figure
plot(tact,xact)
hold on
plot(test,xest)
legend("X1 Actual", "X2 Actual", "X1 Estimated", "X2 Estimated")
title("Real & Open Loop Estimated States vs Time for a Unit Step Input")
xlabel("Time [Sec]"); ylabel("State Value")

L = [-3; 1/5];
Atilda = [0 5; -1/5 -2];
Btilda = [1 -3;-1 1/5];
sys2 = ss(Atilda,Btilda,C,D);
[y2est,t2est,x2est] = lsim(sys2,[u;yact'],t,x0_est);

figure
plot(t,xact)
hold on
plot(t2est,x2est)
legend("X1 Actual", "X2 Actual", "X1 Estimated", "X2 Estimated")
title("Real & Closed Loop Estimated States vs Time for a Unit Step Input Lambda = -1")
xlabel("Time [Sec]"); ylabel("State Value")

L = [7;16/5];
Atilda2 = [-10 5;-16/5 -2];
Btilda2 = [1 7;-1 16/5];
sys3 = ss(Atilda2,Btilda2,C,D);
[y3est,t3est,x3est] = lsim(sys3,[u;yact'],t,x0_est);

figure
plot(t,xact)
hold on
plot(t3est,x3est)
legend("X1 Actual", "X2 Actual", "X1 Estimated", "X2 Estimated")
title("Real & Closed Loop Estimated States vs Time for a Unit Step Input Lambda = -6")
xlabel("Time [Sec]"); ylabel("State Value")
%% Problem 2
clear, clc, close all

A = [-3.4 4.6; 0 -1.7];
B = [1.2; -0.8];
C = [1.1 0];
D = 0;
sys = ss(A,B,C,D);
t = linspace(0,10,100);
u = ones(1,length(t));
x0_est = [0;0];
x0_act = [2;-2];
O = [C; C*A];

[yact,tact,xact] = lsim(sys,u,t,x0_act);
[yest,test,xest] = lsim(sys,u,t,x0_est);

figure
plot(tact,xact)
hold on
plot(test,xest)
legend("X1 Actual", "X2 Actual", "X1 Estimated", "X2 Estimated")
title("Real & Open Loop Estimated States vs Time for a Unit Step Input")
xlabel("Time [Sec]"); ylabel("State Value")

L = [-3; 1/5];
Atilda = [0 5; -1/5 -2];
Btilda = [1 -3;-1 1/5];
sys2 = ss(Atilda,Btilda,C,D);
[y2est,t2est,x2est] = lsim(sys2,[u;yact'],t,x0_est);

figure
plot(t,xact)
hold on
plot(t2est,x2est)
legend("X1 Actual", "X2 Actual", "X1 Estimated", "X2 Estimated")
title("Real & Closed Loop Estimated States vs Time for a Unit Step Input Lambda = -1")
xlabel("Time [Sec]"); ylabel("State Value")

L = [7;16/5];
Atilda2 = [-10 5;-16/5 -2];
Btilda2 = [1 7;-1 16/5];
sys3 = ss(Atilda2,Btilda2,C,D);
[y3est,t3est,x3est] = lsim(sys3,[u;yact'],t,x0_est);

figure
plot(t,xact)
hold on
plot(t3est,x3est)
legend("X1 Actual", "X2 Actual", "X1 Estimated", "X2 Estimated")
title("Real & Closed Loop Estimated States vs Time for a Unit Step Input Lambda = -6")
xlabel("Time [Sec]"); ylabel("State Value")

%% Problem 3
clear, clc, close all

A = [0 0;1 0];
B = [1/5; 0];
F = 20;

ui = 0.1;

xi = 1;

R = [(1/F)^2];
Q = [(1/xi)^2 0; 0 (1/xi)^2];

[K,~,~] = lqr(A,B,Q,R);

sys = ss((A-B*K),B,[1 0;0 1],[0]);
t = linspace(0,10,1000);


[y1,t,x1] = lsim(sys,zeros(1,length(t)),t,[0;ui]);
u = -K * transpose(x1);

figure
subplot(3,1,1)
plot(t,y1(:,1))
title("Iteration 1: Velocity vs Time")
xlabel("Time[sec]"); ylabel("Velocity [m/s]")
subplot(3,1,2)
plot(t,y1(:,2))
title("Iteration 1: Position vs Time")
xlabel("Time[sec]"); ylabel("Position [m]")
subplot(3,1,3)
plot(t,u)
title("Iteration 1: Force vs Time")
xlabel("Time[sec]"); ylabel("Force [N]")

R = [(1/F)^2];
Q = [100*(1/xi)^2 0; 0 100*(1/xi)^2];

[K,~,~] = lqr(A,B,Q,R);

sys = ss((A-B*K),B,[1 0;0 1],[0]);
t = linspace(0,10,1000);


[y2,t,x2] = lsim(sys,zeros(1,length(t)),t,[0;ui]);
u = -K * transpose(x2);

figure
subplot(3,1,1)
plot(t,y2(:,1))
title("Iteration 2: Velocity vs Time")
xlabel("Time[sec]"); ylabel("Velocity [m/s]")
subplot(3,1,2)
plot(t,y2(:,2))
title("Iteration 2: Position vs Time")
xlabel("Time[sec]"); ylabel("Position [m]")
subplot(3,1,3)
plot(t,u)
title("Iteration 2: Force vs Time")
xlabel("Time[sec]"); ylabel("Force [N]")

R = [50*(1/F)^2];
Q = 10*[100*(1/xi)^2 0; 0 500*(1/xi)^2];

[K,~,~] = lqr(A,B,Q,R);

sys = ss((A-B*K),B,[1 0;0 1],[0]);
t = linspace(0,10,1000);


[y3,t,x3] = lsim(sys,zeros(1,length(t)),t,[0;ui]);
u = -K * transpose(x3);

figure
subplot(3,1,1)
plot(t,y3(:,1))
title("Iteration 3: Velocity vs Time")
xlabel("Time[sec]"); ylabel("Velocity [m/s]")
subplot(3,1,2)
plot(t,y3(:,2))
title("Iteration 3: Position vs Time")
xlabel("Time[sec]"); ylabel("Position [m]")
subplot(3,1,3)
plot(t,u)
title("Iteration 3: Force vs Time")
xlabel("Time[sec]"); ylabel("Force [N]")

