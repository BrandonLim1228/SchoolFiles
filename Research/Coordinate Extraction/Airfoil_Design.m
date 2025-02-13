%--------------------------------------------------------------------------
% Flow Physics and Control Lab
%
% Description: 
%    The following code is the delta wing airfoil final dimension
%    evaluation. I am computing the maximum angle of attack possible
%    for a wind tunnel blockage limit of 12%. The airfoil is assumed to be
%    pitching about the quarter cord. 
%
% Brandon Lim
% 2/12/2025
%--------------------------------------------------------------------------
clear, clc, close all, reset(groot)
format longg
%Wind Tunnel Cross Sectional Area
    AreaWT = 800 * 1000; %mm^2

%Reading in Normalized Airfoils
    airfoil1 = readmatrix("Yequ0_Airfoil_Official_Normalized.txt");
    airfoil2 = readmatrix("Yequ03s_Airfoil_Official_Normalized.txt");
    airfoil3 = readmatrix("Yequ06s_Airfoil_Official_Normalized.txt");

%Airfoil dimensions 
    rootChord = 400;
    qChord = rootChord/4;
    airfoil1 = airfoil1.*rootChord; airfoil2 = airfoil2.*rootChord; airfoil3 = airfoil3.*rootChord;
    
    span = 287/330*rootChord;
    wing_tipX = 308/330*rootChord;

    planformX = [0, wing_tipX, rootChord, wing_tipX, rootChord, wing_tipX, rootChord, wing_tipX, 0];
    planformY = [0, (1/2)*span, (1/2)*(2/3)*span, (1/2)*(1/3)*span, 0, -(1/2)*(1/3)*span, -(1/2)*(2/3)*span,-(1/2)*span,0];

%Calculating maximum angle of attack for 12% blockage
    AreaMaxDW = 0.12*AreaWT;
    alpha = linspace(0,15,15);
    heightP = qChord .* sind(alpha);
    heightN = -((rootChord - qChord) .*  sind(alpha));
    height = rootChord .*sind(90);
    area = (1/2) .* height .*span;

%Plotting Planform Area
figure
    plot(planformY, planformX,"linewidth", 1.5)
    hold on
    plot([0,rootChord*tand(25), -rootChord*tand(25),0],[0, rootChord, rootChord, 0], "linewidth", 1.5, "LineStyle","--")
    set(gca, "YDir", "reverse"); ylim([-5 405]); 
    xlabel("Y-Coordinate [mm]"); ylabel("X-Coordinate [mm]"); title("Planform Area");
    legend("True Planform", "Area Approximation")

%Plotting Wind Tunnel Cross Section
figure 
    plot([-500 500 500 -500 -500], [-400 -400 400 400 -400], "LineWidth", 1.5, "Color", "k")
    xlim([-530 530]); ylim([-430 430]);
    xlabel("y-coordinate [mm]"); ylabel("z-coordinate [mm]"); title("Experimental Sectional Area")
    hold on
    plot([0 200 -200 0], [qChord, -(rootChord-qChord), -(rootChord-qChord), qChord])
    text(-150,200,"12% Wind Tunnel Blockage  = 9600mm^2")
    text(-150,200,"Planform area with a root chord of 400mm is 69575")