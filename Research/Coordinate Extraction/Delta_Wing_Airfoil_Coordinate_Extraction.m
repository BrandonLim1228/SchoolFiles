%--------------------------------------------------------------------------
% Flow Physics and Control Lab
%
% Description: 
%    The following code is the delta wing airfoil coordinate extraction from a matlab coordinate
%    image found in the masters thesis "Dynamic Active Flow Control of 
%    the Roll Moment on a Generic UCAS Wing" by Xiaowei He
%
% Brandon Lim
% 1/15/2025
%--------------------------------------------------------------------------
clear, clc, close all
% Wing and Body Geometry
    b = 287; %mm
    Cr = 330; %mm
    s = b/2; %mm
    A = 65; %deg
    theta = 90-A; %deg

% Importing image 
    Airfoil_Image = flipud(imread("Delta Wing Airfoil Coordinates.jpg"));

% Calculating the size of the image
    [M,N,~] = size(Airfoil_Image);

% Finding color values that correspond to each image matrix indice
    for i = 1:M
        for j = 1:N
            colorMatrix{i,j} = [Airfoil_Image(i,j,1), Airfoil_Image(i,j,2), Airfoil_Image(i,j,3)];
        end
    end

% Setting color tolerance for data extraction based on colorMatrix values
    % Percentage above and below color values allowed for data extraction
    colorTol = 0.14; 
    % Color values for each airfoil found looking at the color matrix and choosing a pair of low/high vectors
    blueVals = [39, 102, 133; 53, 116, 149];
    orangeVals = [165, 96, 66; 183, 128, 91];
    greenVals = [134, 155, 86; 155, 168, 114];
    % Limits for each airfoils color values based on the value and tolerance
    bluelims = [blueVals(1,:) - (blueVals(1,:) .* colorTol); blueVals(2,:) + (blueVals(2,:) .* colorTol)];
    orangelims = [orangeVals(1,:) - (orangeVals(1,:) .* colorTol); orangeVals(2,:) + (orangeVals(2,:) .* colorTol)];
    greenlims = [greenVals(1,:) - (greenVals(1,:) .* colorTol); greenVals(2,:) + (greenVals(2,:) .* colorTol)];

% Setting pre-existing axis limits from the JPEG for the matlab figure
    xMin = -15.265; xMax = 335.495; xlims = [xMin, xMax];
    yMin = -64.45; yMax = 57.65; ylims = [yMin, yMax];

%Finding matlab figure indicies that match color of each airfoil
    k = 1;
    n = 1;
    l = 1;
    for i = 1:M
        for j = 1:N
            %Finding y = 0 (root) airfoil indicies (blue)
            if (Airfoil_Image(i,j,1) >= bluelims(1,1) && Airfoil_Image(i,j,1) <= bluelims(2,1))&&(Airfoil_Image(i,j,2) >= bluelims(1,2) && Airfoil_Image(i,j,2) <= bluelims(2,2))&&(Airfoil_Image(i,j,3) >= bluelims(1,3) && Airfoil_Image(i,j,3) <= bluelims(2,3))
                blueXraw(n) = j * ((abs(xMax) + abs(xMin))/N) + xMin;
                blueYraw(n) = i * ((abs(yMax) + abs(yMin))/M) + yMin;
                n = n + 1;
            end
            %Finding y = 1/3s airfoil indicies (orange)
            if (Airfoil_Image(i,j,1) >= orangelims(1,1) && Airfoil_Image(i,j,1) <= orangelims(2,1))&&(Airfoil_Image(i,j,2) >= orangelims(1,2) && Airfoil_Image(i,j,2) <= orangelims(2,2))&&(Airfoil_Image(i,j,3) >= orangelims(1,3) && Airfoil_Image(i,j,3) <= orangelims(2,3))
                orangeXraw(k) = j * ((abs(xMax) + abs(xMin))/N) + xMin;
                orangeYraw(k) = i * ((abs(yMax) + abs(yMin))/M) + yMin;
                k = k + 1;
            end
            %Finding y = 2/3s airfoil indicies (green)
            if (Airfoil_Image(i,j,1) >= greenlims(1,1) && Airfoil_Image(i,j,1) <= greenlims(2,1))&&(Airfoil_Image(i,j,2) >= greenlims(1,2) && Airfoil_Image(i,j,2) <= greenlims(2,2))&&(Airfoil_Image(i,j,3) >= greenlims(1,3) && Airfoil_Image(i,j,3) <= greenlims(2,3))
                greenXraw(l) = j * ((abs(xMax) + abs(xMin))/N) + xMin;
                greenYraw(l) = i * ((abs(yMax) + abs(yMin))/M) + yMin;
                l = l + 1;
            end
        end
    end

%Removing data found in jpeg legend
    j = 1;
    for i = 1:length(blueYraw)
        if blueYraw(i) < 40
            blueX(j) = blueXraw(i);
            blueY(j) = blueYraw(i);
            j = j + 1;
        end
    end
    j = 1;
    for i = 1:length(orangeYraw)
        if orangeYraw(i) < 30
            orangeX(j) = orangeXraw(i);
            orangeY(j) = orangeYraw(i);
            j = j + 1;
        end
    end
    j = 1;
    for i = 1:length(greenYraw)
        if greenYraw(i) < 20
            greenX(j) = greenXraw(i);
            greenY(j) = greenYraw(i);
            j = j + 1;
        end
    end

% Sorting y = 0 airfoil (blue) data in the counter-clockwise direction
% starting at the trailing edge
    n = 1;
    k = 1;
    for i = 1:length(blueY)
        % Sepparating airfoil coordinates into top and bottom half depending on the y-coordinate sign
        if blueY(i) > 0 
            blueXTop(n) = blueX(i);
            blueYTop(n) = blueY(i);
            n = n + 1;
        else
            blueXBot(k) = blueX(i);
            blueYBot(k) = blueY(i);
            k = k + 1;
        end
    end
    % Sorting y = 0 airfoil top data into descending order based on X
        [BTopX,Itop] = sort(blueXTop,"descend");
        BTopY = blueYTop(Itop);
    % Sorting y = 0 airfoil bottom data into ascending order based on X
        [BBotX,Ibot] = sort(blueXBot);
        BBotY = blueYBot(Ibot);
    % Concatenating sorted top and bottom data 
        Blue_Airfoil_Sorted_Data_Raw = [BTopX,BBotX;BTopY,BBotY];

% Sorting y = 1/3s airfoil (orange) data in the counter clockwise direction starting at the trailing edge
    n = 1;
    k = 1;
    for i = 1:length(orangeY)
        % Sepparating airfoil coordinates into top and bottom half depending on the y-coordinate sign
        if orangeY(i) > 0 
            orangeXTop(n) = orangeX(i);
            orangeYTop(n) = orangeY(i);
            n = n + 1;
        else
            orangeXBot(k) = orangeX(i);
            orangeYBot(k) = orangeY(i);
            k = k + 1;
        end
    end
    % Sorting y = 1/3s airfoil top data into descending order based on X
        [OTopX,Itop] = sort(orangeXTop,"descend");
        OTopY = orangeYTop(Itop);
    % Sorting y = 1/3s airfoil bottom data into ascending order based on X
        [OBotX,Ibot] = sort(orangeXBot);
        OBotY = orangeYBot(Ibot);
    % Concatenating sorted top and bottom data 
        Orange_Airfoil_Sorted_Data_Raw = [OTopX,OBotX;OTopY,OBotY];

% Sorting y = 2/3s airfoil (green) data in the counter clockwise direction starting at the trailing edge
    n = 1;
    k = 1;
    for i = 1:length(greenY)
        % Sepparating airfoil coordinates into top and bottom half depending on the y-coordinate sign
        if greenY(i) > 0 
            greenXTop(n) = greenX(i);
            greenYTop(n) = greenY(i);
            n = n + 1;
        else
            greenXBot(k) = greenX(i);
            greenYBot(k) = greenY(i);
            k = k + 1;
        end
    end
    % Sorting y = 2/3s airfoil top data into descending order based on X
        [GTopX,Itop] = sort(greenXTop,"descend");
        GTopY = greenYTop(Itop);
    % Sorting y = 2/3s airfoil bottom data into ascending order based on X
        [GBotX,Ibot] = sort(greenXBot);
        GBotY = greenYBot(Ibot);
    % Concatenating sorted top and bottom data 
        Green_Airfoil_Sorted_Data_Raw = [GTopX,GBotX;GTopY,GBotY];

% Smoothing Data Using a moving average 
    if (rem(length(Blue_Airfoil_Sorted_Data_Raw),2)) == 1
        blueLength = length(Blue_Airfoil_Sorted_Data_Raw)-1;
    else 
        blueLength = length(Blue_Airfoil_Sorted_Data_Raw);
    end
    if (rem(length(Orange_Airfoil_Sorted_Data_Raw),2)) == 1
        orangeLength = length(Orange_Airfoil_Sorted_Data_Raw)-1;
    else 
        orangeLength = length(Orange_Airfoil_Sorted_Data_Raw);
    end
    if (rem(length(Green_Airfoil_Sorted_Data_Raw),2)) == 1
        greenLength = length(Green_Airfoil_Sorted_Data_Raw)-1;
    else 
        greenLength = length(Green_Airfoil_Sorted_Data_Raw);
    end

    BWS = 24; % "Blue Window Size" - Window size for the averaging of blue data points
    %Averaging over every window size of data
    for i = 1:(blueLength/BWS)
        Blue_Airfoil_Sorted_Data_Smoothed(:,i) = mean(Blue_Airfoil_Sorted_Data_Raw(:,((i-1)*BWS + 1):((i-1)*BWS + BWS)),2);
    end
        
    OWS = 14; % "Orange Window Size" - Window size for the averaging of orange data points
    %Averaging over every window size of data
    for i = 1:(orangeLength/OWS)
        Orange_Airfoil_Sorted_Data_Smoothed(:,i) = mean(Orange_Airfoil_Sorted_Data_Raw(:,((i-1)*OWS + 1):((i-1)*OWS + OWS)),2);
    end
    
    GWS = 6; % "Green Window Size" - Window size for the averaging of green data points
    %Averaging over every window size of data
    for i = 1:(greenLength/GWS)
        Green_Airfoil_Sorted_Data_Smoothed(:,i) = mean(Green_Airfoil_Sorted_Data_Raw(:,((i-1)*GWS + 1):((i-1)*GWS + GWS)),2);
    end

% Calculating Leading Edge Points
    LE_blueX = 0; LE_blueY = 0; %mm

    LE_orangePY = (1/3) * s; %y position in planform geometry axis on the leading edge (different than y in airfoil coordinate system) mm
    LE_orangeX = LE_orangePY/tand(theta); %x position in planform geometry axis on leading edge mm 
    LE_orangeY = 0; %mm

    LE_greenPY = (2/3) * s; %y position in planform geometry axis on the leading edge (different than y in airfoil coordinate system) mm 
    LE_greenX = (LE_greenPY/tand(theta)); %x position in planform geometry axis on leading edge mm
    LE_greenY = 0;%mm

% Calculating Trailing Edge Points
    TE_blueX = 330; %mm
    TE_blueY_Upper = 0.5; %mm - approximated from jpeg image
    TE_blueY_Lower = -0.5; %mm - approximated from peg image
    % 
    TE_orangeX = 308; %mm - found from wing_geo_plot.m
    TE_orangeY_Upper = 0.25; %mm - approximated form jpeg image
    TE_orangeY_Lower = -0.25; %mm - approximated form jpeg image

    % TE_greenX = 330; %mm - found from wing_geo_plot.m
    TE_greenX = 330; %mm - found from wing_geo_plot.m
    TE_greenY_Upper = 0.25; %mm - approximated form jpeg image
    TE_greenY_Lower = -0.25; %mm - approximated form jpeg image
    
% Final smoothed data with trailing and leading edge points
    BIneg = find(Blue_Airfoil_Sorted_Data_Smoothed(2,:) < 0); %index where blue airfoil y data switches from positive to negative
    Blue_Airfoil_Sorted_Data_Smoothed = [TE_blueX, Blue_Airfoil_Sorted_Data_Smoothed(1,1:(BIneg(1)-1)), LE_blueX, Blue_Airfoil_Sorted_Data_Smoothed(1,BIneg(1):end), TE_blueX ; TE_blueY_Upper, Blue_Airfoil_Sorted_Data_Smoothed(2,1:(BIneg(1)-1)), LE_blueY, Blue_Airfoil_Sorted_Data_Smoothed(2,BIneg(1):end),TE_blueY_Lower]';
    
    OIneg = find(Orange_Airfoil_Sorted_Data_Smoothed(2,:) < 0); %index where orange airfoil y data switches from positive to negative
    Orange_Airfoil_Sorted_Data_Smoothed = [TE_orangeX, Orange_Airfoil_Sorted_Data_Smoothed(1,1:(OIneg(1)-1)), LE_orangeX, Orange_Airfoil_Sorted_Data_Smoothed(1,OIneg(1):end), TE_orangeX ; TE_orangeY_Upper, Orange_Airfoil_Sorted_Data_Smoothed(2,1:(OIneg(1)-1)), LE_orangeY, Orange_Airfoil_Sorted_Data_Smoothed(2,OIneg(1):end),TE_orangeY_Lower]';

    GIneg = find(Green_Airfoil_Sorted_Data_Smoothed(2,:) < 0); %index where green airfoil y data switches from positive to negative
    Green_Airfoil_Sorted_Data_Smoothed = [TE_greenX, Green_Airfoil_Sorted_Data_Smoothed(1,1:(GIneg(1)-1)), LE_greenX, Green_Airfoil_Sorted_Data_Smoothed(1,GIneg(1):end), TE_greenX ; TE_greenY_Upper, Green_Airfoil_Sorted_Data_Smoothed(2,1:(GIneg(1)-1)), LE_greenY, Green_Airfoil_Sorted_Data_Smoothed(2,GIneg(1):end),TE_greenY_Lower]';

%--------------------------------------------------------------------------
% Flow Physics and Control Lab
%
% Description: 
%    The following code is the delta wing airfoil coordinate curve fitting from data extraction above to
%    achieve a smooth contour.
%
% 1/25/2025
%--------------------------------------------------------------------------

%% Y = 0 airfoil

%Sepparating data in upper and lower airfoil
    Y0LEindex = find(Blue_Airfoil_Sorted_Data_Smoothed(:,1) == 0); %Findig leading edge index to split the airfoil
    Y0_Top_Data = Blue_Airfoil_Sorted_Data_Smoothed(1:Y0LEindex,:); Y0_Bot_Data = Blue_Airfoil_Sorted_Data_Smoothed(Y0LEindex:end,:); %Separating data into upper and lower airfoil

%Fitting curves to the airfoil
    %Establishing weights for fitting data 
    weightT0 = [20, 0.1*ones(1,length(Y0_Top_Data(:,1))-2), 20]; weightB0 = [40, 0.01*ones(1,length(Y0_Bot_Data(:,1))-2), 40]; %Weights for data points. More emphasis on first and last points than intermediate
    y0Upper = fit(Y0_Top_Data(:,1),Y0_Top_Data(:,2),'poly5','Weights',weightT0); y0Lower = fit(Y0_Bot_Data(:,1),Y0_Bot_Data(:,2),'poly5','Weights',weightB0); clc; %Fitting a curve based on weights
    y0UP = coeffvalues(y0Upper); y0LP = coeffvalues(y0Lower); %polynomials of fit

%Plotting
    figure
    plot(Blue_Airfoil_Sorted_Data_Smoothed(:,1),Blue_Airfoil_Sorted_Data_Smoothed(:,2), "bo") % Y0_airfoil raw data points
    daspect([1,1,1]); ylim([-100 100]) %1:1 aspect ratio
    hold on; plot(y0Upper, "k"); hold on; plot(y0Lower,"k"); %Weighted 5th degree polynomial 
    %Axis labels and title
    title("Y=0 Airfoil Coordinates Curve Fitting"); xlabel("x-coordinate [mm]"); ylabel("y-coorddinate [mm]")

%Saving final data points 
    xVecUpper_y0 = linspace(329,1,123); xVecLower_y0 = linspace(1,329,123); %Creating linear evenly spaced x-values for upper and lower skins. 123 data points for each excluding leading and trailing edge points
    y0Upper = (y0UP(1)) .* (xVecUpper_y0.^5) + (y0UP(2)) .* (xVecUpper_y0.^4) + (y0UP(3)) .* (xVecUpper_y0.^3) + (y0UP(4)) .* (xVecUpper_y0.^2) + y0UP(5) .* (xVecUpper_y0.^1) + y0UP(6);
    y0Lower = (y0LP(1)) .* (xVecLower_y0.^5) + (y0LP(2)) .* (xVecLower_y0.^4) + (y0LP(3)) .* (xVecLower_y0.^3) + (y0LP(4)) .* (xVecLower_y0.^2) + (y0LP(5)) .* (xVecLower_y0.^1) + (y0LP(6));

    Y0_Airfoil_Final = [TE_blueX, xVecUpper_y0, LE_blueX, xVecLower_y0, TE_blueX ; TE_blueY_Upper y0Upper, LE_blueY, y0Lower, TE_blueY_Lower]';
    writematrix(Y0_Airfoil_Final,"Yequ0_Airfoil_Official", "Delimiter", "\t"); writematrix(Y0_Airfoil_Final./330,"Yequ0_Airfoil_Official_Normalized", "Delimiter", "\t");

%% Y = 1/3s airfoil

%Sepparating data in upper and lower airfoil
    Y03sLEindex = find(Orange_Airfoil_Sorted_Data_Smoothed(:,2) == 0); %Findig leading edge index to split the airfoil
    Y03s_Top_Data = Orange_Airfoil_Sorted_Data_Smoothed(1:Y03sLEindex,:); Y03s_Bot_Data = Orange_Airfoil_Sorted_Data_Smoothed(Y03sLEindex:end,:); %Separating data into upper and lower airfoil

%Fitting curves to the airfoil
    %Establishing weights for fitting major data 
    eT = ones(1,50); eB = 20 * ones(1,46);
    dT = ones(1,50); dB = ones(1,50);
    cT = 0.5*ones(1,30); cB = ones(1,30);
    bT = 2*ones(1,15); bB = 20*ones(1,15);
    aT = 5*ones(1,4); aB = 30*ones(1,4);
    weightT03s = [30,eT,dT,cT,bT,aT,40]; weightB03s = [60,aB,bB,cB,dB,eB,40];
    %Establishing weights for initial data
    weightTI03s = [0.01 1 1 3 10 10 10]; %(first 6 points after leading edge to capture curvature on the top skin)
    weightBI03s = [1 0.00001 0.00001 1 1 0.0001]; 
    %Weighted fitting to the data
    y03sUpper_MD = fit(Y03s_Top_Data(:,1),Y03s_Top_Data(:,2),"poly9","Weights",weightT03s); MDuP03s = coeffvalues(y03sUpper_MD); %Good for x= 109 - end
    y03sLower_MD = fit(Y03s_Bot_Data(:,1),Y03s_Bot_Data(:,2),"poly9","Weights",weightB03s); MDlP03s = coeffvalues(y03sLower_MD);%Good for x = 109 - end
    y03sUpper_ID = fit(Y03s_Top_Data([end-6:end], 1), Y03s_Top_Data([end-6:end],2), "poly6","Weights",weightTI03s); IDuP03s = coeffvalues(y03sUpper_ID); %Good for x = 102.5 - 106
    y03sLower_ID = fit(Y03s_Bot_Data([1:6], 1), Y03s_Bot_Data([1:6],2), "poly4","Weights",weightBI03s); IDlP03s = coeffvalues(y03sLower_ID);clc; %Good for x = 102.5 - 107

%Plotting
    figure
    plot(Orange_Airfoil_Sorted_Data_Smoothed(:,1),Orange_Airfoil_Sorted_Data_Smoothed(:,2),"linestyle","none","marker",'o',"color",[0.8500 0.3250 0.0980]) % Y03s_airfoil raw data points
    daspect([1,1,1]); ylim([-100 100]); xlim([0,350]); legend off; %1:1 aspect ratio
    hold on; plot(y03sUpper_MD,"k"); hold on; plot(y03sLower_MD,"k") %Major Data
    hold on; plot(y03sUpper_ID); hold on; plot(y03sLower_ID); %Inital Data
    %Axis labels and title
    title("Y=033s Airfoil Coordinates Curve Fitting"); xlabel("x-coordinate [mm]"); ylabel("y-coorddinate [mm]"); legend off;

%Saving final data points
    %X values for major data
    xVecUpperMD_y03s = linspace(307,109,119); xVecLowerMD_y03s = linspace(109,307,119); 
    %Y values for major data
    y03sUpperMD = (MDuP03s(1)) .* (xVecUpperMD_y03s.^9) + (MDuP03s(2)) .* (xVecUpperMD_y03s.^8) + (MDuP03s(3)) .* (xVecUpperMD_y03s.^7) + (MDuP03s(4)) .* (xVecUpperMD_y03s.^6) + (MDuP03s(5)) .* (xVecUpperMD_y03s.^5) + (MDuP03s(6)) .* (xVecUpperMD_y03s.^4)  + MDuP03s(7) .* (xVecUpperMD_y03s.^3) + MDuP03s(8) .* (xVecUpperMD_y03s.^2) + MDuP03s(9) .* (xVecUpperMD_y03s) + MDuP03s(10);
    y03sLowerMD = (MDlP03s(1)) .* (xVecLowerMD_y03s.^9) + (MDlP03s(2)) .* (xVecLowerMD_y03s.^8) + (MDlP03s(3)) .* (xVecLowerMD_y03s.^7) + (MDlP03s(4)) .* (xVecLowerMD_y03s.^6) + (MDlP03s(5)) .* (xVecLowerMD_y03s.^5) + (MDlP03s(6)) .* (xVecLowerMD_y03s.^4)  + MDlP03s(7) .* (xVecLowerMD_y03s.^3) + MDlP03s(8) .* (xVecLowerMD_y03s.^2) + MDlP03s(9) .* (xVecLowerMD_y03s) + MDlP03s(10);
    %X values for initial data
    xVecUpperID_y03s = linspace(106,103,4); xVecLowerID_y03s = linspace(103,107.5,4);  
    %Y values for inital data
    y03sUpperID = (IDuP03s(1)) .* (xVecUpperID_y03s.^6) + (IDuP03s(2)) .* (xVecUpperID_y03s.^5)  + IDuP03s(3) .* (xVecUpperID_y03s.^4) + IDuP03s(4) .* (xVecUpperID_y03s.^3) + IDuP03s(5) .* (xVecUpperID_y03s.^2) + IDuP03s(6).* (xVecUpperID_y03s) + IDuP03s(7);
    y03sLowerID = (IDlP03s(1)) .* (xVecLowerID_y03s.^4)  + IDlP03s(2) .* (xVecLowerID_y03s.^3) + IDlP03s(3) .* (xVecLowerID_y03s.^2) + IDlP03s(4) .* (xVecLowerID_y03s) + IDlP03s(5);

    Y03s_Airfoil_Final = [TE_orangeX, xVecUpperMD_y03s, xVecUpperID_y03s, LE_orangeX, xVecLowerID_y03s, xVecLowerMD_y03s, TE_orangeX; TE_orangeY_Upper, y03sUpperMD, y03sUpperID, LE_orangeY, y03sLowerID, y03sLowerMD, TE_orangeY_Lower]';
    writematrix(Y03s_Airfoil_Final,"Yequ03s_Airfoil_Official", "Delimiter", "\t"); writematrix(Y03s_Airfoil_Final./330,"Yequ03s_Airfoil_Official_Normalized", "Delimiter", "\t");

%% y = 2/3s airfoil


%Sepparating data in upper and lower airfoil
    Y06sLEindex = find(Green_Airfoil_Sorted_Data_Smoothed(:,2) == 0); %Findig leading edge index to split the airfoil
    Y06s_Top_Data = Green_Airfoil_Sorted_Data_Smoothed(1:Y06sLEindex,:); Y06s_Bot_Data = Green_Airfoil_Sorted_Data_Smoothed(Y06sLEindex:end,:); %Separating data into upper and lower airfoil

%Fitting Curves to the airfoil
    %Establishing weights for fitting major data
    weightT06s = [40, ones(1,220), 10]; weightB06s = [1,ones(1,231),40];
    %Weighted fitting to the data    
    y06sUpper_MD = fit(Y06s_Top_Data(:,1),Y06s_Top_Data(:,2),"poly6","Weight",weightT06s); MDuP06s = coeffvalues(y06sUpper_MD); %Good for x = 213.5 - end
    y06sLower_MD = fit(Y06s_Bot_Data(:,1),Y06s_Bot_Data(:,2),"poly6","Weight",weightB06s); MDlP06s = coeffvalues(y06sLower_MD); %Good for x = 219 - end
    y06sUpper_ID  = fit(Y06s_Top_Data(end-25:end,1),Y06s_Top_Data(end-25:end,2),"poly4", "Weight", [ones(1,25), 10]); IDuP06s = coeffvalues(y06sUpper_ID); %Good for x = 205.3 - 213.5 
    y06sLower_ID = fit(Y06s_Bot_Data(1:30,1),Y06s_Bot_Data(1:30,2),"poly5", "Weight",[5, ones(1,29)]); IDlP06s = coeffvalues(y06sLower_ID); clc %Good for x = 205.3 - 218

%Plotting
    figure
    plot(Green_Airfoil_Sorted_Data_Smoothed(:,1),Green_Airfoil_Sorted_Data_Smoothed(:,2),"linestyle","none","marker",'o', "Color",[0.4660 0.6740 0.1880]); % Y06s_airfoil raw data points
    daspect([1,1,1]); ylim([-30 40]); xlim([200,330]); legend off; %1:1 aspect ratio
    hold on; plot(y06sUpper_MD); hold on; plot(y06sLower_MD); %Major Data
    hold on; plot(y06sLower_ID); hold on; plot(y06sUpper_ID) %Initial Data
    %Axis labels and title
    title("Y=067s Airfoil Coordinates Curve Fitting"); xlabel("x-coordinate [mm]"); ylabel("y-coorddinate [mm]"); legend off;

%Saving final data points
    %X values for major data
    xVecUpperMD_y06s = linspace(329,214,118); xVecLowerMD_y06s = linspace(219,329,118);
    %Y values for major data
    y06sUpperMD = (MDuP06s(1)) .* (xVecUpperMD_y06s.^6) + (MDuP06s(2)) .* (xVecUpperMD_y06s.^5) + (MDuP06s(3)) .* (xVecUpperMD_y06s.^4)  + MDuP06s(4) .* (xVecUpperMD_y06s.^3) + MDuP06s(5) .* (xVecUpperMD_y06s.^2) + MDuP06s(6) .* (xVecUpperMD_y06s) + MDuP06s(7);
    y06sLowerMD = (MDlP06s(1)) .* (xVecLowerMD_y06s.^6) + (MDlP06s(2)) .* (xVecLowerMD_y06s.^5) + (MDlP06s(3)) .* (xVecLowerMD_y06s.^4)  + MDlP06s(4) .* (xVecLowerMD_y06s.^3) + MDlP06s(5) .* (xVecLowerMD_y06s.^2) + MDlP06s(6) .* (xVecLowerMD_y06s) + MDlP06s(7);
    %X values for initial data
    xVecUpperID_y06s = linspace(213,205.3,10); xVecLowerID_y06s = linspace(205.3,218,10);
    %Y values for initial data
    y06sUpperID = (IDuP06s(1)) .* (xVecUpperID_y06s.^4)  + IDuP06s(2) .* (xVecUpperID_y06s.^3) + IDuP06s(3) .* (xVecUpperID_y06s.^2) + IDuP06s(4) .* (xVecUpperID_y06s) + IDuP06s(5);
    y06sLowerID = (IDlP06s(1)) .* (xVecLowerID_y06s.^5) + (IDlP06s(2)) .* (xVecLowerID_y06s.^4)  + IDlP06s(3) .* (xVecLowerID_y06s.^3) + IDlP06s(4) .* (xVecLowerID_y06s.^2) + IDlP06s(5) .* (xVecLowerID_y06s) + IDlP06s(6);

    Y06s_Airfoil_Final = [TE_greenX, xVecUpperMD_y06s, xVecUpperID_y06s, LE_greenX, xVecLowerID_y06s, xVecLowerMD_y06s, TE_greenX; TE_greenY_Upper, y06sUpperMD, y06sUpperID, LE_greenY, y06sLowerID, y06sLowerMD, TE_greenY_Lower]';
    writematrix(Y06s_Airfoil_Final,"Yequ06s_Airfoil_Official", "Delimiter", "\t"); writematrix(Y06s_Airfoil_Final./330,"Yequ06s_Airfoil_Official_Normalized", "Delimiter", "\t");


%Comparing Fits To Extracted Data
    %y0 airfoil
    y0Upper_Comparison = (y0UP(1)) .* (Y0_Top_Data(:,1).^5) + (y0UP(2)) .* (Y0_Top_Data(:,1).^4) + (y0UP(3)) .* (Y0_Top_Data(:,1).^3) + (y0UP(4)) .* (Y0_Top_Data(:,1).^2) + y0UP(5) .* (Y0_Top_Data(:,1).^1) + y0UP(6);
    y0Lower_Comparison = (y0LP(1)) .* (Y0_Bot_Data(:,1).^5) + (y0LP(2)) .* (Y0_Bot_Data(:,1).^4) + (y0LP(3)) .* (Y0_Bot_Data(:,1).^3) + (y0LP(4)) .* (Y0_Bot_Data(:,1).^2) + (y0LP(5)) .* (Y0_Bot_Data(:,1).^1) + (y0LP(6));
    errorY0Top = abs((y0Upper_Comparison - Y0_Top_Data(:,2))./Y0_Top_Data(:,2)) .*100; errorY0Bot = abs((y0Lower_Comparison - Y0_Bot_Data(:,2))./Y0_Bot_Data(:,2)) .*100;
    
    figure
    plot(Y0_Top_Data(:,1),errorY0Top,"ro"); hold on; plot(Y0_Bot_Data(:,1),errorY0Bot,"bo")
    title("Percent Error")

    %y03s airfoil
    n = 1; k = 1; z = 1; r = 1;
    for i = 1:length(Y03s_Top_Data)
        if Y03s_Top_Data(i,1) >= 108
            y03sUpperMD_Comparison(n) = (MDuP03s(1)) .* (Y03s_Top_Data(i,1).^9) + (MDuP03s(2)) .* (Y03s_Top_Data(i,1).^8) + (MDuP03s(3)) .* (Y03s_Top_Data(i,1).^7) + (MDuP03s(4)) .* (Y03s_Top_Data(i,1).^6) + (MDuP03s(5)) .* (Y03s_Top_Data(i,1).^5) + (MDuP03s(6)) .* (Y03s_Top_Data(i,1).^4)  + MDuP03s(7) .* (Y03s_Top_Data(i,1).^3) + MDuP03s(8) .* (Y03s_Top_Data(i,1).^2) + MDuP03s(9) .* (Y03s_Top_Data(i,1)) + MDuP03s(10);
            n = n + 1;
        else
            y03sUpperID_Comparison(z) = (IDuP03s(1)) .* (Y03s_Top_Data(i,1).^6) + (IDuP03s(2)) .* (Y03s_Top_Data(i,1).^5)  + IDuP03s(3) .* (Y03s_Top_Data(i,1).^4) + IDuP03s(4) .* (Y03s_Top_Data(i,1).^3) + IDuP03s(5) .* (Y03s_Top_Data(i,1).^2) + IDuP03s(6).* (Y03s_Top_Data(i,1)) + IDuP03s(7);
            z = z + 1;
        end
    end
    for i = 1:length(Y03s_Bot_Data)
        if Y03s_Bot_Data(i,1) >= 107
            y03sLowerMD_Comparison(k) = (MDlP03s(1)) .* (Y03s_Bot_Data(i,1).^9) + (MDlP03s(2)) .* (Y03s_Bot_Data(i,1).^8) + (MDlP03s(3)) .* (Y03s_Bot_Data(i,1).^7) + (MDlP03s(4)) .* (Y03s_Bot_Data(i,1).^6) + (MDlP03s(5)) .* (Y03s_Bot_Data(i,1).^5) + (MDlP03s(6)) .* (Y03s_Bot_Data(i,1).^4)  + MDlP03s(7) .* (Y03s_Bot_Data(i,1).^3) + MDlP03s(8) .* (Y03s_Bot_Data(i,1).^2) + MDlP03s(9) .* (Y03s_Bot_Data(i,1)) + MDlP03s(10);
            k = k + 1;
        else
            y03sLowerID_Comparison(r) = (IDlP03s(1)) .* (Y03s_Bot_Data(i,1).^4)  + IDlP03s(2) .* (Y03s_Bot_Data(i,1).^3) + IDlP03s(3) .* (Y03s_Bot_Data(i,1).^2) + IDlP03s(4) .* (Y03s_Bot_Data(i,1)) + IDlP03s(5);
            r = r + 1;
        end
    end
    y03sUpper_Comparison = [y03sUpperMD_Comparison, y03sUpperID_Comparison]'; y03sLower_Comparison = [y03sLowerID_Comparison, y03sLowerMD_Comparison]';

    errorY03sTop = abs((y03sUpper_Comparison - Y03s_Top_Data(:,2))./Y03s_Top_Data(:,2)) .*100; errorY03sBot = abs((y03sLower_Comparison - Y03s_Bot_Data(:,2))./Y03s_Bot_Data(:,2)) .*100;
    figure
    plot(Y03s_Top_Data(:,1),errorY03sTop,"ro")
    hold on
    plot(Y03s_Bot_Data(:,1),errorY03sBot,"bo")
        
    %y06s airfoil


























%% Plot Comparrison of JPEG Extracted Data
figure
    subplot(2,2,1)
        image(xlims, ylims, Airfoil_Image)
        % Updating image aspect ratio of matlab figure to match axis alignment with JPEG photo
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        % Adding a grid to the image 
            grid on; grid minor; ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("x-coord [mm]"); ylabel("y-coord [mm]"); title("JPEG Image");
    subplot(2,2,2)
            plot(Blue_Airfoil_Sorted_Data_Smoothed(:,1),Blue_Airfoil_Sorted_Data_Smoothed(:,2), "linewidth", 1, "Color",[0 0.4470 0.7410]) %y=0 airfoil
        hold on
            plot(Orange_Airfoil_Sorted_Data_Smoothed(:,1),Orange_Airfoil_Sorted_Data_Smoothed(:,2), "linewidth", 1, "Color",[0.8500 0.3250 0.0980]) %y=1/3s airfoil
        hold on
            plot(Green_Airfoil_Sorted_Data_Smoothed(:,1),Green_Airfoil_Sorted_Data_Smoothed(:,2), "linewidth", 1, "Color",[0.4660 0.6740 0.1880]) %y=2/3s airfoil
        %Setting axis limits 
            xlim([xMin,xMax]); ylim([yMin,yMax]);
        %Updating image aspect ratio to match axis alignment
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1]);
        %Adding plot grid
            grid on; grid minor; ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("x-coord [mm]"); ylabel("y-coord [mm]"); title("Reconstructed Airfoils with Smoothed Data")
    subplot(2,2,3)
            plot(Blue_Airfoil_Sorted_Data_Raw(1,:),Blue_Airfoil_Sorted_Data_Raw(2,:),".", "Color",[0 0.4470 0.7410]) %y=0 airfoil
        hold on 
            plot(Orange_Airfoil_Sorted_Data_Raw(1,:),Orange_Airfoil_Sorted_Data_Raw(2,:),".","Color",[0.8500 0.3250 0.0980]) %y=1/3s airfoil
        hold on
            plot(Green_Airfoil_Sorted_Data_Raw(1,:),Green_Airfoil_Sorted_Data_Raw(2,:),".","Color",[0.4660 0.6740 0.1880]) %y=2/3s airfoil
        %Setting axis limits 
            xlim([xMin,xMax]); ylim([yMin,yMax])
        %Updating image aspect ratio to match axis alignment
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1]);
        %Adding plot grid
            grid on; grid minor; ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("x-coord [mm]"); ylabel("y-coord [mm]"); title("Raw Extracted Data Points");
    subplot(2,2,4)
            plot(Blue_Airfoil_Sorted_Data_Smoothed(:,1),Blue_Airfoil_Sorted_Data_Smoothed(:,2),".", "Color",[0 0.4470 0.7410]) %y=0 airfoil
        hold on
            plot(Orange_Airfoil_Sorted_Data_Smoothed(:,1),Orange_Airfoil_Sorted_Data_Smoothed(:,2),".", "Color",[0.8500 0.3250 0.0980]) %y=1/3s airfoil
        hold on
            plot(Green_Airfoil_Sorted_Data_Smoothed(:,1),Green_Airfoil_Sorted_Data_Smoothed(:,2),".","Color",[0.4660 0.6740 0.1880]) %y=2/3s airfoil
        %Setting axis limits 
            xlim([xMin,xMax]); ylim([yMin,yMax])
        %Updating image aspect ratio to match axis alignment
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1]);
        %Adding plot grid
            grid on; grid minor; ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("x-coord [mm]"); ylabel("y-coord [mm]"); title("Smoothed Extracted Data Points")

%% Plot Comparison of JPEG Image and Final Airfoils
figure 
    subplot(3,1,1)
        image(xlims, ylims, Airfoil_Image)
        % Updating image aspect ratio of matlab figure to match axis alignment with JPEG photo
        daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1]);
        % Adding a grid to the image
        grid on; set(gca,"YDir","normal");
        %Adding axis labels and title
        xlabel("x-coord [mm]"); ylabel("y-coord [mm]"); title("JPEG Image")
    subplot(3,1,2)
        plot(Y0_Airfoil_Final(:,1),Y0_Airfoil_Final(:,2), "linewidth", 1.5, "Color",[0 0.4470 0.7410], "linestyle", "none", "Marker", ".") %y=0 airfoil
        hold on 
        plot(Y03s_Airfoil_Final(:,1),Y03s_Airfoil_Final(:,2), "linewidth", 1.5, "Color",[0.8500 0.3250 0.0980], "linestyle", "none", "Marker",".") %y=03s airfoil
        hold on
        plot(Y06s_Airfoil_Final(:,1),Y06s_Airfoil_Final(:,2), "linewidth", 1.5, "Color", [0.4660 0.6740 0.1880], "linestyle", "none", "Marker",".") %y=06s airfoil
        xlim(xlims);ylim(ylims);
        %Updating image aspect ratio to match axis alignment
        daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        %Adding plot grid
        grid on; set(gca,"YDir","normal");
        %Adding axis labels and title
        xlabel("x-coord [mm]"); ylabel("y-coord [mm]"); title("Reconstructed Airfoil Data")
    subplot(3,1,3)
        plot(Y0_Airfoil_Final(:,1),Y0_Airfoil_Final(:,2), "linewidth", 1.5, "Color",[0 0.4470 0.7410]) %y=0 airfoil
        hold on 
        plot(Y03s_Airfoil_Final(:,1),Y03s_Airfoil_Final(:,2), "linewidth", 1.5, "Color",[0.8500 0.3250 0.0980]) %y=03s airfoil
        hold on
        plot(Y06s_Airfoil_Final(:,1),Y06s_Airfoil_Final(:,2), "linewidth", 1.5, "Color", [0.4660 0.6740 0.1880]) %y=06s airfoil
        xlim(xlims);ylim(ylims);
        %Updating image aspect ratio to match axis alignment
        daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        %Adding plot grid
        grid on; set(gca,"YDir","normal");
        %Adding axis labels and title
        xlabel("x-coord [mm]"); ylabel("y-coord [mm]"); title("Reconstructed Airfoil Data")
%% Normaized Plots
airfoil1 = readmatrix("Yequ0_Airfoil_Official_Normalized.txt");
airfoil2 = readmatrix("Yequ03s_Airfoil_Official_Normalized.txt");
airfoil3 = readmatrix("Yequ06s_Airfoil_Official_Normalized.txt");
figure
    plot(airfoil1(:,1),airfoil1(:,2), "linewidth", 1.5, "Color",[0 0.4470 0.7410]) %y=0 airfoil
    hold on 
    plot(airfoil2(:,1),airfoil2(:,2), "linewidth", 1.5, "Color",[0.8500 0.3250 0.0980]) %y=03s airfoil
    hold on
    plot(airfoil3(:,1),airfoil3(:,2), "linewidth", 1.5, "Color", [0.4660 0.6740 0.1880]) %y=06s airfoil
    xlim([-0.1 1.1]); ylim([-0.1 0.1]);
    %Updating image aspect ratio to match axis alignment
    daspect([1,1,1]); grid on; set(gca,"YDir","normal");
    %Adding axis labels and title
    xlabel("x-coord [mm]"); ylabel("y-coord [mm]"); title("Reconstructed Airfoil Data")
    






















