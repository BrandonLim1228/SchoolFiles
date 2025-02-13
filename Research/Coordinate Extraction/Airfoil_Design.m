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
    