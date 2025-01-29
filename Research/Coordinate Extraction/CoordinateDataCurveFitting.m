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
clear, clc
format longg

%X-vector for plotting
    x = linspace(0,330,10000);

%Reading In Airfoil Data
    Y0_airfoil_data = readmatrix("0_Airfoil.txt");
    Y23s_airfoil_data = readmatrix("067s_Airfoil.txt");

%Sepparating data in upper and lower airfoil
    Y0index_0 = find(Y0_airfoil_data(:,1) == 0); %Findig leading edge index to split the airfoil
    Y0_Top_Data = Y0_airfoil_data(1:Y0index_0,:); Y0_Bot_Data = Y0_airfoil_data(Y0index_0:end,:); %Separating data into upper and lower airfoil

%Fitting curves to the airfoil
    %Weighted 5th order fit (First and Last indicies are weighted hire to force the curve to meet these points
    Weights_Upper = [20, 0.1*ones(1,length(Y0_Top_Data(:,1))-2), 20]; Weights_Lower = [40, 0.01*ones(1,length(Y0_Bot_Data(:,1))-2), 40]; %Weights for data points. More emphasis on first and last points than intermediate
    yUpperW = fit(Y0_Top_Data(:,1),Y0_Top_Data(:,2),'poly5','Weights',Weights_Upper); yLower = fit(Y0_Bot_Data(:,1),Y0_Bot_Data(:,2),'poly5','Weights',Weights_Lower) %Fitting a curve based on weights

    %Fitting a 4th order polynomial
    pY0_Top4 = polyfit(Y0_Top_Data(:,1),Y0_Top_Data(:,2),4); pY0_Bot4 = polyfit(Y0_Bot_Data(:,1),Y0_Bot_Data(:,2),4); %Finding polynomial coefficients
    y4T = pY0_Bot4(1) .* x.^4 + pY0_Bot4(2) .* x.^3 + pY0_Bot4(3) .* x.^2 + pY0_Bot4(4) .* x + pY0_Bot4(5); y4B = pY0_Top4(1) .* x.^4 + pY0_Top4(2) .* x.^3 + pY0_Top4(3) .* x.^2 + pY0_Top4(4) .* x + pY0_Top4(5); %Equations for the fit 
    
    %Fitting a 5th order polynomial
    pY0_Top5 = polyfit(Y0_Top_Data(:,1),Y0_Top_Data(:,2),5); pY0_Bot5 = polyfit(Y0_Bot_Data(:,1),Y0_Bot_Data(:,2),5); %Finding polynomial coefficients
    y5T = pY0_Bot5(1) .* x.^5 + pY0_Bot5(2) .* x.^4 + pY0_Bot5(3) .* x.^3 + pY0_Bot5(4) .* x.^2 + pY0_Bot5(5) .* x + pY0_Bot5(6); y5B = pY0_Top5(1) .* x.^5 + pY0_Top5(2) .* x.^4 + pY0_Top5(3) .* x.^3 + pY0_Top5(4) .* x.^2 + pY0_Top5(5) .* x + pY0_Top5(6); %Equations for the fit

    %Fitting a 6th order polynomial
    pY0_Top6 = polyfit(Y0_Top_Data(:,1),Y0_Top_Data(:,2),6); pY0_Bot6 = polyfit(Y0_Bot_Data(:,1),Y0_Bot_Data(:,2),6); %Finding polynomial coefficients
    y6T = pY0_Top6(1) .* x.^6 + pY0_Top6(2) .* x.^5 + pY0_Top6(3) .* x.^4 + pY0_Top6(4) .* x.^3 + pY0_Top6(5) .* x.^2 + pY0_Top6(6) .* x + pY0_Top6(7); y6B = pY0_Bot6(1) .* x.^6 + pY0_Bot6(2) .* x.^5 + pY0_Bot6(3) .* x.^4 + pY0_Bot6(4) .* x.^3 + pY0_Bot6(5) .* x.^2 + pY0_Bot6(6) .* x + pY0_Bot6(7); %Equations for the fit
    
%Plotting
    figure
    plot(Y0_Top_Data(:,1),Y0_Top_Data(:,2),"bo", Y0_Bot_Data(:,1),Y0_Bot_Data(:,2), "bo") % Y0_airfoil raw data points
    daspect([1,1,1]); ylim([-100 100]) %1:1 aspect ratio
    hold on; plot(yUpperW, "k"); hold on; plot(yLower,"k"); %Weighted 5th degree polynomial 
    hold on; plot(x,y4T,"g"); hold on; plot(x,y4B,"g"); %4th degree polynomial
    hold on; plot(x,y5T,"b"); hold on; plot(x,y5B,"b"); %5th degree polynomial
    hold on; plot(x,y6T,"r"); hold on; plot(x,y6B,"r"); %6th degree polynomial
    %Axis labels and title
    title("Y=0 Airfoil Coordinates Curve Fitting")
    xlabel("x-coordinate [mm]")
    ylabel("y-coorddinate [mm]")
    %Legend
    legend("Raw Data","","Weighted 5th Order","","4th Order","","5th Order","","6th Order","")

%Saving final data points 
    xVecUpper = linspace(329,1,123); xVecLower = linspace(1,329,123);
    y0Upper = (1.22010662271016*(10^-11)) .* (xVecUpper.^5) + (-3.47951689281967*(10^-8)) .* (xVecUpper.^4) + (1.91955121737004*(10^-5)) .* (xVecUpper.^3) + (-0.004530620897238) .* (xVecUpper.^2) + 0.511975251719158 .* (xVecUpper.^1) + -0.00482560585325242;
    y0Lower = (-9.48123410501432*(10^-12)) .* (xVecLower.^5) + (1.91968235421602*(10^-8)) .* (xVecLower.^4) + (-9.16619741803586*(10^-6)) .* (xVecLower.^3) + (0.00220897007681584) .* (xVecLower.^2) + (-0.309712173435798) .* (xVecLower.^1) + (0.000544550536124579);

    Y0_Airfoil_Final = [330, xVecUpper, 0, xVecLower, 330 ; 0.5 y0Upper, 0, y0Lower, -0.5]';
    writematrix(Y0_Airfoil_Final,"Yequ0_Airfoil_Official")

%% Y = 1/3s airfoil
clear, clc
format longg

x = linspace(0,330,10000);
%Reading In Airfoil Data
    Y03s_airfoil_data = readmatrix("033s_Airfoil.txt");

%Sepparating data in upper and lower airfoil
    Y03sindex_0 = find(Y03s_airfoil_data(:,2) == 0); %Findig leading edge index to split the airfoil
    Y03s_Top_Data = Y03s_airfoil_data(1:Y03sindex_0,:); Y03s_Bot_Data = Y03s_airfoil_data(Y03sindex_0:end,:); %Separating data into upper and lower airfoil

%Fitting curves to the airfoil
    length03T = length(Y03s_Top_Data); length03B = length(Y03s_Bot_Data);
    eT = ones(1,50); eB = ones(1,46)
    dT = ones(1,50); dB = ones(1,50);
    cT = 0.5*ones(1,30); cB = ones(1,30);
    bT = 2*ones(1,15); bB = 20*ones(1,15)
    aT = 10*ones(1,4); aB = 30*ones(1,4);
    weightT = [30,eT,dT,cT,bT,aT,40]; weightB = [60,aB,bB,cB,dB,eB,40];

    WT = fit(Y03s_Top_Data(:,1),Y03s_Top_Data(:,2),"poly9","Weights",weightT); WB = fit(Y03s_Bot_Data(:,1),Y03s_Bot_Data(:,2),"poly9","Weights",weightB); 

    pT4 = polyfit(Y03s_Top_Data(:,1),Y03s_Top_Data(:,2),4);
    yt4 = pT4(1) .* x.^4 + pT4(2) .* x.^3 + pT4(3) .* x.^2 + pT4(4) .* x + pT4(5);

    pT5 = polyfit(Y03s_Top_Data(:,1),Y03s_Top_Data(:,2),5);
    yt5 = pT5(1) .* x.^5 + pT5(2) .* x.^4 + pT5(3) .* x.^3 + pT5(4) .* x.^2 + pT5(5) .* x +pT5(6);

    pT6 = polyfit(Y03s_Top_Data(:,1),Y03s_Top_Data(:,2),6);
    yt6 = pT6(1) .* x.^6 + pT6(2) .* x.^5 + pT6(3) .* x.^4 + pT6(4) .* x.^3 + pT6(5) .* x.^2 +pT6(6) .*x + pT6(7);

    pT7 = polyfit(Y03s_Top_Data(:,1),Y03s_Top_Data(:,2),7);
    yt7 = pT7(1) .* x.^7 + pT7(2) .* x.^6 + pT7(3) .* x.^5 + pT7(4) .* x.^4 + pT7(5) .* x.^3 +pT7(6) .*x.^2 + pT7(7).*x+ pT7(8);

    pT8 = polyfit(Y03s_Top_Data(:,1),Y03s_Top_Data(:,2),8);
    yt8 = pT8(1) .* x.^8 + pT8(2) .* x.^7 + pT8(3) .* x.^6 + pT8(4) .* x.^5 + pT8(5) .* x.^4 +pT8(6) .*x.^3 + pT8(7).*x.^2 + pT8(8) .* x + pT8(9);

    pT9 = polyfit(Y03s_Top_Data(:,1),Y03s_Top_Data(:,2),9);
    yt9 = pT9(1) .* x.^9 + pT9(2) .* x.^8 + pT9(3) .* x.^7 + pT9(4) .* x.^6 + pT9(5) .* x.^5 +pT9(6) .*x.^4 + pT9(7).*x.^3 + pT9(8) .*x.^2 + pT9(9) .*x + pT9(10);

%Plotting
    figure
    plot(Y03s_airfoil_data(:,1),Y03s_airfoil_data(:,2),"linestyle","none","marker",'o',"color",[0.8500 0.3250 0.0980]) % Y0_airfoil raw data points
    daspect([1,1,1]); ylim([-100 100]);xlim([0,350]); legend off; %1:1 aspect ratio


    hold on; plot(x,yt4,"g");
    hold on; plot(x,yt5,"r");
    hold on; plot(x,yt6,"b");
    hold on; plot(x,yt7,"color",[0.3010 0.7450 0.9330]);
    hold on; plot(x,yt8,"color",[0.6350 0.0780 0.1840]);
    hold on; plot(x,yt9,"color",[0.4940 0.1840 0.5560]);
    hold on; plot(WT,"k")
    hold on; plot(WB,"k")

    xVecUpper = linspace(308,((1/3)*(287/2))/tand(25),123); xVecLower = linspace(((1/3)*(287/2))/tand(25),308,123);
    y03sUpper = (3.02088946901769*(10^-17)) .* (xVecUpper.^9) + (-5.72703536591023*(10^-14)) .* (xVecUpper.^8) + (4.76108333415575*(10^-11)) .* (xVecUpper.^7) + (-2.27703072174622*(10^-8)) .* (xVecUpper.^6) + (6.90175215465663*(10^-6)) .* (xVecUpper.^5) + (-0.00137455976249598) .* (xVecUpper.^4)  + 0.179863981053503 .* (xVecUpper.^3) + -14.9141704302568 .* (xVecUpper.^2) + 711.659768902142 .* (xVecUpper) + -14901.0009297264;
    y03sLower = (-3.06687441918267*(10^-17)) .* (xVecLower.^9) + (5.79268996267856*(10^-14)) .* (xVecLower.^8) + (-4.80038227594407*(10^-11)) .* (xVecLower.^7) + (2.28986549489292*(10^-8)) .* (xVecLower.^6) + (-6.9267648717501*(10^-6)) .* (xVecLower.^5) + (0.00137754491290466) .* (xVecLower.^4)  + -0.180066313904933 .* (xVecLower.^3) + 14.9158568752613 .* (xVecLower.^2) + -710.518577548888 .* (xVecLower) + 14828.0924184241;

    


clc



