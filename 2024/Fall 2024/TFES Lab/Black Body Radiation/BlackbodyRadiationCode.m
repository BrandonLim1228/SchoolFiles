%--------------------------------------------------------------------------
% TFES Lab ME EN 4650
%
% Black Body Radiation - Data Analysis
%
% Brandon Lim
% 11/12/24
%--------------------------------------------------------------------------
clear, clc, close all

%Experimental parameters
    sigma = 5.67*(10^-8); %Stephan Boltzmann constant
    Ad = 1 * 10 ^-6; %m^2
    Sr = 0; %sum of squared residuals
    St = 0; %sum of the total square variation

%Parsing Data
    %Experiment 1
        T_exp1 = 462.4 + 273.15; %Kelvin
        D_exp1 = 0.0254; %meters
        r_exp1 = [8:12] * 0.0254; %meters
        q_exp1 = [0.362 0.287 0.225 0.179 0.149] * (10^-4); %Watts
    %Experiment 2
        T_exp2 = [462.5 482.5 502.5 522.5 542.5 562.5 582.5 602.5] + 273.15; %Kelvin
        D_exp2 = 0.0254; %meters
        r_exp2 = 9 * 0.0254; %meters
        q_exp2 = [0.286 0.382 0.460 0.520 0.576 0.604 0.635 0.664] * (10^-4); %Watts
    %Experiment 3
        T_exp3 = 655 + 273.15; %Kelvin
        D_exp3 = [1 0.6 0.4 0.2 0.1 0.05] * 0.0254; %meters
        r_exp3 = 9 * 0.0254; %meters
        q_exp3 = [0.642 0.463 0.215 0.058 0.015 0.005] * (10^-4); %Watts

 
%Plot 1a 
    %Calculating parameters used in plotting
        q_theo1 = (sigma .* (T_exp1.^4) .* Ad .* (D_exp1.^2)) ./ ((D_exp1.^2) + 4.* (r_exp1.^2)); %watts
        q_theo2 = (sigma .* (T_exp2.^4) .* Ad .* (D_exp2.^2)) ./ ((D_exp2.^2) + 4.* (r_exp2.^2)); %watts
        q_theo3 = (sigma .* (T_exp3.^4) .* Ad .* (D_exp3.^2)) ./ ((D_exp3.^2) + 4.* (r_exp3.^2)); %watts
    %Plotting data
        figure
        plot(q_exp1 .* 10^6,q_theo1 .* 10^6, "bo")
        hold on
        plot(q_exp2 .* 10^6,q_theo2 .* 10^6, "rs")
        hold on
        plot(q_exp3 .* 10^6,q_theo3 .* 10^6, "gd")
    %Plotting 1:1 line
        x = linspace(0,70,100);
        y = x + 1;
        plot(x,y,"k")
    %Axis labels, legend, and title
        xlabel("Measured Heat Transfer [$\mu$W]","Interpreter","latex")
        ylabel("Theoretical Heat Transfer [$\mu$W]","Interpreter","latex")
        title("Measured Heat Transfer vs Theoretical Heat Transfer")
        legend("Experiment 1" ,"Experiment 2", "Experiment 3", "1:1 line","location", "southeast")

%Plot 1b
    %Plotting data
        figure
        plot(1./(r_exp1.^2), q_exp1 .* (10^6), "bo")
    %Linear Regression Fit
        hold on
        s = polyfit(1./(r_exp1.^2), q_exp1 .* (10^6),1);
        xlin = 1./(r_exp1.^2);
        ylin = s(1) .* xlin + s(2);
        plot(xlin, ylin, "k")
        for i = 1:length(ylin)
            Sr = Sr + ( q_exp1(i) * (10^6) - ylin(i)).^2;
            St = St + ( q_exp1(i) * (10^6) - mean(ylin))^2;
        end
        Rsquared = 1 - (Sr./St);
    %Axis labels, legend, and title
        xlabel("$\frac{1}{h^2}$ [$\frac{1}{m^2}$]","Interpreter","latex")
        ylabel("Measured Heat Transfer [$\mu$W]","Interpreter","latex")
        title("Experiment 1: Measured Heat Transfer vs Reciprocal of Squared Separation Distance")
        text(22,15, "R^2 = 0.9990")

%Plot 1c
    %Plotting data
        figure 
        plot(T_exp2 .^ 4, q_exp2 .* 10^6, "rs")
    %Linear Regression Fit
        hold on
        f = polyfit(T_exp2 .^ 4, q_exp2 .* 10^6,1);
        xlin = T_exp2 .^ 4;
        ylin = f(1) .* xlin + f(2);
        plot(xlin, ylin, "k")
        for i = 1:length(ylin)
            Sr = Sr + ( q_exp2(i) * (10^6) - ylin(i)).^2;
            St = St + ( q_exp2(i) * (10^6) - mean(ylin))^2;
        end
        Rsquared = 1 - (Sr./St);
    %Axis labels, legend, and title
        xlabel("Temperature^4 [Kelvin^4]" )
        ylabel("Measured Heat Transfer [$\mu$W]","Interpreter","latex")
        title("Experiment 2: Measured Heat Transfer vs Temperature^4")
        text(5*10^11,35, "R^2 = 0.9289")

%Plot 1d
    %Plotting Data 
        figure 
        plot(D_exp3.^2, q_exp3 .* 10^6,"gd")
    %Linear Regression Fit
        hold on
        z = polyfit(D_exp3.^2, q_exp3 .* 10^6,1);
        xlin = D_exp3.^2;
        ylin = z(1) .* xlin + z(2);
        plot(xlin, ylin, "k")
        for i = 1:length(ylin)
            Sr = Sr + ( q_exp3(i) * (10^6) - ylin(i)).^2;
            St = St + ( q_exp3(i) * (10^6) - mean(ylin))^2;
        end
        Rsquared = 1 - (Sr./St);
    %Axis labels, legend, and title
        xlabel("Diameter^2 [meters^2]" )
        ylabel("Measured Heat Transfer [$\mu$W]","Interpreter","latex")
        title("Experiment 3: Measured Heat Transfer vs Black Body Diameter^2")
        text(5*10^-4,10, "R^2 = 0.8941")

        close all
%Short answer questions
    epsilon1 = mean(abs(q_exp1 - q_theo1)./q_theo1 .* 100); 
    epsilon2 = mean(abs(q_exp2 - q_theo2)./q_theo2 .* 100); 
    epsilon3 = mean(abs(q_exp3 - q_theo3)./q_theo3 .* 100); 
    epsilonave = (epsilon1 + epsilon2 + epsilon3)/3

