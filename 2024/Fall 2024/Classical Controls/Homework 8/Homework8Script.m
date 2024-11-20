%% Problem 1
clear, clc, close all
%1a)
sys = tf([1,3,2],[1 -3 2])
rlocus(sys)
%1b)
[K, POLES] = rlocfind(sys)
%% Problem 2
clear, clc, close all
%1a)
sys = tf([1 1.5], [1 11 10 0]);
rlocus(sys,0:0.005:50);
sgrid(0.799839691078,0)
%1d)
k = [39.6 12.8 7.34];
Gcl1 = tf([k(1) ,k(1)*1.5], [1 11 (10+k(1)) (k(1)*1.5)]);
Gcl2 = tf([k(2) ,k(2)*1.5], [1 11 (10+k(2)) (k(2)*1.5)]);
Gcl3 = tf([k(3) ,k(3)*1.5], [1 11 (10+k(3)) (k(3)*1.5)]);
OvershootK396 = stepinfo(Gcl1).Overshoot;
OvershootK128 = stepinfo(Gcl2).Overshoot;
OvershootK734 = stepinfo(Gcl3).Overshoot;
k = linspace(0,7.34,1000);
best_k = 0;
for i = 1:length(k)
    Gcl(i) = tf([k(i) ,k(i)*1.5], [1 11 (10+k(i)) (k(i)*1.5)]);
    overshoot = stepinfo(Gcl(i)).Overshoot;
    if overshoot < 1.522 && overshoot > 1.517
        best_k = k(i)
        overshoot
    end
end
%% Problem 3 a
clear, clc, close all
%1a)
Dc = tf([80 1.8*80], [1 22])
G = tf([1], [1 0 0])
Gcl = feedback(Dc*G,1)
figure
step(Gcl)
figure
step(G)
figure
rlocus(Gcl)
stepinfo(Gcl)
%% Problem 3 b
clear, clc, close all
Gs = tf([1], [1 2 0]);
Dc = tf([2.08 2.08*0.1], [1 0.0208]);
Gcl = feedback(Gs * Dc,1);
t = linspace(0,10,100);
u(0 <= t & t <= 10) = t(0 <= t & t <= 10);
% u(1 <= t & t <= 10) = 1;
[yGcl,t] = lsim(Gcl,u,t);
[yGol,t] = lsim(Gs,u,t);
figure
plot(t,yGcl)
hold on
plot(t,u)
legend("Ramp Response","Ramp Input","Location","southeast")
xlabel("Time [sec]")
ylabel("Output")
title("Unit Ramp Response of Gcl(s)")
figure
plot(t,yGol)
hold on
plot(t,u)
legend("Ramp Response","Ramp Input","Location","southeast")
xlabel("Time [sec]")
ylabel("Output")
title("Unit Ramp Response of Gol(s)")
%% Problem 4
clear, clc, close all
    Gol = tf([1], [1 12.828 44.28 160 0]);
    Gcl = tf([96.775 387.1 387.1],[1 15.656 72.56 (160+96.775) 387.1 387.1]);
    figure
    step(Gol);
    figure
    step(Gcl);
    stepinfo(Gcl)
    Kp = 387.1+50;
    Kd = 96.77+10;
    Ki = 387.1-100;
    Gcltrial = tf([Kd Kp Ki],[1 15.656 72.56 (160+Kd) Kp Ki])
    step(Gcltrial)
    stepinfo(Gcltrial)















