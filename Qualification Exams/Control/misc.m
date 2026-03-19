clear,clc,close all

L = tf(2000, [1 200 0]);
bode(L)
%%
clear,clc,close all
L = tf([1 2], [1 12 22 20 0])
bode(L)

%%
clear,clc,close all
L = tf([0.9695], [1/25 3/25 27/25 1 0])
bode(L)

rlocus(L)