clear, clc, close all

sys = tf([1 5.08 6.4516], [1 21.67 33.4 0 0])

rlocus(sys)
%%
Gcl = feedback(sys*366.72,1)
t = linspace(0,5,1000);
u = ones(1,length(t)) * (pi/2);
[y,t] = lsim(Gcl,u,t)

plot(t,y)
xlabel("Time [sec]")
ylabel("Output")
title("Step Response of Step Magnitude 1.57 Radians")

step(sys)

%%


sys1 = tf([1500], [1 21.67 33.4 0])
feedback(sys1,1)



load("Lab_3_data.mat")
plot(t,y,"LineWidth",1)
hold on
plot(part3time,part3data,"bx")
xlabel("Time [sec]")
ylabel("Position [radians]")
title("Step Response Using PID Gains found with Pole-Zero Form: Kp = 1.24, Ki = 1.58, Kd = 0.25")
legend("Simulated Step Response","Experimental Step Response")

sys2 = tf([90 1152 2304],[1, 24.67 33.4 0 0])
gcl2 = feedback(sys2,1)
[y1,t1] = lsim(gcl2,u,t)
figure
plot(t1,y1, "LineWidth",1)
hold on
plot(part5time,part5data,"bx")
hold on
plot(part7time,part7data,"rx")
xlabel("Time [sec]")
ylabel("Position [radians]")
title("Step Repsonse Using PID Gains found with Ultimate Sensitivity Method: Kp = 0.77, Ki = 1.54, Kd = 0.06")
legend("Simulated Step Response","Experimental Step Response","Experimental Step Response with Disturbance")

rlocus(sys)
%%
plot(out.tout,out.simout.signals.values)
xlabel("Time [sec]")
ylabel("Output");
title("Marginal Stablitity Plot For Ultimate Sensitivity Method")
legend("K* = 0.48")
