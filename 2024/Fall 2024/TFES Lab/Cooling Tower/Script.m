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
Patm = 114.124; %kPa
% Energy put into the system in lab
Qdot_in = 1.6; %kW

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

%Plotting water and wet bulb temperature as a function of height (Plot 1a)
    %creating data vectors for m_dot = 28 g/s
      Twb = [T2(1) t7(1) t4(1) t1(1) T4(1)]; %Wet bulb temperature vector (oC)
      Tw = [T6(1) t9(1) t6(1) t3(1) T5(1)]; %Water temperature vector (oC)
      height = [0 24.8 48.3 71.8 100]./100; %Height markers for each temperature in (m)
    %Plotting Data
      figure
        plot(height, Tw,"s","MarkerFaceColor","r","MarkerEdgeColor","r");
      hold on
        plot(height,Twb,"s","MarkerFaceColor","b", "MarkerEdgeColor","b");
    %Adding Legend
      legend("Water","Wet Bulb","location","southeast")
    %Adding Titles and axis labels
      title("Height vs Water and Wet Bulb Temperatures")
      ylabel("Temperature [Celcius]")
       xlabel("Height [Meters]")
    %Adding annotations for range and approach
        %Approach
            %Water temperature out boundary line
              annotation("line",[0.001 0.1],[0.45,0.45])
              annotation("textbox",[0.001,0.001 0.48,0.48], "string", "Tw_o_u_t = 19.9^oC", "EdgeColor","none"); 
            %Inlet wet bulb temperature boundary line
              annotation("line",[0.001 0.1],[0.163,0.163])
              annotation("textbox",[0.001,0.001 0.193,0.193], "string", "Twb_i_n = 14.9^oC", "EdgeColor","none");             
            %Approach Double arrow
              annotation("doublearrow",[0.07,0.07],[0.163,0.45])
              annotation("textbox",[0.058,0.058 0.27,0.27], "string", "A", "EdgeColor","none"); 
        %Range
            %Water inlet temperature boundary line
              annotation("line",[0.001 0.1],[0.92, 0.92])
              annotation("textbox",[0.001,0.001 0.95,0.95], "string", "Tw_i_n = 28^oC", "EdgeColor","none");             
            %Range Double arrow
              annotation("doublearrow",[0.07,0.07],[0.45,0.92])
              annotation("textbox",[0.058,0.058 0.63,0.63], "string", "R", "EdgeColor","none");

%Plotting cooling tower efficiency in terms of a percentage on the y-axis
%as a function of water inlet flow rate in units of g/s on the x-axis (1b)
    %Calculating Data needed 
        %Calculating Range and Approach for each flow rate measured in lab
            %28 gm/s
                R1 = T5(1) - T6(1);
                A1 = T6(1) - T2(1);
            %20 gm/s
                R2 = T5(2) - T6(2);
                A2 = T6(2) - T2(2);
            %40 gm/s
                R3 = T5(3) - T6(3);
                A3 = T6(3) - T2(3);
        %Calculating efficiency of the cooling tower for each flow rate
        %measured in lab
            %28 gm/s
                eta1 = R1/(R1+A1) * 100;
            %20 gm/s
                eta2 = R2/(R2+A2) * 100;
            %40 gm/s
                eta3 = R3/(R3+A3) * 100;
    %Plotting Data
        figure
            plot(Mdot_wIn, [eta1, eta2, eta3],"s","MarkerFaceColor","k","MarkerEdgeColor","k")
    %Adding axis labels and plot title
    title("Water Inlet Flow Rate vs Cooling Tower Efficiency")
    xlabel("Water Inlet Flow Rate [gm/s]")
    ylabel("Cooling Tower Efficiency [%]")

%Plotting specific humidity as a function of cooling tower height (1c)
    %Creating vectors used in analysis
        %Creating Web Bulb Temperature vectors
            Twb1 = [T2(1) t7(1) t4(1) t1(1) T4(1)]; %Wet bulb temperature vector for 28 gm/s (oC)
            Twb2 = [T2(2) t7(2) t4(2) t1(2) T4(2)]; %Wet bulb temperature vector for 20 gm/s (oC)
            Twb3 = [T2(3) t7(3) t4(3) t1(3) T4(3)]; %Wet bulb temperature vector for 40 gm/s (oC)
                Twb = [Twb1, Twb2, Twb3];
        %Creating Dry Bulb Temperature vectors
            Tdb1 = [T1(1) t8(1) t5(1) t2(1) T3(1)]; %Dry bulb temperature vector for 28 gm/s (oc)
            Tdb2 = [T1(2) t8(2) t5(2) t2(2) T3(2)]; %Dry bulb temperature vector for 28 gm/s (oc)
            Tdb3 = [T1(3) t8(3) t5(3) t2(3) T3(3)]; %Dry bulb temperature vector for 28 gm/s (oc)
                Tdb = [Tdb1, Tdb2, Tdb3];
        %Creating Water Temperature vectors
            Tw1 = [T6(1) t9(1) t6(1) t3(1) T5(1)]; %Water temperature vector for 28 gm/s (oC)
            Tw2 = [T6(2) t9(2) t6(2) t3(2) T5(2)]; %Water temperature vector for 20 gm/s (oC)
            Tw3 = [T6(3) t9(3) t6(3) t3(3) T5(3)]; %Water temperature vector for 40 gm/s (oC)
                Tw = [Tw1, Tw2, Tw3];
    %Using the Psychometric Function to find specific humidity, phi, h, and v 
        for i = 1:length(Tdb)
         [Tdb(i),w(i),phi(i),h(i),Tdp(i),v(i),Twb(i)] = Psychrometrics ('tdb',Tdb(i),'twb',Twb(i),'p',Patm);
        end
    %Parsing specific humidity vector into respected experiment specific humidity vectors
        omega1 = w(1:5);
        omega2 = w(6:10);
        omega3 = w(11:end);
    %Plotting Data
        figure
            plot(height,omega1,"ob")
        hold on
            plot(height, omega2, "dg")
        hold on
            plot(height,omega3,"sr")
    %adding legend 
        legend("Mdot_w_,_i_n = 28 gm/s", "Mdot_w_,_i_n = 20 gm/s", "Mdot_w_,_i_n = 40 gm/s","location","southeast")
    %Adding axis label and plot title
        title("Height of Cooling Tower vs Specific Humidity")
        xlabel("Height of Tower [meters]")
        ylabel("Specific Humidity [kg_w_a_t_e_r_ _v_a_p_o_r/kg_d_r_y_ _a_i_r]")

%Plotting dry bulb air temperature as a function of cooling tower height
%(1d)
    %Plotting Data
        figure 
            plot(height, Tdb1, "ob")
        hold on
            plot(height, Tdb2, "dg")
        hold on
            plot(height, Tdb3, "sr")
    %adding legend
        legend("Mdot_w_,_i_n 28 gm/s", "Mdot_w_,_i_n = 20 gm/s", "Mdot_w_,_i_n = 40 gm/s","location","southeast")
    %adding axis label and plot title
        title("Height of Cooling Tower vs Dry Bulb Air Temperature")
        xlabel("Height of Tower [Meters]")
        ylabel("Dry Bulb Air Temperature [^oC]")

%Plotting the ratio of the water outlet mass flow rate to water inlet mass
%flow rate as a function of inlet water temperature (1e)
    %Calculating parameters needed to find ratio of outlet to inlet flow
    %rates of water
        %Calculating mass flow rate of air
            Mdot_air = 0.0137 *sqrt(deltaP_out/((1+w(5))*v(5)));
        %Calculating mass flow rate of vapor into the system for each experiement
            Mdot_vin1 = Mdot_air * w(5);
            Mdot_vin2 = Mdot_air * w(10);
            Mdot_vin3 = Mdot_air * w(15);
        %Calculating mass flow rate of vapor out of the system for each experiment
            Mdot_vout1 = Mdot_air * w(1);
            Mdot_vout2 = Mdot_air * w(6);
            Mdot_vout3 = Mdot_air * w(11);
        %Calculating total mass flow rate of water out of the system for each experiment
            Mdot_wOut1 = Mdot_wIn(1) + Mdot_vin1 - Mdot_vout1;
            Mdot_wOut2 = Mdot_wIn(2) + Mdot_vin2 - Mdot_vout2;
            Mdot_wOut3 = Mdot_wIn(3) + Mdot_vin3 - Mdot_vout3;
    %Plotting data
        figure
            plot(T5(1) ,Mdot_wOut1/Mdot_wIn(1), "bo")
        hold on 
            plot(T5(2) ,Mdot_wOut2/Mdot_wIn(2), "go")
        hold on
            plot(T5(3) ,Mdot_wOut3/Mdot_wIn(3), "ro")
    %Adding legend
        legend("Mdot_w_,_i_n = 28 gm/s", "Mdot_w_,_i_n = 20 gm/s", "Mdot_w_,_i_n = 40 gm/s","location","southeast")
    %Adding title and axis labels
        title("Inlet Water Temperature vs Ratio of Outlet Water Mass Flow Rate to Inlet Water Mass Flow Rate")
        xlabel("Inlet Water Temperature [^oC]")
        ylabel("Mdot_w_,_o_u_t/Mdot_w_,_i_n")
       
%Plot the heat transfer rates in units of kW on the y-axis as a inlet water
%temperature on the x-axis
    %Calculating values needed to find heat transfer rates
        for i = 1:num_exp
            [Tdb,w,phi,h_in(i),Tdp,v,Twb] = Psychrometrics ('tdb',T1(i),'twb',T2(i),'p',Patm); %Using psychometric function to find inlet enthalpy of air
            [Tdb,w,phi,h_out(i),Tdp,v,Twb] = Psychrometrics ('tdb',T3(i),'twb',T4(i),'p',Patm); %Using psychometric function to find outlet enthalpy of air
            Qdot_a(i) = Mdot_air*(h_out(i)-h_in(i)); %Calculating heat gain by air for each experiment
            Qdot_amb(i) = Qdot_in + Mdot_air*(h_in(i) - h_out(i)); %Calculating heat lost to surroundings 
        end
    %Plotting Data
        figure
            plot(T5, Qdot_a, "rd")
        hold on
            plot(T5, Qdot_amb, "ks")
    %Adding Legend
        legend("Qdot_a","Qdot_a_m_b","location","east")
    %Adding axis labels & titles
        title("Inlet Water Temperature vs Heat Transfer Rates")
        xlabel("Inlet Water Temperature [^oC]")
        ylabel("Heat Transfer Rate [kW]")
        