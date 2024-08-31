%----------------------------------------------------------------------
% TFES Lab (ME EN 4650)
%
% Water Cooling Tower - Data Analysis
%
% Required Plots:
% 1a. Water temperature and wet bulb air temperature vs height
% (indicate range and approach with dimension lines)
% 1b. Efficiency vs water inlet flow rate
% 1c. Specific and relative humidity vs height (and water inlet flow rate)
% 1d. Dry bulb temperatures vs height (and water inlet flow rate)
% 1e. Ratio of water outlet and inlet flow rates vs inlet water
% temperature
% 1f. Heat transfer rate to air and surroundings vs inlet water
% temperature
%
% Curve fit the makeup water flow rate to the inlet water temperature
%
% Brandon Lim
% 8/28/2024
%----------------------------------------------------------------------
clear, clc, close all

% Ambient temperature and barometric in the lab
Tamb = 21.5; %oC
Pbaro = 85.6; %kPa

% Parsed data from raw data sheet 
Mdot_wIn = [28 20 40];    %inlet water flow speed (kg/s)
T1 = [25 25.1 25.3];      %T1, air inlet temperature, dry bulb (oC)
T2 = [14.9 14.7 14.6];    %T2, air inlet temperature, wet bulb (oC)
T3 = [24.7 24.5 24.6];    %T3, air outlet temperature, dry bulb (oC)
T4 = [22.8 22.8 23];      %T4, air outlet temperature, wet bulb (oC)
T5 = [28 30.1 26.8];      %T5, water inlet temperature (oC)
T6 = [19.9 19.2 20.6];    %T6, water outlet temperature (oC)
t1 = [22.8 22.6 23.1];    %t1, air temperature at H, wet bulb (oC)
t2 = [22.7 22.4 23.2];    %t2, air temperature at H, dry bulb (oC)
t3 = [25.4 25.9 25.1];    %t3, water temperature at H (oC)
t4 = [21.3 21.3 22];      %t4, air temperature at G, wet bulb (oC)
t5 = [21 20.8 21.5];      %t5, air temperature at G, dry bulb (oC)
t6 = [23 22.9 23.3];      %t6, water temperature at G (oC)
t7 = [18.1 17.6 18.8];    %t7, air temperature at F, wet bulb (oC)
t8 = [19.8 19.5 20.3];    %t8, air temperature at F, dry bulb (oC)
t9 = [20.6 19.9 21.6];    %t9, water temperature at F(oC)
deltaP_out = 10;          %pressure drop at air outlet (mm H20)
L1 = [9 9 9];             %Initial height of makeup water tank (in)
L2 = [7.125 7.1 6.875];   %Finial height of makeup water tank (in)
t = [300 300 300];        %Time of experiment (s)

%Number of different inlet water flow rates
num_exp = 3;

%Wet and dry bulb air tempeperature arrays as a function of height for
%m_dot = 30 g/s
Twb = [T2(1) t7(1) t4(1) t1(1) T4(1)]; %Wet bulb temperature vector (oC)
Tw = [T6(1) t9(1) t6(1) t3(1) T5(1)]; %Water temperature vector (oC)
height = [0 24.8 48.3 71.8 100]./100; %Height markers for each temperature in (m)

%Plotting water and wet bulb temperature as a function of height
    figure
        plot(height, Tw,"s","MarkerFaceColor","r","MarkerEdgeColor","r");
    hold on
        plot(height,Twb,"s","MarkerFaceColor","b", "MarkerEdgeColor","b");

    %Adding Legend
    legend("Water","Wet Bulb","location","southeast")

    %Adding Titles and axis labels
    hold on
    title("Height vs Water and Wet Bulb Temperatures")
    ylabel("Temperature [Celcius]")
    xlabel("Height [Meters]")

    %Adding annotations for range and approach
    annotation("doublearrow",[0.05,0.05],[0.1,0.45])
    annotation("doublearrow",[0.05,0.05],[0.45,1])
%Calculating Range and Approach
R = T5(1) - T6(1);
A = T6(1) - T2(1);



