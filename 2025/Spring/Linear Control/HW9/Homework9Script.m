%Brandon Lim HW9 Linear Control 

%% Problem 3
clear, clc, close all
A = [-15 -79 -145; 1 0 0; 0 1 0];
I = [1 0 0; 0 1 0; 0 0 1];
B = [2;0;0];
C = [10 0 0];
D = [0];
continousTimeSys = ss(A,B,C,D);
ctControlM = [B A*B (A^2) * B];
rnkctM = rank(ctControlM);
discreteTimeSys = c2d(continousTimeSys,1)
dtControlM = [discreteTimeSys.B discreteTimeSys.A*discreteTimeSys.B (discreteTimeSys.A^2)*discreteTimeSys.B]
rnkdtM = rank(dtControlM)
Abar = expm(A)
Bbar = inv(A) * (Abar-I) * B
eig(A);
T = pi/2 *1
[ad,bd] = c2d(A,B,T)
rank(ctrb(ad,bd))

%% Problem 4
clear, clc, close all
A = [-1 4; 4 -1];
B = [1 ; 1];
C = [1 1];
D = 0;

cM = [B A*B];
rank(cM);

Pinv = [1 0; 1 1];
P = inv(Pinv);

atil = P*A*Pinv
btil = P*B
ctil = C*Pinv