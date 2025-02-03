clear, clc, close all
% Importing Data
Y0_airfoil_data = readmatrix("Yequ0_Airfoil_Official.txt");
Y03s_airfoil_data = readmatrix("Yequ03s_Airfoil_Official.txt");
Y06s_airfoil_data = readmatrix("Yequ06s_Airfoil_Official.txt");

% Importing image
Airfoil_Image = flipud(imread("Delta Wing Airfoil Coordinates.jpg"));
xMin = -15.265; xMax = 335.495; xlims = [xMin, xMax];
yMin = -64.45; yMax = 57.65; ylims = [yMin, yMax];

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
plot(Y0_airfoil_data(:,1),Y0_airfoil_data(:,2), "linewidth", 1.5, "Color",[0 0.4470 0.7410], "linestyle", "none", "Marker", ".") %y=0 airfoil
hold on 
plot(Y03s_airfoil_data(:,1),Y03s_airfoil_data(:,2), "linewidth", 1.5, "Color",[0.8500 0.3250 0.0980], "linestyle", "none", "Marker",".") %y=03s airfoil
hold on
plot(Y06s_airfoil_data(:,1),Y06s_airfoil_data(:,2), "linewidth", 1.5, "Color", [0.4660 0.6740 0.1880], "linestyle", "none", "Marker",".") %y=06s airfoil
xlim(xlims);ylim(ylims);
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
title("Reconstructed Airfoil")