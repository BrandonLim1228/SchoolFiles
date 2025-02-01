%--------------------------------------------------------------------------
% Flow Physics and Control Lab
%
% Description: 
%    Delta wing airfoil coordinate curve fitting from data extraction to
%    achieve a smooth contour. Data Points extracted from
%    "Delta_Wing_Airfoil_Coordinate_Extraction.m"
%
% Brandon Lim
% 1/25/2025
%--------------------------------------------------------------------------
%% Y = 0 airfoil
clear, clc, close all
format longg

%Reading In Airfoil Data
    Y0_airfoil_data = readmatrix("0_Airfoil_unfiltered.txt");

%Sepparating data in upper and lower airfoil
    Y0index_0 = find(Y0_airfoil_data(:,1) == 0); %Findig leading edge index to split the airfoil
    Y0_Top_Data = Y0_airfoil_data(1:Y0index_0,:); Y0_Bot_Data = Y0_airfoil_data(Y0index_0:end,:); %Separating data into upper and lower airfoil

%Fitting curves to the airfoil
    %Weighted 5th order fit (First and Last indicies are weighted higher to force the curve to meet these points
    weightT = [20, 0.1*ones(1,length(Y0_Top_Data(:,1))-2), 20]; weightB = [40, 0.01*ones(1,length(Y0_Bot_Data(:,1))-2), 40]; %Weights for data points. More emphasis on first and last points than intermediate
    yUpper = fit(Y0_Top_Data(:,1),Y0_Top_Data(:,2),'poly5','Weights',weightT); yLower = fit(Y0_Bot_Data(:,1),Y0_Bot_Data(:,2),'poly5','Weights',weightB); clc; %Fitting a curve based on weights
    yUP = coeffvalues(yUpper); yLP = coeffvalues(yLower); %polynomials of fit

%Plotting
    figure
    plot(Y0_Top_Data(:,1),Y0_Top_Data(:,2),"bo", Y0_Bot_Data(:,1),Y0_Bot_Data(:,2), "bo") % Y0_airfoil raw data points
    daspect([1,1,1]); ylim([-100 100]) %1:1 aspect ratio
    hold on; plot(yUpper, "k"); hold on; plot(yLower,"k"); %Weighted 5th degree polynomial 
    %Axis labels and title
    title("Y=0 Airfoil Coordinates Curve Fitting"); xlabel("x-coordinate [mm]"); ylabel("y-coorddinate [mm]")

%Saving final data points 
    xVecUpper = linspace(329,1,123); xVecLower = linspace(1,329,123);
    y0Upper = (yUP(1)) .* (xVecUpper.^5) + (yUP(2)) .* (xVecUpper.^4) + (yUP(3)) .* (xVecUpper.^3) + (yUP(4)) .* (xVecUpper.^2) + yUP(5) .* (xVecUpper.^1) + yUP(6);
    y0Lower = (yLP(1)) .* (xVecLower.^5) + (yLP(2)) .* (xVecLower.^4) + (yLP(3)) .* (xVecLower.^3) + (yLP(4)) .* (xVecLower.^2) + (yLP(5)) .* (xVecLower.^1) + (yLP(6));

    Y0_Airfoil_Final = [330, xVecUpper, 0, xVecLower, 330 ; 0.5 y0Upper, 0, y0Lower, -0.5]';
    writematrix(Y0_Airfoil_Final,"Yequ0_Airfoil_Official")

%% Y = 1/3s airfoil
clear, clc, close all
format longg

%Reading In Airfoil Data
    Y03s_airfoil_data = readmatrix("033s_Airfoil_unfiltered.txt");

%Sepparating data in upper and lower airfoil
    Y03sindex_0 = find(Y03s_airfoil_data(:,2) == 0); %Findig leading edge index to split the airfoil
    Y03s_Top_Data = Y03s_airfoil_data(1:Y03sindex_0,:); Y03s_Bot_Data = Y03s_airfoil_data(Y03sindex_0:end,:); %Separating data into upper and lower airfoil

%Fitting curves to the airfoil
    %Establishing weights for fitting major data 
    eT = ones(1,50); eB = 20 * ones(1,46);
    dT = ones(1,50); dB = ones(1,50);
    cT = 0.5*ones(1,30); cB = ones(1,30);
    bT = 2*ones(1,15); bB = 20*ones(1,15)
    aT = 5*ones(1,4); aB = 30*ones(1,4);
    weightT = [30,eT,dT,cT,bT,aT,40]; weightB = [60,aB,bB,cB,dB,eB,40];
    %Establishing weights for initial data
    weightTI = [0.01 1 1 3 10 10 10]; %(first 6 points after leading edge to capture curvature on the top skin)
    weightBI = [1 0.00001 0.00001 1 1 0.0001]; 
    %Weighted fitting to the data
    yUpper_MD = fit(Y03s_Top_Data(:,1),Y03s_Top_Data(:,2),"poly9","Weights",weightT); MDuP = coeffvalues(yUpper_MD); %Good for x= 109 - end
    yLower_MD = fit(Y03s_Bot_Data(:,1),Y03s_Bot_Data(:,2),"poly9","Weights",weightB); MDlP = coeffvalues(yLower_MD);%Good for x = 109 - end
    yUpper_ID = fit(Y03s_Top_Data([end-6:end], 1), Y03s_Top_Data([end-6:end],2), "poly5","Weights",weightTI); IDuP = coeffvalues(yUpper_ID); %Good for x = 102.5 - 106
    yLower_ID = fit(Y03s_Bot_Data([1:6], 1), Y03s_Bot_Data([1:6],2), "poly4","Weights",weightBI); IDlP = coeffvalues(yLower_ID);clc; %Good for x = 102.5 - 107

%Plotting
    figure
    plot(Y03s_airfoil_data(:,1),Y03s_airfoil_data(:,2),"linestyle","none","marker",'o',"color",[0.8500 0.3250 0.0980]) % Y03s_airfoil raw data points
    daspect([1,1,1]); ylim([-100 100]); xlim([0,350]); legend off; %1:1 aspect ratio
    hold on; plot(yUpper_MD,"k"); hold on; plot(yLower_MD,"k") %Major Data
    hold on; plot(yUpper_ID); hold on; plot(yLower_ID); %Inital Data

    xVecUpperMD = linspace(307,109,118); xVecLowerMD = linspace(109,307,118); %X values for major data 
    %Y values for major data
    y03sUpperMD = (MDuP(1)) .* (xVecUpperMD.^9) + (MDuP(2)) .* (xVecUpperMD.^8) + (MDuP(3)) .* (xVecUpperMD.^7) + (MDuP(4)) .* (xVecUpperMD.^6) + (MDuP(5)) .* (xVecUpperMD.^5) + (MDuP(6)) .* (xVecUpperMD.^4)  + MDuP(7) .* (xVecUpperMD.^3) + MDuP(8) .* (xVecUpperMD.^2) + MDuP(9) .* (xVecUpperMD) + MDuP(10);
    y03sLowerMD = (MDlP(1)) .* (xVecLowerMD.^9) + (MDlP(2)) .* (xVecLowerMD.^8) + (MDlP(3)) .* (xVecLowerMD.^7) + (MDlP(4)) .* (xVecLowerMD.^6) + (MDlP(5)) .* (xVecLowerMD.^5) + (MDlP(6)) .* (xVecLowerMD.^4)  + MDlP(7) .* (xVecLowerMD.^3) + MDlP(8) .* (xVecLowerMD.^2) + MDlP(9) .* (xVecLowerMD) + MDlP(10);
    xVecUpperID = linspace(106,103,5); xVecLowerID = linspace(103,107.5,5);  %X values for initial data
    %Y values for inital data
    y03sUpperID = (IDuP(1)) .* (xVecUpperID.^5) + (IDuP(2)) .* (xVecUpperID.^4)  + IDuP(3) .* (xVecUpperID.^3) + IDuP(4) .* (xVecUpperID.^2) + IDuP(5) .* (xVecUpperID) + IDuP(6);
    y03sLowerID = (IDlP(1)) .* (xVecLowerID.^4)  + IDlP(2) .* (xVecLowerID.^3) + IDlP(3) .* (xVecLowerID.^2) + IDlP(4) .* (xVecLowerID) + IDlP(5);

    A = ((1/3)*(287/2))/tand(25); %Leading Edge x-Point
    Y03s_Airfoil_Final = [308, xVecUpperMD, xVecUpperID, A, xVecLowerID, xVecLowerMD, 308; 0.25, y03sUpperMD, y03sUpperID, 0, y03sLowerID, y03sLowerMD, -0.25]';
    writematrix(Y03s_Airfoil_Final,"Yequ03s_Airfoil_Official")

