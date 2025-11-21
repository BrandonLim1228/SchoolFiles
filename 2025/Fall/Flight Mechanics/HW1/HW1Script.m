clear, clc, close all

NACA0009 = 200*readmatrix("NACA0009.txt");
NACA0015 = readmatrix("NACA0015.txt");

figure
subplot(2,1,1)
plot(NACA0009(:,1),NACA0009(:,2),"k")
hold on
plot([0 200],[0 0], "b")
plot([(0.3*200) (0.3*200)],[(0.09*200/2) -(0.09*200/2)],"g")
legend("NACA0009 Airfoil","Chord","t_m_a_x = 0.09c","location","southeast")
title("NACA0009");xlabel("x");ylabel("y")
axis equal

subplot(2,1,2)
plot(NACA0015(:,1),NACA0015(:,2),"k")
hold on
plot([0 1],[0 0], "b")
plot([(0.3*1) (0.3*1)],[(0.15*1/2) -(0.15*1/2)],"g")
legend("NACA0015 Airfoil","Chord","t_m_a_x = 0.15c","location","southeast")
title("NACA0015");xlabel("x/c");ylabel("y/c")
axis equal