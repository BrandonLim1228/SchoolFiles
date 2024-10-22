%----------------------------------------------------------------------
% TFES Lab (ME EN 4650)
%
% Computational Fluid Dynamics
%
% Brandon Lim
% 10/23/2024
%----------------------------------------------------------------------
clear, clc, close all

%Lab Data
    %Angle of attack 5 degrees
        CD5 = 0.017857103;
        CL5 = 0.49614851;
    %Angle of attack 12 degrees
        CD12 = 0.071687275;
        CL12 = 0.60869602;
%Coefficient of Drag Figure
    %Opening CD Figure
        figure1 = openfig("NACA0012_CD.fig");
    %Overlaying simulated data for angle of attack of 5 degrees
        hold on
            plot(5,CD5,"bx")
    %Overlaying Experimental data for angle of attack of 12 degrees
        hold on
            plot(12, CD12, "ro")
        hold off
%Coefficient of Lift Figure
    %Opening CL Figure
        figure2 = openfig("NACA0012_CL.fig");
    %Overlaying simulated data for angle of attack of 5 degrees
        hold on
            plot(5,CL5,"bx")
    %Overlaying Experimental data for angle of attack of 12 degrees
        hold on
            plot(12, CL12, "ro")