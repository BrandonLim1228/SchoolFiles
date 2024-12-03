%Brandon Lim Classical Control Homework 9
clear, clc, close all

%% 2d
clear, clc, close all
sys = tf([1 2],[1 16 85 250 0 0])
bode(sys)
%% 3a
clear, clc, close all
sys = tf([2000],[1,200 0])
bode(sys)
%% 3b
clear, clc, close all
sys = tf([100],[0.05 0.6 1 0])
bode(sys) 
%% 3c
clear, clc, close all
sys = tf([1],[0.02 1.02 1 0])
bode(sys)
%% 4a
clear, clc, close all
sys = tf([1],[0.04 0.12 1.08 1 0])
bode(sys)
%% 4c
clear, clc, close all
K = linspace(1,2,1000);
for i = 1:length(K)
    sys = tf([K(i)],[0.04 0.12 1.08 1 0]);
    [Gm,Pm] = margin(sys);
    if Pm < 45+0.01 && Pm > 45 - 0.01
        OptimalK = K(i)
        Gm_OK = Gm
        PhaseM = Pm
        sys
        bode(sys)
    end
end
%% 4d
clear, clc, close all
sys = tf([1],[0.04 0.12 1.08 1 0])
rlocus(sys)
r=rlocus(sys,1.115)