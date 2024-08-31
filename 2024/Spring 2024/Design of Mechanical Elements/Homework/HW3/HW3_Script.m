%% Brandon Lim
%HW3-Problem 7
clear, clc ,close all
format longG

E = 160*10^9; %Pa

massMean = 1*10^-8; %kg
massSTD = (1*10^-10)/3; %kg

lengthMean = 1*10^-4; %m
lengthSTD = (1*10^-7)/3; %m

widthMean = 2*10^-6; %m
WidthSTD = (1*10^-7)/3; %m

thicknessMean = 5*10^-5; %m
thicknessSTD = (2*10^-7)/3; %m

for i = 1:100000
    m(i) = norminv(rand,massMean,massSTD);
    l(i) = norminv(rand,lengthMean,lengthSTD);
    w(i) = norminv(rand,widthMean,WidthSTD);
    t(i) = norminv(rand,thicknessMean,thicknessSTD);
    S(i) = (4/E) * ((m(i)*(l(i))^3)/(w(i)*(t(i))^3));
end
meanS = mean(S)
stdS = std(S)

nominal = meanS
toleranceRange = stdS * 3

histogram(S)
xlabel("Sensitivity")
ylabel("Frequency")




