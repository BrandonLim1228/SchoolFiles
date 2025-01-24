%--------------------------------------------------------------------------
% Flow Physics and Control Lab
%
% Description: 
%    Delta wing airfoil coordinate extraction from a matlab coordinate
%    image found in the masters thesis "Dynamic Active Flow Control of 
%    the Roll Moment on a Generic UCAS Wing" by Xiaowei He
%
% Brandon Lim
% 1/15/2025
%--------------------------------------------------------------------------
clear, clc, close all
% Wing and Body Geometry
    Cr = 330; %mm
    b = 287; %mm
    s = b/2; %mm
    inner_sweep_angle = 25; %deg

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

% Sorting y = 0 airfoil (blue) data in the clockwise direction starting at x = 0
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
    % Sorting y = 0 airfoil top data into ascending order based on X
        [BTopX,Itop] = sort(blueXTop);
        BTopY = blueYTop(Itop);
    % Sorting y = 0 airfoil bottom data into descending order based on X
        [BBotX,Ibot] = sort(blueXBot,"descend");
        BBotY = blueYBot(Ibot);
    % Concatenating sorted top and bottom data 
        Blue_Airfoil_Sorted_Data_Raw = [BTopX,BBotX;BTopY,BBotY];

% Sorting y = 1/3s airfoil (orange) data in the clockwise direction starting at x = 0
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
    % Sorting y = 1/3s airfoil top data into ascending order based on X
        [OTopX,Itop] = sort(orangeXTop);
        OTopY = orangeYTop(Itop);
    % Sorting y = 1/3s airfoil bottom data into descending order based on X
        [OBotX,Ibot] = sort(orangeXBot,"descend");
        OBotY = orangeYBot(Ibot);
    % Concatenating sorted top and bottom data 
        Orange_Airfoil_Sorted_Data_Raw = [OTopX,OBotX;OTopY,OBotY];

% Sorting y = 2/3s airfoil (green) data in the clockwise direction starting at x = 0
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
    % Sorting y = 2/3s airfoil top data into ascending order based on X
        [GTopX,Itop] = sort(greenXTop);
        GTopY = greenYTop(Itop);
    % Sorting y = 2/3s airfoil bottom data into descending order based on X
        [GBotX,Ibot] = sort(greenXBot,"descend");
        GBotY = greenYBot(Ibot);
    % Concatenating sorted top and bottom data 
        Green_Airfoil_Sorted_Data_Raw = [GTopX,GBotX;GTopY,GBotY];

% Smoothing Data
    BWS = 8; % "Blue Window Size" - Window size for the averaging of blue data points
    %Averaging over every window size of data
    for i = 1:((length(Blue_Airfoil_Sorted_Data_Raw) - 1)/BWS)
        Blue_Airfoil_Sorted_Data_Smoothed(:,i) = mean(Blue_Airfoil_Sorted_Data_Raw(:,((i-1)*BWS + 1):((i-1)*BWS + BWS)),2);
    end
        BTrailingEdgeIndice = find(Blue_Airfoil_Sorted_Data_Smoothed(2,:) < 0);
        Blue_Airfoil_Sorted_Data_Smoothed = [0,Blue_Airfoil_Sorted_Data_Smoothed(1,1:BTrailingEdgeIndice(1)-1),330,Blue_Airfoil_Sorted_Data_Smoothed(1,BTrailingEdgeIndice(1):end), 0; 0,Blue_Airfoil_Sorted_Data_Smoothed(2,1:BTrailingEdgeIndice(1)-1),0,Blue_Airfoil_Sorted_Data_Smoothed(2,BTrailingEdgeIndice(1):end),0];
    
    OWS = 8; % "Orange Window Size" - Window size for the averaging of orange data points
    %Averaging over every window size of data
    for i = 1:((length(Orange_Airfoil_Sorted_Data_Raw))/OWS)
        Orange_Airfoil_Sorted_Data_Smoothed(:,i) = mean(Orange_Airfoil_Sorted_Data_Raw(:,((i-1)*OWS + 1):((i-1)*OWS + OWS)),2);
    end
        OTrailingEdgeIndice = find(Orange_Airfoil_Sorted_Data_Smoothed(2,:) < 0);
        Orange_Airfoil_Sorted_Data_Smoothed = [((1/3) * s)/tand(inner_sweep_angle), Orange_Airfoil_Sorted_Data_Smoothed(1,1:OTrailingEdgeIndice(1)-1),Orange_Airfoil_Sorted_Data_Smoothed(1,OTrailingEdgeIndice(1):end), ((1/3) * s)/tand(inner_sweep_angle); 0,Orange_Airfoil_Sorted_Data_Smoothed(2,1:OTrailingEdgeIndice(1)-1),Orange_Airfoil_Sorted_Data_Smoothed(2,OTrailingEdgeIndice(1):end),0];
    
    GWS = 6; % "Green Window Size" - Window size for the averaging of green data points
    %Averaging over every window size of data
    for i = 1:((length(Green_Airfoil_Sorted_Data_Raw))/GWS)
        Green_Airfoil_Sorted_Data_Smoothed(:,i) = mean(Green_Airfoil_Sorted_Data_Raw(:,((i-1)*GWS + 1):((i-1)*GWS + GWS)),2);
    end

% Plot Comparrison 
    subplot(2,2,1)
        image(xlims, ylims, Airfoil_Image)
        % Updating image aspect ratio of matlab figure to match axis alignment with JPEG photo
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        % Adding a grid to the image 
            grid on; grid minor; ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("x-coord [mm]")
            ylabel("y-coord [mm]")
            title("JPEG Image")
    subplot(2,2,3)
            plot(Blue_Airfoil_Sorted_Data_Raw(1,:),Blue_Airfoil_Sorted_Data_Raw(2,:),".", "Color",[0 0.4470 0.7410]) %y=0 airfoil
        hold on 
            plot(Orange_Airfoil_Sorted_Data_Raw(1,:),Orange_Airfoil_Sorted_Data_Raw(2,:),".","Color",[0.8500 0.3250 0.0980]) %y=1/3s airfoil
        hold on
            plot(Green_Airfoil_Sorted_Data_Raw(1,:),Green_Airfoil_Sorted_Data_Raw(2,:),".","Color",[0.4660 0.6740 0.1880]) %y=2/3s airfoil
        %Setting axis limits 
            xlim([xMin,xMax])
            ylim([yMin,yMax])
        %Updating image aspect ratio to match axis alignment
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        hold on
        %Adding plot grid
            grid on; grid minor;
            ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("x-coord [mm]")
            ylabel("y-coord [mm]")
            title("Raw Extracted Data Points")
    subplot(2,2,4)
            plot(Blue_Airfoil_Sorted_Data_Smoothed(1,:),Blue_Airfoil_Sorted_Data_Smoothed(2,:),".", "Color",[0 0.4470 0.7410]) %y=0 airfoil
        hold on
            plot(Orange_Airfoil_Sorted_Data_Smoothed(1,:),Orange_Airfoil_Sorted_Data_Smoothed(2,:),".", "Color",[0.8500 0.3250 0.0980]) %y=1/3s airfoil
        hold on
            plot(Green_Airfoil_Sorted_Data_Smoothed(1,:),Green_Airfoil_Sorted_Data_Smoothed(2,:),".","Color",[0.4660 0.6740 0.1880]) %y=2/3s airfoil
        %Setting axis limits 
            xlim([xMin,xMax])
            ylim([yMin,yMax])
        %Updating image aspect ratio to match axis alignment
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        hold on
        %Adding plot grid
            grid on; grid minor;
            ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("x-coord [mm]")
            ylabel("y-coord [mm]")
            title("Smoothed Extracted Data Points")
    subplot(2,2,2)
            plot(Blue_Airfoil_Sorted_Data_Smoothed(1,:),Blue_Airfoil_Sorted_Data_Smoothed(2,:), "linewidth", 1, "Color",[0 0.4470 0.7410]) %y=0 airfoil
        hold on
            plot(Orange_Airfoil_Sorted_Data_Smoothed(1,:),Orange_Airfoil_Sorted_Data_Smoothed(2,:), "linewidth", 1, "Color",[0.8500 0.3250 0.0980]) %y=1/3s airfoil
        hold on
            plot(Green_Airfoil_Sorted_Data_Smoothed(1,:),Green_Airfoil_Sorted_Data_Smoothed(2,:), "linewidth", 1, "Color",[0.4660 0.6740 0.1880]) %y=2/3s airfoil
        %Setting axis limits 
            xlim([xMin,xMax])
            ylim([yMin,yMax])
        %Updating image aspect ratio to match axis alignment
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        hold on
        %Adding plot grid
            grid on; grid minor;
            ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("x-coord [mm]")
            ylabel("y-coord [mm]")
            title("Reconstructed Airfoils with Smoothed Data")

writematrix(Blue_Airfoil_Sorted_Data_Smoothed',"BlueAirfoil.txt")

%% JPEG compared to final data

 subplot(2,1,1)
        image(xlims, ylims, Airfoil_Image)
        % Updating image aspect ratio of matlab figure to match axis alignment with JPEG photo
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        % Adding a grid to the image 
            grid on; 
            % grid minor; ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; 
            set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("x-coord [mm]")
            ylabel("y-coord [mm]")
            title("JPEG Image")
    subplot(2,1,2)
            plot(Blue_Airfoil_Sorted_Data_Smoothed(1,:),Blue_Airfoil_Sorted_Data_Smoothed(2,:), "linewidth", 1, "Color",[0 0.4470 0.7410]) %y=0 airfoil
        hold on
            plot(Orange_Airfoil_Sorted_Data_Smoothed(1,:),Orange_Airfoil_Sorted_Data_Smoothed(2,:), "linewidth", 1, "Color",[0.8500 0.3250 0.0980]) %y=1/3s airfoil
        hold on
            plot(Green_Airfoil_Sorted_Data_Smoothed(1,:),Green_Airfoil_Sorted_Data_Smoothed(2,:), "linewidth", 1, "Color",[0.4660 0.6740 0.1880]) %y=2/3s airfoil
        %Setting axis limits 
            xlim([xMin,xMax])
            ylim([yMin,yMax])
        %Updating image aspect ratio to match axis alignment
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        hold on
        %Adding plot grid
            grid on; 
            % grid minor;ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; 
            set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("x-coord [mm]")
            ylabel("y-coord [mm]")
            title("Reconstructed Airfoils with Smoothed Data")
%% Individual Plotting
    % Opening raw image jpeg
        figure
            image(xlims, ylims, Airfoil_Image)
        % Updating image aspect ratio of matlab figure to match axis alignment with JPEG photo
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        % Adding a grid to the image 
            grid on; grid minor; ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("X-Coordinates [mm]")
            ylabel("Y-Coordinates [mm]")
            title("JPEG Image of Airfoils with Added Grid")

    % Plotting raw extracted data points 
        figure
            plot(Blue_Airfoil_Sorted_Data_Raw(1,:),Blue_Airfoil_Sorted_Data_Raw(2,:),".", "Color",[0 0.4470 0.7410]) %y=0 airfoil
        hold on 
            plot(Orange_Airfoil_Sorted_Data_Raw(1,:),Orange_Airfoil_Sorted_Data_Raw(2,:),".","Color",[0.8500 0.3250 0.0980]) %y=1/3s airfoil
        hold on
            plot(Green_Airfoil_Sorted_Data_Raw(1,:),Green_Airfoil_Sorted_Data_Raw(2,:),".","Color",[0.4660 0.6740 0.1880]) %y=2/3s airfoil
        %Setting axis limits 
            xlim([xMin,xMax])
            ylim([yMin,yMax])
        %Updating image aspect ratio to match axis alignment
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        hold on
        %Adding plot grid
            grid on; grid minor;
            ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("X-Coordinates [mm]")
            ylabel("Y-Coordinates [mm]")
            title("Reconstructed Airfoil Coordinates from Raw Extracted Data Points")

    % Plotting Smoothed Data
        figure
            plot(Blue_Airfoil_Sorted_Data_Smoothed(1,:),Blue_Airfoil_Sorted_Data_Smoothed(2,:),".", "Color",[0 0.4470 0.7410]) %y=0 airfoil
        hold on
            plot(Orange_Airfoil_Sorted_Data_Smoothed(1,:),Orange_Airfoil_Sorted_Data_Smoothed(2,:),".", "Color",[0.8500 0.3250 0.0980]) %y=1/3s airfoil
        hold on
            plot(Green_Airfoil_Sorted_Data_Smoothed(1,:),Green_Airfoil_Sorted_Data_Smoothed(2,:),".","Color",[0.4660 0.6740 0.1880]) %y=2/3s airfoil
        %Setting axis limits 
            xlim([xMin,xMax])
            ylim([yMin,yMax])
        %Updating image aspect ratio to match axis alignment
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        hold on
        %Adding plot grid
            grid on; grid minor;
            ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("X-Coordinates [mm]")
            ylabel("Y-Coordinates [mm]")
            title("Reconstructed Airfoil Coordinates from Smoothed Extracted Data Points")

    % Plotting Finalized Airfoils from extraction process
        figure
            plot(Blue_Airfoil_Sorted_Data_Smoothed(1,:),Blue_Airfoil_Sorted_Data_Smoothed(2,:), "Color",[0 0.4470 0.7410]) %y=0 airfoil
        hold on
            plot(Orange_Airfoil_Sorted_Data_Smoothed(1,:),Orange_Airfoil_Sorted_Data_Smoothed(2,:), "Color",[0.8500 0.3250 0.0980]) %y=1/3s airfoil
        hold on
            plot(Green_Airfoil_Sorted_Data_Smoothed(1,:),Green_Airfoil_Sorted_Data_Smoothed(2,:),"Color",[0.4660 0.6740 0.1880]) %y=2/3s airfoil
        %Setting axis limits 
            xlim([xMin,xMax])
            ylim([yMin,yMax])
        %Updating image aspect ratio to match axis alignment
            daspect([1, ((abs(yMax) + abs(yMin))/529) * (1518/(abs(xMax) + abs(xMin))), 1])
        hold on
        %Adding plot grid
            grid on; grid minor;
            ax = gca; ax.GridLineWidth = 2; ax.GridLineStyle = "-"; ax.GridAlpha = 1; ax.GridColor = "k"; set(gca,"YDir","normal");
        %Adding axis labels and title
            xlabel("X-Coordinates [mm]")
            ylabel("Y-Coordinates [mm]")
            title("Final Reconstructed Airfoils with Smoothed Data")