%Brandon Lim
%Homework 6 Classical Control Systems
clear, clc, close all

%Problem 1
    %Initialzing variable
        t = linspace(0,50,1000);
    %Input 
        r = zeros(size(t));
        r(0 <= t & t < 10) = t(0 <= t & t < 10);
        r(10 <= t & t < 20) = 10-r(0 <= t & t < 10);
        r(20 <= t & t < 30) = t(0 <= t & t < 10);
        r(30 <= t & t < 40) = 10-r(0 <= t & t < 10);
    %Transfer function
        Gs = tf([75 75],[1 30 200 75])
        Es = tf([1 30 125 0], [1 30 200 75])
    %Plotting time response of the output of the close-loop system (a)
        figure
        [y1,tOut1] = lsim(Gs,r(1:800),t(1:800));
        plot(tOut1,y1)
        xlabel("Time [Seconds]")
        ylabel("Output")
        title("Time response of the Output of the Closed-Loop System")
    %Plotting tracking error as a function of time
        figure
        [y2,tOut2] = lsim(Es,r(1:800),t(1:800))
        plot(tOut2,y2)
        xlabel("Time [Seconds]")
        ylabel("Tracking Error")
        title("Time response of the Tracking Error")