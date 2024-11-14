%Brandon Lim
clear, clc, close all
 
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
        sys = tf([1 1.5], [1 11 10 0])
        rlocus(sys,0:0.005:50)
        sgrid(0.799839691078,0)
    %1d)
        k = [39.6 12.8 7.34]
        Gcl1 = tf([k(1) ,k(1)*1.5], [1 11 (10+k(1)) k(1)*1.5])
        Gcl2 = tf([k(2) ,k(2)*1.5], [1 11 (10+k(2)) k(2)*1.5]);
        Gcl3 = tf([k(3) ,k(3)*1.5], [1 11 (10+k(3)) k(3)*1.5]);

        [y,t] = step(Gcl1,linspace(0,10,100000));
        OvershootK396 = stepinfo(y,t)
        plot(t,y)
        % OvershootK128 = stepinfo(Gcl2).Overshoot
        % OvershootK734 = stepinfo(Gcl3).Overshoot

  