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
 Dc = tf([2.077 2.077*0.05], [1 0.013]);
 Gol = Gs * Dc
 Gcl = feedback(Gol,1)
 rlocus(Gol)
 roots([1 2.013 2.013 0.1038])
    