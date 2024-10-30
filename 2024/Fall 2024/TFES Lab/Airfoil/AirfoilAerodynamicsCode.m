%--------------------------------------------------------------------------
% TFES Lab ME EN 4650
%
% Airfoil Aerodynamics - Data Analysis
%
% Brandon Lim
% 10/30/24
%--------------------------------------------------------------------------
clear, clc, close all

%Experimental parameters
    n = 120; %number of independent samples per test
    g = 9.81; % gravity in m/s
    c = 0.1016; % meters
    s = 0.3048; % meters
    Rec = 1.5 * (10^5);
    t = 0.012192; % meters
    Uinf = 25; %m/s
    Pdyn = 359.574; %Pa
    alpha = (0:16); %angle of attack in deg

%Experimental pressure readings
    %Distance along cord 
        xc = [0.05 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8]; 
    %angle of attack 5 deg
        AoA5TP = [-2.156 -1.525 -1.152 -0.950 -0.630 -0.491 -0.377 -0.244 -0.114] * 248.84; %Pascals
        AoA5BP = [0.763 0.213 -0.056 -0.144 -0.178 -0.193 -0.193 -0.171 -0.138] * 248.84; %Pascals
    %angle of attack 12 deg
        AoA12TP = [-1.105 -1.140 -1.004 -1.010 -0.977 -0.961 -0.901 -0.839 -0.763] * 248.84; %Pascals
        AoA12BP = [0.707 0.361 0.028 -0.113 -0.220 -0.297 -0.370 -0.414 -0.486] * 248.84; %Pascals
    
%Reading in baseline calibration data
    data = readmatrix("calibration.txt");
    L_base = mean(data(:,2));
    D_base = mean(data(:,3));

%Parsing data for all angles of attack
    for i = 1:17
        filename = ["AoA"+num2str(i-1)+".txt"];
        data = readmatrix(filename);
        %Finding Lift and Drag and accounting for calibration data
            L = (data(:,2)-L_base) .* g; %Lift in Newtons
            D = (data(:,3)-D_base) .* -g; %drag in newtons
        %Average vale of lift and drag for each angle of attack
            Lavg(i) = mean(L);
            Davg(i) = mean(D);
        %Standard error for lift and drag
            Lerr(i) = std(L)/sqrt(n);
            Derr(i) = std(D)/sqrt(n);
    end

%Calculating Lift and Drag with uncertainty
    for i = 1:length(Lavg)
        CL(i) = Lavg(i)/(Pdyn * c * s);
        CD(i) = Davg(i)/(Pdyn * c * s);

        CL_err(i) = Lerr(i)/(Pdyn * c * s);
        CD_err(i) = Derr(i)/(Pdyn * c * s);
    end


%% Plot 1a: CL vs angle of attack
    %Plotting figure
        figure1 = openfig("NACA0012_CL.fig");
        legend("AutoUpdate","off")
    %Figure limits
        xlim([0 20])
        ylim([0 1.4])
    %Plotting data with error bars
        hold on
            plot(alpha,CL,"--ks")
            errorbar(alpha,CL,CL_err,"k")
            text(1,1,"Re_c = 1.5*10^5")
        hold off
%% Plot 1b: CD vs angle of attack
    %Plotting figure
        figure2 = openfig("NACA0012_CD.fig");
        legend("AutoUpdate","off")
    %figure limits
        xlim([0 20])
        ylim([0 0.3])
    %Plotting data with error bars
        hold on
            plot(alpha,CD,"--ks")
            errorbar(alpha,CD,CD_err,"k")
            text(1,0.2,"Re_c = 1.5*10^5")
        hold off
%% Plot 1c: Cp vs distance on cord length
    %Calculating coefficient of pressure for angle of attack 5 degrees
        CP5Top = AoA5TP/Pdyn;
        CP5Bot = AoA5BP/Pdyn;
    %Calculating coefficient of pressure for anlge of attack 12 degreese
        CP12Top = AoA12TP/Pdyn;
        CP12Bot = AoA12BP/Pdyn;
    %Plotting 
        %Plotting figure for AoA 5 degrees
        figure
            subplot(1,2,1) 
                plot(xc,CP5Top, "bo")
            hold on
                plot(xc,CP5Bot,"rs")
            %Setting axis labels and title
                title("Angle of Attack of $5^o$", "Interpreter","latex")
                xlabel("")
                ylabel("Coefficient of Pressure $C_P$","Interpreter","latex")
            %Adding legend
                legend("Upper Surface","Bottom Surface")
        %Plotting figure for AoA 12 degrees
            subplot(1,2,2)
                plot(xc,CP12Top,"bo")
            hold on
                plot(xc,CP12Bot,"rs")
            %Setting axis labels and title
                title("Angle of Attack of $12^o$", "Interpreter","latex")
                xlabel("")
                ylabel("Coefficient of Pressure $C_P$","Interpreter","latex")
            %Adding legend
                legend("Upper Surface","Bottom Surface")
        %figure title
            sgtitle("Pressure Coefficient vs Distance along Chord for Re_c = 1.5 x 10^5")
