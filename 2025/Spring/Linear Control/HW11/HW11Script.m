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