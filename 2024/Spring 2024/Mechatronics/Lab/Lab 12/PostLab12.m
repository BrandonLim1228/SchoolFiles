%Brandon Lim u1244501
clear, clc, close all

load("PreLabKp_p4.mat")
Kp = 12.27;

G = tf(1.4*12.27, [0.07 1 Kp*1.4]);

figure
plot(time,position, "o")
hold on 
s = stepplot(G)
xlabel("Time [sec]")
ylabel("Position [rad]")
title("Step Response | Kp = 12.27 | Brandon Lim u1244501")
legend("Experimental", "Theoretical", "Location","southeast")

Max_position_ex = max(position);
Position_ss_ex = position(end);
Experimental_Percent_OS = 100 * (Max_position_ex-Position_ss_ex)/Position_ss_ex;

Max_position_theo = 1.2;
Position_ss_theo = 1.01;
Theoretical_Percent_OS = 100 * (Max_position_theo-Position_ss_theo)/Position_ss_theo;
text(0.15,0.9,"Experimental %OS = 10.68%")
text(0.15,0.8,"Theoretical %OS = 18.81%")
text(0.15,0.7,"Experimental T_s = 0.355 sec")
text(0.15,0.6,"Theoretical T_s = 0.56 sec")

load("PreLabKp_p5.mat")
Kp = 2.55;
G = tf(1.4*Kp, [0.07 1 Kp*1.4]);

figure
plot(time,position, "o")
hold on 
stepplot(G)
xlabel("Time [sec]")
ylabel("Position [rad]")
title("Step Response | Kp = 2.55 | Brandon Lim u1244501")
legend("Experimental", "Theoretical", "Location","southeast")

Max_position_ex = max(position);
Position_ss_ex = position(end);
Experimental_Percent_OS = 100 * (Max_position_ex-Position_ss_ex)/Position_ss_ex;

Max_position_theo = 1.2;
Position_ss_theo = 1.01;
Theoretical_Percent_OS = 100 * (Max_position_theo-Position_ss_theo)/Position_ss_theo;
text(0.4,0.55,"Experimental %OS = 0%")
text(0.4,0.45,"Theoretical %OS = 0%")
text(0.4,0.35,"Experimental T_s = 0.6 sec")
text(0.4,0.25,"Theoretical T_s = 1 sec")

%%
clear, clc, close all
load("PreLabKpKd_p6.mat")
Kp = 18.66;
Kd = 0.62;

G = tf(0.5 * [1.4*Kd 1.4*Kp], [0.07 (1+1.4*Kd) 1.4*Kp]);

figure
plot(time,position, "o")
hold on 
stepplot(G) 
xlabel("Time [sec]")
ylabel("Position [rad]")
title("PD Controller | Kp = 18.66, Kd = 0.62 | Brandon Lim u1244501")
legend("Experimental", "Theoretical", "Location","southeast")

Max_position_ex = max(position);
Position_ss_ex = position(end);
Experimental_Percent_OS = 100 * (Max_position_ex-Position_ss_ex)/Position_ss_ex;

Max_position_theo = 0.534;
Position_ss_theo = 0.499;
Theoretical_Percent_OS = 100 * (Max_position_theo-Position_ss_theo)/Position_ss_theo;
text(0.15,0.4,"Experimental %OS = 0%")
text(0.15,0.3,"Theoretical %OS = 7.014%")
text(0.15,0.2,"Experimental T_s = 0.175 sec")
text(0.15,0.1,"Theoretical T_s = 0.277 sec")
%%
%Brandon Lim
clear, clc, close all
load("PID_control_gains.mat")

Gp = tf(1.4, [0.07 1 0]);
Gc = pid(40, 300, 0.5);
Gcl = feedback(Gc*Gp,1);

figure
plot(time,position,"o")
hold on
step(0.25*Gcl)
xlabel("Time [sec]")
ylabel("Position [rad]")
title("PID Controller | Kp = 40, Kd = 0.5, Ki = 300 | Brandon Lim u1244501")
legend("Experimental", "Theoretical", "Location","southeast")

Max_position_ex = max(position);
Position_ss_ex = position(end);
Experimental_Percent_OS = 100 * (Max_position_ex-Position_ss_ex)/Position_ss_ex;

Max_position_theo = 0.367;
Position_ss_theo = 0.252;
Theoretical_Percent_OS = 100 * (Max_position_theo-Position_ss_theo)/Position_ss_theo;
text(0.1,0.2,"Experimental %OS = 38.3%")
text(0.1,0.15,"Theoretical %OS = 45.6%")
text(0.1,0.1,"Experimental T_s = 0.286 sec")
text(0.1,0.05,"Theoretical T_s = 0.603 sec")










