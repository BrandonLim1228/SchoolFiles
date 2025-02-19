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

%Design Parameters
    LE_percentage = 0.05;
%Wind Tunnel Cross Sectional Area
    AreaWT = 800 * 1000; %mm^2

%Reading in Normalized Airfoils
    airfoil1 = readmatrix("Yequ0_Airfoil_Official_Normalized.txt");
    airfoil2 = readmatrix("Yequ03s_Airfoil_Official_Normalized.txt");
    airfoil3 = readmatrix("Yequ06s_Airfoil_Official_Normalized.txt");

%Airfoil dimensions 
    rootChord = 400:25:500; %mm
    
    af1_RC400 = airfoil1 .* rootChord(1); af2_RC400 = airfoil2 .* rootChord(1); af3_RC400 = airfoil3 .* rootChord(1);
    af1_RC425 = airfoil1 .* rootChord(2); af2_RC425 = airfoil2 .* rootChord(2); af3_RC425 = airfoil3 .* rootChord(2);
    af1_RC450 = airfoil1 .* rootChord(3); af2_RC450 = airfoil2 .* rootChord(3); af3_RC450 = airfoil3 .* rootChord(3);
    af1_RC475 = airfoil1 .* rootChord(4); af2_RC475 = airfoil2 .* rootChord(4); af3_RC475 = airfoil3 .* rootChord(4);
    af1_RC500 = airfoil1 .* rootChord(5); af2_RC500 = airfoil2 .* rootChord(5); af3_RC500 = airfoil3 .* rootChord(5);

%Calculating root airfoil thickness
    for i = 1:((length(af1_RC400)-1)/2)
        thickness_400(i) = abs(af1_RC400(i,3))+abs(af1_RC400(((length(af1_RC400)+1)-i),3));
        thickness_425(i) = abs(af1_RC425(i,3))+abs(af1_RC425(((length(af1_RC400)+1)-i),3));
        thickness_450(i) = abs(af1_RC450(i,3))+abs(af1_RC450(((length(af1_RC400)+1)-i),3));
        thickness_475(i) = abs(af1_RC475(i,3))+abs(af1_RC475(((length(af1_RC400)+1)-i),3));
        thickness_500(i) = abs(af1_RC500(i,3))+abs(af1_RC500(((length(af1_RC400)+1)-i),3));
    end

    %Finding max thickness
    thickness_max400 = max(thickness_400);
    thickness_max425 = max(thickness_425);
    thickness_max450 = max(thickness_450);
    thickness_max475 = max(thickness_475);
    thickness_max500 = max(thickness_500);
    maxIndex = find(thickness_400 == thickness_max400); %Same for all root chord lengths
    %corresponding x to max thickness
    correspondingX400 = af1_RC400(maxIndex,1);
    correspondingX425 = af1_RC425(maxIndex,1);
    correspondingX450 = af1_RC450(maxIndex,1);
    correspondingX475 = af1_RC475(maxIndex,1);
    correspondingX500 = af1_RC500(maxIndex,1);

%Plotting max thickness
figure
    subplot(5,1,1)
    plot(af1_RC400(:,1),af1_RC400(:,3), "lineWidth", 1.5)
    hold on
    plot([correspondingX400,correspondingX400], [af1_RC400(maxIndex,3),af1_RC400(250-maxIndex,3)], "lineWidth", 1.5, "color","r")
    hold on
    plot(rootChord(1)/4, 0, "rx"); hold on; plot(rootChord(1)/4, 0, "ro"); %quarter chord
    hold on
    plot([0 rootChord(1)], [0,0], "linewidth",1.5,"linestyle","--", "color","k")
    daspect([1,1,1])
    text(correspondingX400+5,10, "Max Thickness = " + num2str(thickness_max400));
    xlim([-10 510]); ylim([-35 40])
    legend("Root Airfoil","","Quarter Chord","", "Root Chord = 400mm","location", "eastoutside")

    subplot(5,1,2)
    plot(af1_RC425(:,1),af1_RC425(:,3), "lineWidth", 1.5)
    hold on
    plot([correspondingX425,correspondingX425], [af1_RC425(maxIndex,3),af1_RC425(250-maxIndex,3)], "lineWidth", 1.5, "color","r")
    hold on
    plot(rootChord(2)/4, 0, "rx"); hold on; plot(rootChord(2)/4, 0, "ro"); %quarter chord
    plot([0 rootChord(2)], [0,0], "linewidth",1.5,"linestyle","--", "color","k")
    daspect([1,1,1])
    text(correspondingX425+5,10, "Max Thickness = " + num2str(thickness_max425));
    xlim([-10 510]); ylim([-35 40])
    legend("Root Airfoil","","Quarter Chord","", "Root Chord = 425mm","location", "eastoutside")

    subplot(5,1,3)
    plot(af1_RC450(:,1),af1_RC450(:,3), "lineWidth", 1.5)
    hold on
    plot([correspondingX450,correspondingX450], [af1_RC450(maxIndex,3),af1_RC450(250-maxIndex,3)], "lineWidth", 1.5, "color","r")
    hold on
    plot(rootChord(3)/4, 0, "rx"); hold on; plot(rootChord(3)/4, 0, "ro"); %quarter chord
    hold on
    plot([0 rootChord(3)], [0,0], "linewidth",1.5,"linestyle","--", "color","k")
    daspect([1,1,1])
    text(correspondingX450+5,10, "Max Thickness = " + num2str(thickness_max450));
    xlim([-10 510]); ylim([-35 40])
    legend("Root Airfoil","","Quarter Chord","", "Root Chord = 450mm","location", "eastoutside")

    subplot(5,1,4)
    plot(af1_RC475(:,1),af1_RC475(:,3), "lineWidth", 1.5)
    hold on
    plot([correspondingX475,correspondingX475], [af1_RC475(maxIndex,3),af1_RC475(250-maxIndex,3)], "lineWidth", 1.5, "color","r")
    hold on
    plot(rootChord(4)/4, 0, "rx"); hold on; plot(rootChord(4)/4, 0, "ro"); %quarter chord
    hold on
    plot([0 rootChord(4)], [0,0], "linewidth",1.5,"linestyle","--", "color","k")
    daspect([1,1,1])
    text(correspondingX475+5,10, "Max Thickness = " + num2str(thickness_max475));
    xlim([-10 510]); ylim([-35 40])
    legend("Root Airfoil","","Quarter Chord","", "Root Chord = 475mm","location", "eastoutside")
    
    subplot(5,1,5)
    plot(af1_RC500(:,1),af1_RC500(:,3), "lineWidth", 1.5)
    hold on
    plot([correspondingX500,correspondingX500], [af1_RC500(maxIndex,3),af1_RC500(250-maxIndex,3)], "lineWidth", 1.5, "color","r")
    hold on
    plot(rootChord(5)/4, 0, "rx"); hold on; plot(rootChord(5)/4, 0, "ro"); %quarter chord
    hold on
    plot([0 rootChord(5)], [0,0], "linewidth",1.5,"linestyle","--", "color","k")
    daspect([1,1,1])
    text(correspondingX500+5,10, "Max Thickness = " + num2str(thickness_max500));
    xlim([-10 510]); ylim([-35 40])
    legend("Root Airfoil","","Quarter Chord","", "Root Chord = 500mm","location", "eastoutside")
    
%LE 5% cut thickness calculation
    af1X_5per = rootChord .* LE_percentage;
    %Root Chord = 400
    af1Y1_5per_400 = ((af1X_5per(1) - af1_RC400(119,1))/(af1_RC400(118,1)-af1_RC400(119,1))) * (af1_RC400(118,3)-af1_RC400(119,3)) + af1_RC400(119,3);
    af1Y2_5per_400 = ((af1X_5per(1) - af1_RC400(131,1))/(af1_RC400(132,1)-af1_RC400(131,1))) * (af1_RC400(132,3)-af1_RC400(131,3)) + af1_RC400(131,3);
    af2X_5per_400 = af2_RC400(125,1)+af1X_5per(1);
    af2Y1_5per_400 = (((af2_RC400(125,1)+af1X_5per(1)) - af2_RC400(114,1))/(af2_RC400(113,1)-af2_RC400(114,1))) * (af2_RC400(113,3)-af2_RC400(114,3)) + af2_RC400(114,3);
    af2Y2_5per_400 = (((af2_RC400(125,1)+af1X_5per(1)) - af2_RC400(136,1))/(af2_RC400(137,1)-af2_RC400(136,1))) * (af2_RC400(137,3)-af2_RC400(136,3)) + af2_RC400(136,3);
    af3X_5per_400 = af3_RC400(125,1)+af1X_5per(1);
    af3Y1_5per_400 = (((af3_RC400(125,1)+af1X_5per(1)) - af3_RC400(107,1))/(af3_RC400(106,1)-af3_RC400(107,1))) * (af3_RC400(106,3)-af3_RC400(107,3)) + af3_RC400(107,3);
    af3Y2_5per_400 = (((af3_RC400(125,1)+af1X_5per(1)) - af3_RC400(138,1))/(af3_RC400(139,1)-af3_RC400(138,1))) * (af3_RC400(139,3)-af3_RC400(138,3)) + af3_RC400(138,3);
    
    t400x = [af1X_5per(1) af2X_5per_400 af3X_5per_400 af3X_5per_400 af2X_5per_400 af1X_5per(1) af1X_5per(1)];
    t400y = [af1Y1_5per_400 af2Y1_5per_400 af3Y1_5per_400 af3Y2_5per_400 af2Y2_5per_400 af1Y2_5per_400 af1Y1_5per_400];

    t400Max = af2Y1_5per_400 - af2Y2_5per_400;
    t400Min = af3Y1_5per_400 - af3Y2_5per_400;

    %Root Chord = 425
    af1Y1_5per_425 = ((af1X_5per(2) - af1_RC425(119,1))/(af1_RC425(118,1)-af1_RC425(119,1))) * (af1_RC425(118,3)-af1_RC425(119,3)) + af1_RC425(119,3);
    af1Y2_5per_425 = ((af1X_5per(2) - af1_RC425(131,1))/(af1_RC425(132,1)-af1_RC425(131,1))) * (af1_RC425(132,3)-af1_RC425(131,3)) + af1_RC425(131,3);
    af2X_5per_425 = af2_RC425(125,1)+af1X_5per(2);
    af2Y1_5per_425 = (((af2_RC425(125,1)+af1X_5per(2)) - af2_RC425(114,1))/(af2_RC425(113,1)-af2_RC425(114,1))) * (af2_RC425(113,3)-af2_RC425(114,3)) + af2_RC425(114,3);
    af2Y2_5per_425 = (((af2_RC425(125,1)+af1X_5per(2)) - af2_RC425(136,1))/(af2_RC425(137,1)-af2_RC425(136,1))) * (af2_RC425(137,3)-af2_RC425(136,3)) + af2_RC425(136,3);
    af3X_5per_425 = af3_RC425(125,1)+af1X_5per(2);
    af3Y1_5per_425 = (((af3_RC425(125,1)+af1X_5per(2)) - af3_RC425(107,1))/(af3_RC425(106,1)-af3_RC425(107,1))) * (af3_RC425(106,3)-af3_RC425(107,3)) + af3_RC425(107,3);
    af3Y2_5per_425 = (((af3_RC425(125,1)+af1X_5per(2)) - af3_RC425(138,1))/(af3_RC425(139,1)-af3_RC425(138,1))) * (af3_RC425(139,3)-af3_RC425(138,3)) + af3_RC425(138,3);

    t425x = [af1X_5per(2) af2X_5per_425 af3X_5per_425 af3X_5per_425 af2X_5per_425 af1X_5per(2) af1X_5per(2)];
    t425y = [af1Y1_5per_425 af2Y1_5per_425 af3Y1_5per_425 af3Y2_5per_425 af2Y2_5per_425 af1Y2_5per_425 af1Y1_5per_425];

    t425Max = af2Y1_5per_425 - af2Y2_5per_425;
    t425Min = af3Y1_5per_425 - af3Y2_5per_425;

    %Root Chord = 450
    af1Y1_5per_450 = ((af1X_5per(3) - af1_RC450(119,1))/(af1_RC450(118,1)-af1_RC450(119,1))) * (af1_RC450(118,3)-af1_RC450(119,3)) + af1_RC450(119,3);
    af1Y2_5per_450 = ((af1X_5per(3) - af1_RC450(131,1))/(af1_RC450(132,1)-af1_RC450(131,1))) * (af1_RC450(132,3)-af1_RC450(131,3)) + af1_RC450(131,3);
    af2X_5per_450 = af2_RC450(125,1)+af1X_5per(3);
    af2Y1_5per_450 = (((af2_RC450(125,1)+af1X_5per(3)) - af2_RC450(114,1))/(af2_RC450(113,1)-af2_RC450(114,1))) * (af2_RC450(113,3)-af2_RC450(114,3)) + af2_RC450(114,3);
    af2Y2_5per_450 = (((af2_RC450(125,1)+af1X_5per(3)) - af2_RC450(136,1))/(af2_RC450(137,1)-af2_RC450(136,1))) * (af2_RC450(137,3)-af2_RC450(136,3)) + af2_RC450(136,3);
    af3X_5per_450 = af3_RC450(125,1)+af1X_5per(3);
    af3Y1_5per_450 = (((af3_RC450(125,1)+af1X_5per(3)) - af3_RC450(107,1))/(af3_RC450(106,1)-af3_RC450(107,1))) * (af3_RC450(106,3)-af3_RC450(107,3)) + af3_RC450(107,3);
    af3Y2_5per_450 = (((af3_RC450(125,1)+af1X_5per(3)) - af3_RC450(138,1))/(af3_RC450(139,1)-af3_RC450(138,1))) * (af3_RC450(139,3)-af3_RC450(138,3)) + af3_RC450(138,3);

    t450x = [af1X_5per(3) af2X_5per_450 af3X_5per_450 af3X_5per_450 af2X_5per_450 af1X_5per(3) af1X_5per(3)];
    t450y = [af1Y1_5per_450 af2Y1_5per_450 af3Y1_5per_450 af3Y2_5per_450 af2Y2_5per_450 af1Y2_5per_450 af1Y1_5per_450];

    t450Max = af2Y1_5per_450 - af2Y2_5per_450;
    t450Min = af3Y1_5per_450 - af3Y2_5per_450;

    %Root Chord = 475
    af1Y1_5per_475 = ((af1X_5per(4) - af1_RC475(119,1))/(af1_RC475(118,1)-af1_RC475(119,1))) * (af1_RC475(118,3)-af1_RC475(119,3)) + af1_RC475(119,3);
    af1Y2_5per_475 = ((af1X_5per(4) - af1_RC475(131,1))/(af1_RC475(132,1)-af1_RC475(131,1))) * (af1_RC475(132,3)-af1_RC475(131,3)) + af1_RC475(131,3);
    af2X_5per_475 = af2_RC475(125,1)+af1X_5per(4);
    af2Y1_5per_475 = (((af2_RC475(125,1)+af1X_5per(4)) - af2_RC475(114,1))/(af2_RC475(113,1)-af2_RC475(114,1))) * (af2_RC475(113,3)-af2_RC475(114,3)) + af2_RC475(114,3);
    af2Y2_5per_475 = (((af2_RC475(125,1)+af1X_5per(4)) - af2_RC475(136,1))/(af2_RC475(137,1)-af2_RC475(136,1))) * (af2_RC475(137,3)-af2_RC475(136,3)) + af2_RC475(136,3);
    af3X_5per_475 = af3_RC475(125,1)+af1X_5per(4);
    af3Y1_5per_475 = (((af3_RC475(125,1)+af1X_5per(4)) - af3_RC475(107,1))/(af3_RC475(106,1)-af3_RC475(107,1))) * (af3_RC475(106,3)-af3_RC475(107,3)) + af3_RC475(107,3);
    af3Y2_5per_475 = (((af3_RC475(125,1)+af1X_5per(4)) - af3_RC475(138,1))/(af3_RC475(139,1)-af3_RC475(138,1))) * (af3_RC475(139,3)-af3_RC475(138,3)) + af3_RC475(138,3);

    t475x = [af1X_5per(4) af2X_5per_475 af3X_5per_475 af3X_5per_475 af2X_5per_475 af1X_5per(4) af1X_5per(4)];
    t475y = [af1Y1_5per_475 af2Y1_5per_475 af3Y1_5per_475 af3Y2_5per_475 af2Y2_5per_475 af1Y2_5per_475 af1Y1_5per_475];

    t475Max = af2Y1_5per_475 - af2Y2_5per_475;
    t475Min = af3Y1_5per_475 - af3Y2_5per_475;
    
    %Root Chord = 500
    af1Y1_5per_500 = ((af1X_5per(5) - af1_RC500(119,1))/(af1_RC500(118,1)-af1_RC500(119,1))) * (af1_RC500(118,3)-af1_RC500(119,3)) + af1_RC500(119,3);
    af1Y2_5per_500 = ((af1X_5per(5) - af1_RC500(131,1))/(af1_RC500(132,1)-af1_RC500(131,1))) * (af1_RC500(132,3)-af1_RC500(131,3)) + af1_RC500(131,3);
    af2X_5per_500 = af2_RC500(125,1)+af1X_5per(5);
    af2Y1_5per_500 = (((af2_RC500(125,1)+af1X_5per(5)) - af2_RC500(114,1))/(af2_RC500(113,1)-af2_RC500(114,1))) * (af2_RC500(113,3)-af2_RC500(114,3)) + af2_RC500(114,3);
    af2Y2_5per_500 = (((af2_RC500(125,1)+af1X_5per(5)) - af2_RC500(136,1))/(af2_RC500(137,1)-af2_RC500(136,1))) * (af2_RC500(137,3)-af2_RC500(136,3)) + af2_RC500(136,3);
    af3X_5per_500 = af3_RC500(125,1)+af1X_5per(5);
    af3Y1_5per_500 = (((af3_RC500(125,1)+af1X_5per(5)) - af3_RC500(107,1))/(af3_RC500(106,1)-af3_RC500(107,1))) * (af3_RC500(106,3)-af3_RC500(107,3)) + af3_RC500(107,3);
    af3Y2_5per_500 = (((af3_RC500(125,1)+af1X_5per(5)) - af3_RC500(138,1))/(af3_RC500(139,1)-af3_RC500(138,1))) * (af3_RC500(139,3)-af3_RC500(138,3)) + af3_RC500(138,3);

    t500x = [af1X_5per(5) af2X_5per_500 af3X_5per_500 af3X_5per_500 af2X_5per_500 af1X_5per(5) af1X_5per(5)];
    t500y = [af1Y1_5per_500 af2Y1_5per_500 af3Y1_5per_500 af3Y2_5per_500 af2Y2_5per_500 af1Y2_5per_500 af1Y1_5per_500];

    t500Max = af2Y1_5per_500 - af2Y2_5per_500;
    t500Min = af3Y1_5per_500 - af3Y2_5per_500;

%Plotting LE 5% cut thickness
figure
    subplot(5,2,[1,3,5,7,9])
    plot([0 -144/330 -96/330 -48/330 0 48/330 96/330 144/330 0],[0 308/330 1 308/330 1 308/330 1 308/330 0], "linewidth",1.5, "color","k")
    set(gca,"Ydir","reverse"); ylim([-0.1 1.1])
    hold on
    plot([0, -airfoil3(124,2)],[0.05*1, airfoil3(125,1)+0.05*1],"linewidth",1.5, "color","r", "linestyle", "--")
    plot([0,0],[0,1],"linewidth",1.5,"Color",[0 0.4470 0.7410])
    plot([-airfoil2(1,2), -airfoil2(1,2)],[airfoil2(1,1), airfoil2(125,1)],"linewidth",1.5, "Color",[0.8500 0.3250 0.0980])
    plot([-airfoil3(1,2), -airfoil3(1,2)], [airfoil3(1,1), airfoil3(125,1)],"linewidth",1.5,"Color",[0.4660 0.6740 0.1880])
    legend("Planform Geometry", "Cut Cross Section", "Airfoil 1", "Airfoil 2", "Airfoil 3", "Location", "southoutside")
    
    subplot(5,2,2)
    plot(t400x,t400y,"linewidth",1.5, "color","r", "linestyle", "--")
    hold on
    plot([af2X_5per_400 af2X_5per_400], [af2Y1_5per_400, af2Y2_5per_400],"linewidth",1.5, "color","b","linestyle", "-.")
    plot([af3X_5per_400 af3X_5per_400], [af3Y1_5per_400, af3Y2_5per_400],"linewidth",1.5, "color","g","linestyle", "-.")
    daspect([1,1,1]); xlim([-1 350]); ylim([-20 20])
    legend("Root Chord = 400mm", "Max Thickness "+ num2str(t400Max)+" mm","Min Thickness "+ num2str(t400Min)+" mm","Location", "Eastoutside")

    subplot(5,2,4)
    plot(t425x,t425y,"linewidth",1.5, "color","r", "linestyle", "--")
    hold on
    plot([af2X_5per_425 af2X_5per_425], [af2Y1_5per_425, af2Y2_5per_425],"linewidth",1.5, "color","b","linestyle", "-.")
    plot([af3X_5per_425 af3X_5per_425], [af3Y1_5per_425, af3Y2_5per_425],"linewidth",1.5, "color","g","linestyle", "-.")
    daspect([1,1,1]); xlim([-1 350]); ylim([-20 20])
    legend("Root Chord = 425mm", "Max Thickness "+ num2str(t425Max)+" mm","Min Thickness "+ num2str(t425Min)+" mm", "Location", "Eastoutside")
    
    subplot(5,2,6)
    plot(t450x,t450y,"linewidth",1.5, "color","r", "linestyle", "--")
    hold on
    plot([af2X_5per_450 af2X_5per_450], [af2Y1_5per_450, af2Y2_5per_450],"linewidth",1.5, "color","b","linestyle", "-.")
    plot([af3X_5per_450 af3X_5per_450], [af3Y1_5per_450, af3Y2_5per_450],"linewidth",1.5, "color","g","linestyle", "-.")
    daspect([1,1,1]); xlim([-1 350]); ylim([-20 20])
    legend("Root Chord = 450mm", "Max Thickness "+ num2str(t450Max)+" mm","Min Thickness "+ num2str(t450Min)+" mm", "Location", "Eastoutside")

    subplot(5,2,8)
    plot(t475x,t475y,"linewidth",1.5, "color","r", "linestyle", "--")
    hold on
    plot([af2X_5per_475 af2X_5per_475], [af2Y1_5per_475, af2Y2_5per_475],"linewidth",1.5, "color","b","linestyle", "-.")
    plot([af3X_5per_475 af3X_5per_475], [af3Y1_5per_475, af3Y2_5per_475],"linewidth",1.5, "color","g","linestyle", "-.")
    daspect([1,1,1]); xlim([-1 350]); ylim([-20 20])
    legend("Root Chord = 475mm", "Max Thickness "+ num2str(t475Max)+" mm","Min Thickness "+ num2str(t475Min)+" mm", "Location", "Eastoutside")

    subplot(5,2,10)
    plot(t500x,t500y,"linewidth",1.5, "color","r", "linestyle", "--")
    hold on
    plot([af2X_5per_500 af2X_5per_500], [af2Y1_5per_500, af2Y2_5per_500],"linewidth",1.5, "color","b","linestyle", "-.")
    plot([af3X_5per_500 af3X_5per_500], [af3Y1_5per_500, af3Y2_5per_500],"linewidth",1.5, "color","g","linestyle", "-.")
    daspect([1,1,1]); xlim([-1 350]); ylim([-20 20])
    legend("Root Chord = 500mm","Max Thickness "+ num2str(t500Max)+" mm","Min Thickness "+ num2str(t500Min)+" mm", "Location", "Eastoutside")

%Calculating Max AOA 
    AreaDW = AreaWT * 0.12;
    span = 287/330 .* rootChord;
    MaxAOA = asin((2.*AreaDW)./(span.*rootChord)) .* 180/pi;

%Plotting Max AOA
    figure
    subplot(5,2,[1,3,5,7,9])
    plot([-500/1000 500/1000 500/1000 -500/1000 -500/1000], [-400/1000 -400/1000 400/1000 400/1000 -400/1000], "linewidth",3, "color","k")
    hold on
    plot([-0.2 0.2 0 -0.2 ],[-0.2 -0.2 0.1 -0.2],"linewidth",1.5, "color","b")
    daspect([1,1,1]); xlim([-520/1000 520/1000]); ylim([-420/1000 420/1000]);
    legend("Wind Tunnel Cross Section", "Projected Delta Wing Geometry", "Location", "southoutside")

    subplot(5,2,2)
    plot([0,0],[(rootChord(1)/4),-(rootChord(1)-(rootChord(1)/4))],"linewidth",1.5, "color","b")
    hold on
    plot(0, 0, "ro"); hold on; plot(0, 0, "rx");
    hold on 
    plot([-150 50], [0, 0], "LineStyle","--", "LineWidth",1.5,"color", "k")
    set(gca,"Xdir","reverse")
    ylim([-380 145]); xlim([-190 75]); daspect([1,5,1])
    legend("Root Chord = 400mm","Quarter Root Chord", "", "Max AOA 90^o", "Location", "Eastoutside")

    subplot(5,2,4)
    plot([0,0],[(rootChord(2)/4),-(rootChord(2)-(rootChord(2)/4))],"linewidth",1.5, "color","b")
    hold on
    plot(0, 0, "ro"); hold on; plot(0, 0, "rx");
    hold on 
    plot([-150 50], [0, 0], "LineStyle","--", "LineWidth",1.5,"color", "k")
    set(gca,"Xdir","reverse")
    ylim([-380 145]); xlim([-190 75]); daspect([1,5,1])

    subplot(5,2,6)
    plot([0,0],[(rootChord(3)/4),-(rootChord(3)-(rootChord(3)/4))],"linewidth",1.5, "color","b")
    hold on
    plot(0, 0, "ro"); hold on; plot(0, 0, "rx");
    hold on 
    plot([-150 50], [0, 0], "LineStyle","--", "LineWidth",1.5,"color", "k")
    set(gca,"Xdir","reverse")
    ylim([-380 145]); xlim([-190 75]); daspect([1,5,1])

    subplot(5,2,8)
    plot([(rootChord(4)/4)*cosd(MaxAOA(4)),-(rootChord(4)-(rootChord(4)/4))*cosd(MaxAOA(4))],[(rootChord(4)/4)*sind(MaxAOA(4)),-(rootChord(4)-(rootChord(4)/4))*sind(MaxAOA(4))],"linewidth",1.5, "color","b")
    hold on
    plot(0, 0, "ro"); hold on; plot(0, 0, "rx");
    hold on 
    plot([-150 50], [0, 0], "LineStyle","--", "LineWidth",1.5,"color", "k")
    set(gca,"Xdir","reverse")
    ylim([-380 145]); xlim([-190 75]); daspect([1,5,1])

    subplot(5,2,10)
    plot([(rootChord(5)/4)*cosd(MaxAOA(5)),-(rootChord(5)-(rootChord(5)/4))*cosd(MaxAOA(5))],[(rootChord(5)/4)*sind(MaxAOA(5)),-(rootChord(5)-(rootChord(5)/4))*sind(MaxAOA(5))],"linewidth",1.5, "color","b")
    hold on
    plot(0, 0, "ro"); hold on; plot(0, 0, "rx");
    hold on 
    plot([-150 50], [0, 0], "LineStyle","--", "LineWidth",1.5,"color", "k")
    set(gca,"Xdir","reverse")
    ylim([-380 145]); xlim([-190 75]); daspect([1,5,1])