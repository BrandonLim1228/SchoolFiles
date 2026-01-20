clear,clc

%p1
gs1 = tf([1 2], [1 3 2])
gs2 = tf([-1 2], [1 3 2])

figure
step(gs1)
figure
step(gs2)