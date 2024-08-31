% Brandon Lim 
clear, clc, close all
No_Drive_Data = load("Lab11Data.mat");
M = No_Drive_Data.M;
V = No_Drive_Data.V;
t = No_Drive_Data.t;

omega_ss = V(end);
omega_tau = omega_ss * 0.632;

plot(t,V,"o");
xlabel("Time [sec]")
ylabel("Velocity [rad/sec]")
title("Velocity vs Time | Brandon Lim u1244501")
hold on
plot(1.06,omega_tau,"ro")
text(0.3,4.7,"tau estimated = 0.06, omega estimated = 4.316")

omega = V<0.96*omega_ss & V>0;

hold on
G = tf(1.363 * 5,[0.047 1]);
newt = linspace(1,t(end),length(omega));
newt = newt - 1;
x = step(G, newt);
plot(newt+1,x)
legend("Experimental","","Theoretical")

figure
plot(t(omega),log(1-(V(omega)./omega_ss)),"o")
title("Linearization of Speed vs Time | Brandon Lim u1244501")
xlabel("Time")
ylabel("Linearization of Velocity")

%% Brandon Lim 
clear, clc, close all
Drive_Data = load("Lab11DataDrive.mat");
M = Drive_Data.M;
V = Drive_Data.V;
t = Drive_Data.t;

plot(t,V,"o");
xlabel("Time [sec]")
ylabel("Velocity [rad/sec]")
title("Velocity vs Time | Brandon Lim u1244501")

Omega_ss = V(end);
Omega_tau = 0.632 * Omega_ss;
index = V<0.96*Omega_ss & V>0;

hold on
plot(1.07,Omega_tau,"o")
text(0.3,4,"tau estimated = 0.07, omega estimated = 4.259")
newt = linspace(1,t(end),length(index));
newt = newt - 1;
G = tf(1.348, [0.071, 1]);
stepinput = step(G,newt)*5;
plot(newt+1,stepinput)
legend("Experimental","","Theoretical")



figure
plot(t(index),log(1-(V(index)./Omega_ss)),"o")
title("Linearization of Speed vs Time | Brandon Lim u1244501")
xlabel("Time")
ylabel("Linearization of Velocity")
