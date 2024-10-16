%--------------------------------------------------------------------------
% TFES Lab ME EN 4650
%
% Refrigeration - Data Analysis
%
% Brandon Lim
% 10/16/24
%--------------------------------------------------------------------------
clear, clc, close all


% Acquiring python interpreter for Coolprop usage
   % load the CoolProp package into Matlab
        import py.CoolProp.CoolProp.PropsSI
    % set reference state to match that in provided P-h diagram
        py.CoolProp.CoolProp.set_reference_state("R134a","IIR")

% Parsing Data from data sheet
    Tamb = 23.5 + 273.15; %K
    Pamb = 86.85; %kPa
    Wfan = 130; %W

    V_dot = [0.2 0.15 0.1 0.07] /60/264.17; %m^3/s
    totalPower = [840 680 570 515]; %W

    %Refrigerant State Points
    T1 = ([62 63 69 70] - 32) * (5/9) + 273.15; %K
    T2 = ([120 140 135 132] - 32) * (5/9) + 273.15; %K
    T3 = ([98 82 72 75] - 32) * (5/9) + 273.15; %K
    T4 = ([39 24 2 -5] - 32) * (5/9) + 273.15; %K
    T5 = ([62 68 70 70] - 32) * (5/9) + 273.15; %K

    P1 = [31 20 10 5] * 6.895 + Pamb; %kPa absolute
    P2 = [147 135 136 108] * 6.895 + Pamb; %kPa absolute
    P3 = [148 135 114 105] * 6.895 + Pamb; %kPa absolute
    P4 = [40 27 13 8] * 6.895 + Pamb; %kPa absolute
    P5 = [35 23 12 9] * 6.895 + Pamb; %kPa absolute

    %Air Temperatures
    Tc1 = [35.3 32.8 29.5 28.2] + 273.15; %K
    Tc2 = [34.3 29.7 25.7 25] + 273.15; %K
    Te1 = [15.7 11.7 11.7 12.2] + 273.15; %K
    Te2 = [18.9 22.5 23 23] + 273.15; %K

%Finding necessary values for analysis 
    %Determining densitiy and enthalpy from CoolProp
    for i = 1:length(T1)
        %Enthalpy J/kg
            h1(i) = PropsSI("H","T",T1(i),"P",P1(i) * 1000,"R134a");
            h2(i) = PropsSI("H","T",T2(i),"P",P2(i) * 1000,"R134a");
            h3(i) = PropsSI("H","T",T3(i),"P",P3(i) * 1000,"R134a");
            h4(i) = h3(i); %adiabatic
            h5(i) = PropsSI("H","T",T5(i),"P",P5(i) * 1000,"R134a");
        %Density kg/m^3
            rho1(i) = PropsSI("D","T",T1(i),"P",P1(i) * 1000,"R134a");
            rho2(i) = PropsSI("D","T",T2(i),"P",P2(i) * 1000,"R134a");
            rho3(i) = PropsSI("D","T",T3(i),"P",P3(i) * 1000,"R134a");
            rho4(i) = PropsSI("D","T",T4(i),"P",P4(i) * 1000,"R134a");
            rho5(i) = PropsSI("D","T",T5(i),"P",P5(i) * 1000,"R134a");
        %Enthalpy  J/KgK
            s1(i) = PropsSI("S","T",T1(i),"P",P1(i) * 1000,"R134a");
            s2(i) = s1(i); %Isentroptic in an ideal cycle
    end
    
%Determining mass flow rate from where state variables of where the rotameter is located
    m_dot = rho3 .* V_dot; %Kg/s

%Plot 1a: Temperatures vs mass flow rate 
    %Calculating necessary parameters for plotting
        %Calculating average air temperature at condensor and evaporator outlets
            for i = 1:length(Tc1)
                Tc_bar(i) = 1/2 * (Tc1(i)+Tc2(i));
                Te_bar(i) = 1/2 * (Te1(i)+Te2(i));
            end
    %Plotting figure
        figure 
            plot(m_dot,T3 - 273.15,"bo")
        hold on
            plot(m_dot,T4 - 273.15,"rs")
        hold on
            plot(m_dot,Tc_bar - 273.15,"bo","MarkerFaceColor","b")
        hold on
            plot(m_dot,Te_bar - 273.15,"rs","MarkerFaceColor","r")
        hold on
            plot(m_dot,Tamb - 273.15 .*ones(length(T3)), "--k")
    % Adding axis labels, plot title, and legend
        title("Temperature vs Mass Flow Rate")
        ylabel("Temperature [$^\circ$C]" , "Interpreter","latex")
        xlabel("Refrigerant Mass Flow Rate [$\frac{kg}{s}$]","Interpreter","latex")
        legend("Refrigerant Temperature at Condensor Outlet & Expansion Valve Inlet", "Refrigerant Temperature at Expansion Valvue Outlet & Evaporator Inlet", "$\overline{T}_c$", "$\overline{T}_e$", "$T_{amb}$", "Interpreter","Latex","location","eastoutside");

%Plot 1b: Spcific engergy terms vs mass flow rate
    %Calculating necessary parameters for plotting 
        %Calculating Heat per unit mass rejected from the regrigerant in the condensor
            qH = -(h3 - h2); %J/kg
        %Calculating heat per unit mass transfered to the refrigerant in the evaporator 
            qL = h1 - h4; %J/kg
        %Calculating heat loss to the surroundings
            %Calculating power to the compressor 
                WdotC = totalPower - Wfan; %W
                %Calculating power in
                    WDotIn = 0.78*WdotC; %W
                    %Calculating work in
                        Win = WDotIn/m_dot; %J/kg
                        %Calculating Heat Loss to surroundings
                            qLoss = Win + h1 - h2; %J/kg
    %Plotting figure
        figure
            plot(m_dot,qL/1000, "bo")
        hold on 
            plot(m_dot,qH/1000, "rs")
        hold on
            plot(m_dot,qLoss/1000,"gx")
        hold on 
            plot(m_dot,Win/1000, "kd")
    %Adding axes labels, plot title, and legend
        title("Specific Energy Terms vs Refrigerent Mass Flow Rate")
        xlabel("Refrigerant Mass Flow Rate [$\frac{kg}{s}$]","Interpreter","latex")
        ylabel("Specific Energy [$\frac{kJ}{kg}$]","Interpreter","latex")
        legend("$q_L$", "$q_H$", "$q_{Loss}$", "$W_{in}$", "Interpreter", "Latex")


%Plot 1c: Coefficient of performance vs mass flow rate
    %Calculating parameter used in plotting
        COPr = qL/Win;
    %Plotting figure 
        figure
            plot(m_dot,COPr, "kx")
    %Adding axis labels, and plot title
        title("$COP_r$ vs Refrigerent Mass Flow Rate","Interpreter","Latex")
        ylabel("$COP_r$","Interpreter","latex")
        xlabel("Refrigerant Mass Flow Rate [$\frac{kg}{s}$]","Interpreter","latex")

%Plot 1d: Isentropic efficiency of the compressor and total electrical power supplied versus mass flow rate
    %Calculating parameters used in plotting 
        %Calculating h2s from cool prop
            for i = 1:length(T2)
                h2s(i) = PropsSI("H","T",T2(i),"S",s2(i),"R134a");
            end
        %Calculating isentropic efficiency of compressor 
            etaC = (h2s - h1)/(Win) * 100;
    %Plotting figure 
        %Plotting Left y axis data
            figure 
                yyaxis left
                plot(m_dot,etaC,"hexagram")
                ylabel("$\eta_c$", "Interpreter","latex")
            hold on
                yyaxis right
                plot(m_dot,totalPower, "s")
                ylabel("$\dot{W}_{total}$","interpreter","latex")
    %Adding axis labels, and titles
        title("Total Power and Isentropic Efficiency vs Refrigerant Mass Flow Rate")
        xlabel("Refrigerant Mass Flow Rate [$\frac{kg}{s}$]","Interpreter","latex")

%Plot 1e: actual cycle process on P-h diagram
    %Acquiring data
        P = [P1(1), P2(1),P3(1),P4(1),P5(1)]./1000;
        h = [h1(1), h2(1),h3(1),h4(1),h5(1)]./1000;

    %Opening figure of P-h diagram 
        openfig("Ph_Diagram_R134a.fig");
    %Plotting state points
        hold on
            plot([h,h(1)],[P,P(1)], "-ro")
    %Adding annotations for states 
        text(415,0.25,"1","color","r","FontSize",20)
        text(398,0.42,"5","color","r","FontSize",20)
        text(430,1.4,"2","color","r","FontSize",20)
        text(240,1.4,"3","color","r","FontSize",20)
        text(240,0.25,"4","color","r","FontSize",20)
    %Adding annotations for physical state descriptions
        text(405,0.15,"Super-heated vapor","color","r","FontSize",20,"BackgroundColor",[1 1 1])
        text(430,0.6,"Non-isentropic","color","r","FontSize",20,"BackgroundColor",[1 1 1])
        text(170,1.8,"Subcooled liquid","color","r","FontSize",20,"BackgroundColor",[1 1 1])
        text(225,0.6,"h3 = h4","color","r","FontSize",20,"BackgroundColor",[1 1 1])