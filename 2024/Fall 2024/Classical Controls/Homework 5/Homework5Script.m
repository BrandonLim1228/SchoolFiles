% Homework 5
% Brandon Lim
clear, clc, close all
%Problem 1 part 2
    OneA_Roots = roots([1 5 2]);
    OneB_Roots = roots([1 4 8 4]);
    OneC_Roots = roots([1 2 -6 20]);
    OneD_Roots = roots([1 1 2 12 10]);
%Problem 3 part b
    K = 90/8;
    TF = tf([(1/3)*K/(0.125)], [1 7 14 8*(1+(1/3)*K)]);
    [y,t] = step(TF,linspace(0,20,1000));
    Sinfo = stepinfo(TF);
    Ts = Sinfo.SettlingTime
    final_val = sum(y(end-10:end,1))/11;
    plusTwo =  final_val + (final_val * 0.02);
    minusTwo = final_val - (final_val * 0.02); 
    figure 
        plot(t,y,"LineWidth",1)
        xlabel("Time [sec]")
        ylabel("Output")
        title("Step Response of One-third the Limiting Gain of K")
    hold on 
        yline(minusTwo,"LineWidth",1)
    hold on 
        yline(plusTwo,"LineWidth",1)
        legend("Step Response","+- 2% Final Value Bounds")
%%
%Problem 3 part c
    K = linspace(1,3,100000);
    for i = 1:length(K)
        TF = tf([K(i)/(0.125)], [1 7 14 8*(1+K(i))]);
        S1 = stepinfo(TF);
        Ts = S1.SettlingTime;
        if Ts < 4.001 & Ts >3.999
            GainK = K(i);
            TsFinal = Ts;
            break
        end
    end
    G = tf([GainK/(0.125)], [1 7 14 8*(1+GainK)]);
    [y,t] = step(G);
    %Checking with graph
        figure
            plot(t,y, "LineWidth", 1)
            hold on
            plot(t,ones(length(t))*((sum(y(end-10:end))/11)+0.02*(sum(y(end-10:end))/11)),"--k", "LineWidth", 1)
            hold on
            plot(t,ones(length(t))*((sum(y(end-10:end))/11)-0.02*(sum(y(end-10:end))/11)),"--k", "LineWidth", 1)
            xlabel("Time (sec)")
            ylabel("Output")
            legend("K = 1.4015", "+- 2% Final Value Bounds")
s = roots([1 7 14 8*(1+GainK)])

