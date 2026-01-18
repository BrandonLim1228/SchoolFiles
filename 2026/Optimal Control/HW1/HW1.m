clear, clc, close all

%% Probelm 5
A = [-2 1; -1 -3];
B = [1; 0];

Co = ctrb(A,B)
rank_Co = rank(Co)

%% Problem 6
A = [1 0; 0 -2];
B = [1;-1];
K = [0 1]* [(2/3) (-1/3); (1/3) (1/3)] * [3.25 0; 0 3.25];

ACL = (A-B*K);
c = [1 0; 0 1];
x0 = [1;0];
sys = ss(ACL,[],c,[]);

[y,tOut,x] = initial(sys,x0);

figure
subplot(2,1,1)
plot(tOut, y(:,1))
xlabel("Time [Sec]"); ylabel("Amplitude"); title("x_1")
subplot(2,1,2)
plot(tOut, y(:,2))
xlabel("Time [Sec]"); ylabel("Amplitude"); title("x_2")
sgtitle("Simulated Response Of Closed Loop System")

%% Problem 8
eig([3 -1 0; -1 2 -1; 0 -1 3])

