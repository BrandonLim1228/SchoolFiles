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
    DynPress = 0.1;  %inH2O
    Voltage = 40.03; %VAC
    Resistance = 157.1; %Ohms

    kaSi = 77; %mm
    Lh = 153; %mm
    L = 230; %mm
    w = 68; %mm

%Parsing Data
    ThermoCoupleNumber = linspace(1,16,16);
    ThermoCoupleTemp = [30.8 33.6 34.4 35.8 38.2 37.6 37.9 39.6 39.3 39.7 40.0 39.8 40.9 40.0 40.6 41.0]; %Deg Celcius
    MeasuredTempTop = ThermoCoupleTemp([1:5,7:11,13:16]);
    x = [85 92 102 112 123 123 134 143 153 162 173 173 186 196 209 219]; % Thermo couple location in mm
    xtop = x([1:5,7:11,13:16]);

%Calculating experimental values
    q_flux = Voltage^2/(2*Resistance * Lh * w); %W/mm^2
    h_local = q_flux./(MeasuredTempTop - Tinf); %W/mm^2K
    Lt = x(end)-x(1); %mm
    h_ave = (1/Lt) * trapz(xtop,MeasuredTempTop); %W/mmK I think
    for i = 1:length(MeasuredTempTop)
        Tf(i) = ((MeasuredTempTop(i)+273.15) + (Tinf+273.15))/2;
        [rho,mu,kf(i),Cp] = AirProperties(Tf(i),Pbaro);
        Nu_local(i) = h_local(i) .* xtop(i) ./ kf(i);
    end
    kbar_f = mean(kf);
    Nu_ave = h_ave * L / kbar_f;


%Calculating data for plot 1a: Experimental and theoretical surface
%temperature in Kelvin versus non dimension x distance
    %Non-dimensional x
        x_prime = (xtop-kaSi)./Lh;
    %Calculating theoretical surface temperature
        
        hx_theo = (kbar_f./x).*Nu_theo; %Theoretical Nusselt Temperature
        Ts_theo = Tinf + qs_flux./hx_theo; %Theoretical Surface Temperature
%     %Plotting experimental values 
%         figure
%             %Experimental data
%             plot(x_prime,MeasuredTempTop + 273.15, "bo")
%             hold on
%             plot(x_prime,ThermoCoupleTemp([6,12]) + 273.15, "rs")

        






