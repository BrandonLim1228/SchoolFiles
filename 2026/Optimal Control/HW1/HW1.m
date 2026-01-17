clear, clc, close all

% P5
A = [-2 1; -1 -3];
B = [1; 0];

Co = ctrb(A,B)
rank(Co)

%%
A = [1 0; 0 -2];
B = [1;-1];
K = [0 1]* [(2/3) (-1/3); (1/3) (1/3)] * [3.25 0; 0 3.25];

ACL = (A-B*K);

sys = ss(ACL, B, [1 0; 0 1], [0]);
t = linspace(0,50,100);
u = zeros(1,length(t));

figure
lsim(sys,u,t, [1 0])

%%
B = [5 -4 2; -1 2 3; -2 1 0]
norm(B,1)
norm(B,inf)


