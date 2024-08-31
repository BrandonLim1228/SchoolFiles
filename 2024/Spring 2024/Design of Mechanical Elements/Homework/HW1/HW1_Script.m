clear,clc,close all
diam = [5.192198 5.111202 5.110125 5.058226 5.219299 4.96468 4.875128 5.018286 5.059872 5.010259 4.887658 5.03657 4.975399 5.059767 5.020255 5.072123 5.051705 4.852453 4.99383 5.093727 4.936308 4.968586 4.866 4.942957 5.037932 5.074329 4.949296 4.939992 5.011332 4.912905];
%Calculating mean and standard deviation
meanDiameter = mean(diam)
stdDiameter = std(diam)
%Plotting Histogram
figure
histogram(diam,50)
title("Shaft Diameter Histogram");
xlabel("Shaft Diameter [mm]");
ylabel("Frequency");

%% 3
clear, clc, close all
x= [0.2 0.4 0.6 0.8 1.0 2.0];
F = [7.1 10.3 12.1 13.8 16.2 25.2];

mdl = fitlm(x,F)

figure
plot(x,F,"ro")

hold on
xvec = [0:2]
plot(xvec,(5.9787 + 9.7656.*xvec))

xlabel("in");
ylabel("Force [lbf]");
title("Force of a Spring")

%% 4
clear, clc, close all
format longg
A = [1.98 2 1.94 2.02, 2.12];
B = [3.1 2.9 3.02 3.09 3.25];

meanA = mean(A)
stdA = std(A)

meanB = mean(B)
stdB = std(B)

cov(A,B)
corrcoef(A,B)

fitlm(A,B)

plot(A,B, "ro")
xvec = [0:3]
hold on 
plot(xvec,(0.37 + 1.343.*xvec))
%% 6 b
clear, clc, close all
meanC = 15;
stdC = 0.2;
meanS = 10;
stdS = [0:0.1:0.5];
covSC = 0.2 .* stdS .* stdC;
stdBag = sqrt((stdC.^2) + (stdS.^2) + 2.*covSC);
figure
plot(stdS,stdBag,"-o")
title("Std Weight of Bag vs Std Weight of Sand");
xlabel("Standard Deviation of Sand Weight[kg]")
ylabel("Standard Deviation of Bag Weight[kg")

%% 6 c
clear, clc, close all
meanC = 15;
stdC = 0.2;
meanS = 10;
stdS = 0.2;
CC = [-1:0.1:1]
covSC = CC .* stdC .* stdS
stdBag = sqrt((stdC.^2) + (stdS.^2) + 2.*covSC);
figure
plot(CC,stdBag,"-o")
title("Correlation Coefficient vs STD of Bag Weight");
xlabel("Correlation Coefficient")
ylabel("Standard Deviation of Bag Weight[kg]")

%% 7 
clear, clc, close all

[M,V] = wblstat(700,3);
M = M +400











