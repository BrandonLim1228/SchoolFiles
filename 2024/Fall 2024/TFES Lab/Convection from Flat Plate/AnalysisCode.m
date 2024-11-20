%--------------------------------------------------------------------------
% TFES Lab ME EN 4650
%
% Convection from a Flat Plate - Data Analysis
%
% Brandon Lim
% 11/20/24
%--------------------------------------------------------------------------
clear, clc, close all

%Experimental Parameters
    Pbaro = 87379.5; %Pasacals
    Tamb = 22.2; %Deg Celcius
    Tinf = 22.2; %Deg Celcius
    DynPress = 24.884;  %Pa
    Voltage = 40.03; %VAC
    Resistance = 157.1; %Ohms
    [rho,mu,k,Cp] = AirProperties(Tinf+273.15,Pbaro);
    Uinf = sqrt((2*DynPress)/rho);  % m/s
    kaSi = 77/1000; %m
    Lh = 153/1000; %m
    L = 230/1000; %m
    w = 68/1000; %m
    epsilon = 0.7;
    sigma = 5.67*10^-8; %stefan boltzmann constant W/m^2K^4

%Parsing Data
    ThermoCoupleNumber = linspace(1,16,16); %Thermocouple position number
    ThermoCoupleTemp = [30.8 33.6 34.4 35.8 38.2 37.6 37.9 39.6 39.3 39.7 40.0 39.8 40.9 40.0 40.6 41.0]; %Deg Celcius
    MeasuredTempTop = ThermoCoupleTemp([1:5,7:11,13:16]); %Measured temperatures on top of the plate in deg celcius
    x = [85 92 102 112 123 123 134 143 153 162 173 173 186 196 209 219]./1000; % Thermo couple location in m
    xtop = x([1:5,7:11,13:16]); %Thermo couple location in m on top of the plate in m

%Calculating experimental values
    q = Voltage^2/Resistance;
    q_flux = Voltage^2/(2*Resistance * Lh * w); %W/m^2
    h_local = q_flux./((MeasuredTempTop+273.15) - (Tinf+273.15)); %W/m^2K
    Lt = x(end)-x(1); %m
    h_ave = (1/Lt) * trapz(xtop,MeasuredTempTop); %W/mK
    for i = 1:length(MeasuredTempTop)
        Tf(i) = ((MeasuredTempTop(i)+273.15) + (Tinf+273.15))/2; %Calculating film temperature in K
        [~,~,kf(i),~] = AirProperties(Tf(i),Pbaro); %Calculating K from air properties function
        Nu_local(i) = h_local(i) .* xtop(i) ./ kf(i); %Calculating local nusselt number
    end
    kbar_f = mean(kf); %Calculating average k
    Nu_ave = h_ave * L / kbar_f; %Calculating average nusselt number


%Calculating data for plot 1a: Experimental and theoretical surface temperature in Kelvin versus non dimension x distance
    %Non-dimensional x
        x_prime = (xtop-kaSi)./Lh;
    %Calculating theoretical surface temperature
        %Calculating fluid properties using average film temperature
            Tf_ave = mean(Tf); %kelvin
            [rho,mu,k,Cp] = AirProperties(Tf_ave,Pbaro);
        %Calculating Reynolds number
            v = mu/rho; %Kinematic viscosity 
            Rex = (Uinf.* xtop)./v; %local Reynolds number
            ReL = (Uinf .* L)./v; %average reynold number
        %Calculating Prandtl Number
            alpha = k/(Cp * rho); %thermal diffusivity of air
            Pr = v/alpha; %Prandtl number
        %Calculating theoretical Nusselt number
            Nu_theo = (0.453 .* Rex.^(1/2) .* Pr.^(1/3))./((1-(kaSi./xtop).^(3/4)).^(1/3));
        %Calculating theoretical convection heat transfer coefficient
            hx_theo = (kbar_f./xtop).*Nu_theo; %Theoretical convection heat transfer coefficient Temperature
            hx_theo_ave = 2*(kbar_f/(L-kaSi)) * (0.453 * ReL ^ (1/2) * Pr ^ (1/3)) * (1-(kaSi/L)^(3/4))^(2/3); %Average theoretical convection heat transfer coefficient
            Nu_theo_ave = (hx_theo_ave * L)/kbar_f; %Average theoretical nusselt number  
        %Calculating theoretical surface temperature
            Ts_theo_conv = (Tinf+273.15) + q_flux./hx_theo; %Theoretical Surface Temperature
    %Calculating theoretical surface temperature accounting for radiation
        %Theoretical heat transfer coefficient
            q_flux_theo = hx_theo .* ((MeasuredTempTop + 273.15) - (Tinf+273.15));
            q_theo = (1/Lt) * (Lh *w) * trapz(xtop,q_flux_theo);
        %Thermal radiation 
            q_rad_flux = epsilon .* sigma .* ((MeasuredTempTop+273.15).^4 - (Tinf+273.15).^4);
        %Theoretical surface Temp
            Ts_theo_conv_rad = (Tinf + 273.15) + (q_flux - q_rad_flux)./hx_theo;
    %Plotting experimental values 
        figure
            %Experimental data
            plot(x_prime,MeasuredTempTop + 273.15, "bo")
            hold on
            plot(x_prime([5,10]),ThermoCoupleTemp([6,12]) + 273.15, "rs")
            %Theoretical data 
            hold on
            plot(x_prime,Ts_theo_conv, "k")
            hold on 
            plot(x_prime,Ts_theo_conv_rad,"--k")
            %Legend, axis labels, title
            title("Experimental & Theoretical Surface Temperatures vs Non-Dimensional Length")
            xlabel("x' = (x - $\xi$)/$L_h$","Interpreter","latex")
            ylabel("Temperature [Kelvin]")
            legend("Measured Temperature on Top Plate","Measured Temperature on Bottom Plate", "Convection Prediction Theoretical Temperature", "Radiation & Convection Theoretical Temperature","Location","southeast")
%Plot 1b: Local heat transfer coefficient versus non dimensional length x'
    figure 
        %Theoretical Data
        plot(x_prime,hx_theo, "k")
        hold on
        %Experimental Data
        plot(x_prime,h_local, "ko")
        %Legend, axis labels, title
        title("Experimental and Theoretical Heat Transfer Coefficient versus Non-Dimensional Length")
        xlabel("x' = (x - $\xi$)/$L_h$","Interpreter","latex")
        ylabel("Heat Transfer Coefficient $h_x$ [$\frac{W}{m^2K}$]", "Interpreter","latex")
        legend("Theoretical Heat Transfer Coefficient","Experimental Heat Transfer Coefficient")
%Plot 1c: Local Nusselt number versus non dimensional length x'
    figure
        %Theoretical data
        plot(x_prime,Nu_theo,"k")
        hold on 
        %Experimental data
        plot(x_prime,Nu_local,"ko")
        %Legend, axis labels, title
        title("Experimental and Theoretical Nusselt Number versus Non-Dimensional Length")
        xlabel("x' = (x - $\xi$)/$L_h$","Interpreter","latex")
        ylabel("Nusslet Number $Nu_x$", "Interpreter","latex")
        legend("Theoretical Nusselt Number","Experimental Nusselt Number", "Location","northwest")

        
%% Short Answer Calculations
error_nusselt = ((Nu_local - Nu_theo)./Nu_theo) .*100;
[minNu,maxNu] = bounds(error_nusselt)
error_hx = ((h_local - hx_theo)./hx_theo) .* 100;
[minHx,maxHx] = bounds(error_hx)
error_Ts = abs((((MeasuredTempTop+273.15) - Ts_theo_conv_rad)./Ts_theo_conv_rad) .* 100);
[minTs,maxTs] = bounds(error_Ts)

error_Ts2 = abs((((MeasuredTempTop+273.15) - Ts_theo_conv)./Ts_theo_conv) .* 100);
[minTs2,maxTs2] = bounds(error_Ts2)






