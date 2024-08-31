clear, clc, close all

load("data.mat");
Max_volts = 10;
Max_motor_command = 400;

figure
subplot(2,1,1)
plot(t,V,"o")
xlabel("Time [sec]")
ylabel("Velocity [rad/sec]")
title("Step Response | Voltage vs Time")

voltage = Max_volts .* (M./Max_motor_command);

subplot(2,1,2)
plot(t,voltage, "o")
xlabel("Time [sec]")
ylabel("Voltage [Volts]")
title("Step Response | Voltage vs Time")
%%
omega_ss = V(end);

index = V<0.96*omega_ss & V>0;
figure
plot(t(index),log(1-(V(index)./omega_ss)),"o")
title("Linearization of Speed vs Time")
xlabel("Time")
ylabel("Linearization of Velocity")

tau = 1/15.37;
k = omega_ss/7.5;

G = tf(k,[tau,1]);
new_t = linspace(0,t(end),length(index));

subplot(2,1,1)
stepinput = step(G,new_t) * 7.5;
plot(new_t,stepinput)
hold on
plot(t,V,"o")
xlabel("Time [sec]")
ylabel("Velocity [rad/sec]")
title("Step Response Comparison of Experimental vs Theoretical Data")
legend("Theoretical","Experimental","Location","southeast")
hold off
subplot(2,1,2)
plot(t,voltage, "o")
xlabel("Time [sec]")
ylabel("Voltage [Volts]")
title("Step Response | Voltage vs Time")
