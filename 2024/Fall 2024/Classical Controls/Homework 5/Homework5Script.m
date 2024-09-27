% Homework 4
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
    
    

