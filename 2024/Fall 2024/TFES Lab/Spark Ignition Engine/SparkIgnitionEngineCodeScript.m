%--------------------------------------------------------------------------
% TFES Lab ME EN 4650
%
% Spark Ignition Engine - Data Analysis
%
% Required Plots:
%   1a. Plot the measured crankshaft torque (τ ) versus crankshaft engine speed (ω)
%   1b. Plot the measured brake power (W˙b) and the total mechanical powe (W˙b + W˙f ) versus crankshaft engine speed (ω), compared to the net work (W˙net) of an ideal engine operating under the same conditions.
%   1c. Plot the measured thermal efficiency (ηth) and measured mechanical efficiency (ηmech) versus crankshaft engine speed (ω), compared to that of an ideal engine (ηOtto) operating under the same conditions. 
%   1d. Plot the work rate terms in the energy balance (kW) versus crankshaft engine speed (ω) for the data only. 
%   1e. Plot the mean effective pressure (MEP) versus crankshaft engine speed (ω).
%
% Brandon Lim
% 9/11/24
%--------------------------------------------------------------------------
clear, clc, close all

%Raw Data
    %System parameters 
        Tamb = 21.7; %oC
        Pamb = 86.3  * 1000; %Pa
        CompressionRatio = 7; %VBDC/VTDC
        Bore = 65.1/1000; %meters
        Stroke = 44.1/1000; %meters
        Timing = 20; %degrees to TDC
        Throttle = 100; %percent of fully open
    %Combustion Test: Engine Performance
        deltaT = [36.44	40.31	41.97	43.57	55.93]; %Time interval [s] 
        w = [3039	2746	2500	2250	2000]; %Crankshaft Speed [rpm]
        torque = [2.75	3.16	3.2	3.32	3.17]; %Torque [Nm]
        V_fuel = [10.2	10.2	10.2	10.2	10.2]./(10^6); %Fuel Consumption [m^3]
        airFLowRate = [125	120	121	116	109]; %L/min
        Tair = [20.7	20.7	20.8	20.9	20.9]; %oC
        Tfuel = [22.5	22.6	22.8	23	23.1]; %oC
        Texhaust = [522	510	493	470	458]; %oC
    %Dry-Run Test: Mechanical Losses
        wDry = [3000	2750	2505	2250	2000]; %Dry Run Crankshaft Speed [rpm]
        torqueDry = [2.01	1.93	1.9	1.88	1.78]; %Dry Run Torque [Nm]
    %Experiement constants
        Cv = 717; %Specific heat at constant volume [J/kgK]
        LHV = 44 * (10^6); %Lower Heating Value of the fuel [Joules]
        rhoFuel = 726; %Desnity of 91 Octane fuel in [kg/m^3]
        R = 287; %Universal Gas Constant for air [J/kgK]
        k = 1.4; %Ratio of specific heats
        nc = 2; %number of revolutions per power storke for a four stroke engine

% 1a. Plot the measured crankshaft torque (τ ) versus crankshaft engine speed (ω)
    %Plotting Data
        figure
            plot(w,torque, "ko");
    %Adding axis labels and plot title
        title("Crankshaft Engine Speed vs Torque")
        xlabel("Engine Speed [RPM]")
        ylabel("Torque [Nm]")

% 1b. Plot the measured brake power (W˙b) and the total mechanical powe (W˙b + W˙f ) versus crankshaft engine speed (ω), compared to the net work (W˙net) of an ideal engine operating under the same conditions.
    %Calculating parameters used in plotting for actual cycle
        Wb = torque.* (w .* ((2*pi)/60)); %Brake power [W]
        Wf = torqueDry .* (w .* ((2*pi)/60)); %Mechanical Loss [W]
        mechanicalPower = (Wb + Wf)/1000; %Total Mechanical Power [kW]
    %Caculating parameters used in plotting for an ideal cycle
        %Calculating heat transfer rate in
            VdotFuel = V_fuel ./ deltaT; %Calculating volumetric fuel flow rate [m^3/s]
            mDotFuel = rhoFuel .* VdotFuel; %Calculating mass flow rate of fuel [kg/s]
            Qin = mDotFuel .* LHV; %Calculating heat transfer rate in [W] 
        %Calculating heat transfer rate out
            VdotAir = airFLowRate ./ 1000 ./ 60; %Calculating volumetric flow rate of air [m^3/s]
            rhoAir = Pamb./(R.*(Tair+273.15)); %Calculating air density [kg/m^3]
            mDotAir = rhoAir .* VdotAir; %Calculating mass flow rate of air [kg/s]
            Qout = mDotAir .* (Cv.*((Texhaust+273.15) - (Tair+273.15))); %Calculating heat transfer rate out [W]
        % Calculating net work
            Wnet = (Qin - Qout)/1000; %[kW]
    %Plotting Data
        figure
            plot(w,Wb/1000, "bo") %speed [RPM] vs brake power [kW]
        hold on 
            plot(w,mechanicalPower,"rs") %speed [RPM] vs mechanical power [kW]
        hold on 
            plot(w,Wnet, "k") %speed [RPM] vs net ideal power [kW]
    %Adding axis labels and plot title
        title("Cranshaft Engine Speed vs Brake Power, Total Mechanical Power, and Ideal Net Power")
        xlabel("Crankshaft Speed [RPM]")
        ylabel("Power [kW]")
    %Adding Legend
        legend("Measured Brake Power: W^._b", "Total Mechanical Power: W^._b + W^._f", "Ideal Engine Net Power: W^._n_e_t","Location","eastoutside")

% 1c. Plot the measured thermal efficiency (ηth) and measured mechanical efficiency (ηmech) versus crankshaft engine speed (ω), compared to that of an ideal engine (ηOtto) operating under the same conditions. 
    % Calculating parameters used in plotting
        eta_mech = Wb./(Wb+Wf) .* 100; %Mechanical Efficiency
        eta_therm = Wb./Qin .* 100; %Thermal Efficiency
        %Thermal Efficiency of otto cycle
            r = CompressionRatio;
            eta_otto = (1 - (1/((r^k)-1))) .* 100; %Ideal efficiency of an otto cycle
    % Plotting data
        figure
            plot(w,eta_mech, "bo") %Plotting crankshaft engine speed vs mechanical efficiecny
        hold on
            plot(w,eta_therm, "rs") %Plotting crankshaft engine speed vs thermal efficiency
        hold on
            plot(w,ones(1,5).*eta_otto, "-r") %Plotting crankshaft engine speed vs ideal otto cycle efficiency
    %Adding axis labels and plot title
        title("Crankshaft Engine Speed vs Efficiency")
        xlabel("Cranshaft Egnine Speed [RPM]")
        ylabel("Efficiency [%]")
    %Adding legend
        legend("Mechanical Efficiency", "Thermal Efficiency","Otto Cycle Efficiency", "location", "eastoutside")

% 1d. Plot the work rate terms in the energy balance (kW) versus crankshaft engine speed (ω) for the data only.
    %Plotting data
        figure
            plot(w, Qin/1000, "bo") %speed vs heat ransfer rate in
        hold on
            plot(w, Wb/1000, "gd") %speed vs breaking power
        hold on
            plot(w,Wnet, "rs") %speed vs total power
        hold on
            plot(w,Wf/1000,"kx") %speed vs mechanical losses
    %Adding axis labels and plot title
        title("Crankshaft Engine Speed vs Energy Balance Terms")
        xlabel("Crankshaft Engine Speed [RPM]")
        ylabel("Power [kW]")
    %Adding legend
        legend("Power In: E^._i_n", "Breaking Power: W^._b", "Net Power: W^._n_e_t","Mechanical Power Loss: W^._f","location","eastoutside")

% 1e. Plot the mean effective pressure (MEP) versus crankshaft engine speed (ω).
    %Calculating parameters used in plotting
        Vd = (pi/4)*(Bore^2)*Stroke; %Displacement volume [m^3]
        MEP = ((torque.*2.*pi.*nc)./Vd)/1000; %Mean effective pressure [kPa]
    %Plotting Data
        figure
            plot(w,MEP,"ko")
    %Axis labels and plot title
        title("Crankshaft Speed vs Mean Effective Pressure")
        xlabel("Crankshaft Speed [RPM]")
        ylabel("Mean Effective Pressure [kPa]")
    %Adding estimated value of MEP at 2600 RPM from linear interpolation. Linear interpolation was done using plotting tools. 
        hold on 
            plot(2600,-0.03415 * 2600 +352.7, "k+")

