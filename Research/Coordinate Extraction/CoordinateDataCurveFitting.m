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
clear, clc, close all
format longg

%Reading In Airfoil Data
    Y0_airfoil_data = readmatrix("0_Airfoil.txt");
    Y13s_airfoil_data = readmatrix("033s_Airfoil.txt");
    Y23s_airfoil_data = readmatrix("067s_Airfoil.txt");

%Sepparating data in upper and lower
    %Y0 airfoil
    Y0index_0 = find(Y0_airfoil_data(:,1) == 0); %findig leading edge index
    Y0_Top_Data = Y0_airfoil_data(1:Y0index_0,:);
    Y0_Bot_Data = Y0_airfoil_data(Y0index_0:end,:);

%Fitting curves to the airfoil
    size = length(Y0_Top_Data(:,1))
    weights = [20, ones(1,size-2), 10] 
    f = fit(Y0_Top_Data(:,1),Y0_Top_Data(:,2),'poly5','Weights',weights)
    pY0_Top4 = polyfit(Y0_Top_Data(:,1),Y0_Top_Data(:,2),4);
    pY0_Top5 = polyfit(Y0_Top_Data(:,1),Y0_Top_Data(:,2),5);
    pY0_Top6 = polyfit(Y0_Top_Data(:,1),Y0_Top_Data(:,2),6);

    pY0_Bot4 = polyfit(Y0_Bot_Data(:,1),Y0_Bot_Data(:,2),4);
    pY0_Bot5 = polyfit(Y0_Bot_Data(:,1),Y0_Bot_Data(:,2),5);
    pY0_Bot6 = polyfit(Y0_Bot_Data(:,1),Y0_Bot_Data(:,2),6);

    x = linspace(0,330,1000);

    y4T = pY0_Bot4(1) .* x.^4 + pY0_Bot4(2) .* x.^3 + pY0_Bot4(3) .* x.^2 + pY0_Bot4(4) .* x + pY0_Bot4(5);
    y5T = pY0_Bot5(1) .* x.^5 + pY0_Bot5(2) .* x.^4 + pY0_Bot5(3) .* x.^3 + pY0_Bot5(4) .* x.^2 + pY0_Bot5(5) .* x + pY0_Bot5(6);
    y6T = pY0_Top6(1) .* x.^6 + pY0_Top6(2) .* x.^5 + pY0_Top6(3) .* x.^4 + pY0_Top6(4) .* x.^3 + pY0_Top6(5) .* x.^2 + pY0_Top6(6) .* x + pY0_Top6(7);

    y4B = pY0_Top4(1) .* x.^4 + pY0_Top4(2) .* x.^3 + pY0_Top4(3) .* x.^2 + pY0_Top4(4) .* x + pY0_Top4(5);
    y5B = pY0_Top5(1) .* x.^5 + pY0_Top5(2) .* x.^4 + pY0_Top5(3) .* x.^3 + pY0_Top5(4) .* x.^2 + pY0_Top5(5) .* x + pY0_Top5(6);
    y6B = pY0_Bot6(1) .* x.^6 + pY0_Bot6(2) .* x.^5 + pY0_Bot6(3) .* x.^4 + pY0_Bot6(4) .* x.^3 + pY0_Bot6(5) .* x.^2 + pY0_Bot6(6) .* x + pY0_Bot6(7);

    figure
    plot(Y0_Top_Data(:,1),Y0_Top_Data(:,2), "bo")
    hold on
    plot(Y0_Bot_Data(:,1),Y0_Bot_Data(:,2), "bo")
    daspect([1,1,1]); ylim([-100 100])

    hold on
    plot(x,y4T,"g")
    hold on
    plot(x,y5T,"b")
    hold on
    plot(x,y6T,"r")

    hold on
    plot(x,y4B,"g")
    hold on
    plot(x,y5B,"b")
    hold on
    plot(x,y6B,"r")
    hold on
    plot(f, "k")













%%
figure
plot(Y0_Top_Data(:,1),Y0_Top_Data(:,2), "b.")
daspect([1,1,1]); ylim([-100 100])

