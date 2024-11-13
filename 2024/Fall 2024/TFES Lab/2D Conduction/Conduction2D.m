%--------------------------------------------------------------------------
% TFES Lab ME EN 4650
%
% 2D Conduction - Data Analysis
%
% Brandon Lim
% 11/12/24
%--------------------------------------------------------------------------
clear, clc, close all

%Lab Parameters
k = 1.52; %Conduction heat transfer coeffcient for aluminium T6-6061 W/cmK
t = 0.318; %cm, thickness of plate
error = 1000;
lamda = 1.5;

%Parsing Data
Tdata = readmatrix("Section09.csv"); %Reading in CSV file of data
Tdata = flipud(Tdata);
Tdata = Tdata(:,7:end-7);
[M,N] = size(Tdata); %Finding data size
delta = 15.24/N; %length and height of a single pixel in cm
L = delta * N; %Calculating Image length from data
H = delta * M; %Calculating Image height from data
x = linspace(0,L,N);
y = linspace(0,H,M)';

%Plotting contour
figure
contourf(x,y,Tdata,20);
colorbar;
xlabel("Plate Length [cm]")
ylabel("Plate Height [cm]")
title("Contour Plot of Measured Temperatures for the Hot Plate")

%Creating Boundary Conditions
T = zeros(M,N); %Creating empty matrix for temperature values
T(:,1) = Tdata(:,1); %Setting left edge measured temperatures to left edge boundary conditions
T(end,:) = Tdata(end,:); %Setting top edge measured tempreratures to top edge boundary conditions
T(:,end) = Tdata(:,end); %Setting right edge measured temperatures to right edge bounary conditions

%Numerically solving for the temperatures in the plate interior using gaus siedel
while error >= 1.5*10^-5
    Told = T;
    for i = 1:M-1
        for j = 2:N-1
            if i == 1
                T(1,j) = 0.25 * (T(1,j-1) + 2*T(2,j) + T(1,j+1)); %Calculating Bottom Boundary Condition
            else
                T(i,j) = 0.25 * (T(i,j-1) + T(i,j+1) + T(i-1,j) + T(i+1,j)); %Caculating Inner Nodes
                T(i,j) = lamda * T(i,j) + ( 1 - lamda) * Told(i,j); %Relaxation factor
            end
        end
    end
    error = max(max(abs(T-Told)./T)); %Calculating error
end
%Plotting numerical simulation data
figure
contourf(x,y,T,20)
colorbar;
%Adding axis label and titles
xlabel("Plate Length [cm]")
ylabel("Plate Height [cm]")
title("Contour Plot of Numerical Simulation Temperatures for the Hot Plate")

%Calculating error between measured and numerical data
for i = 1:M
    for j = 1:N
        error_pd(i,j) = (abs(Tdata(i,j) - T(i,j))/Tdata(i,j)) * 100;
    end
end

%Plotting error color countour
figure
contourf(x,y,error_pd,20)
colorbar;
%Adding axis label and titles
xlabel("Plate Length [cm]")
ylabel("Plate Height [cm]")
title("Error Plot of Numerical Simulation Temperatures vs Experimental Measurement Temperatures")

%Plotting edge temperatures
figure
subplot(2,1,1)
plot(x,Tdata(M,:),"r","linewidth",1) %Temperature along top edge
hold on
plot(x,ones(size(x))*mean(Tdata(M,:)),"--r","linewidth",1) %Mean top edge temperature
hold on
plot(x,Tdata(1,:),"b","linewidth",1,"linewidth",1) %Temperature along bottom edge
hold on
plot(x,ones(size(x))*mean(Tdata(1,:)),"--b") %mean bottom edge temperature
%Adding axis label and titles
legend("Top Edge Temperatures", "", "Bottom Edge Temperatures", "","Location","eastoutside")
xlabel("Horizontal Distance Along Plate [cm]")
ylabel("Temperature $^oC$","Interpreter","latex")
title("Top and Bottom Edge Temperatures vs Distance along Horizontal")
subplot(2,1,2)
plot(Tdata(:,1),y,"g","linewidth",1) %Temperature along left edge
hold on
plot(ones(size(y))*mean(Tdata(:,1)),y,"--g","linewidth",1) %mean left edge temperature
hold on
plot(Tdata(:,end),y,"k","linewidth",1,"linewidth",1) %Temperature along right edge
hold on
plot(ones(size(y))*mean(Tdata(:,end)),y,"--k") %mean right edge temperature
%Adding axis label and titles
legend("Left Edge Temperatures", "", "Right Edge Temperatures", "","Location","eastoutside")
ylabel("Vertical Distance Along Plate [cm]")
xlabel("Temperature $^oC$","Interpreter","latex")
title("Left and Right Edge Temperatures vs Distance along Vertical")

%Calculating heat transfer on the left edge of the plate
%Forward Finite Different for Heat flux across left edge of the plate
for i = 1:M
    qL_Flux(i) = -k * ((-Tdata(i,3) + 4*Tdata(i,2) - 3*Tdata(i,1))/(2*delta));
end
%Trapezoidal rule to integrate heat flux to find heat transfer
qL = t * (delta/2) * (qL_Flux(1) + 2*sum(qL_Flux(2:end-1)) + qL_Flux(end));

%Calculating heat transfer on the right edge of the plate
%Backward Finite Different for Heat flux across right edge of the plate
for i = 1:M
    qR_Flux(i) = -k * ((3*Tdata(i,N) - 4*Tdata(i,N-1) + Tdata(i,N-2))/(2*delta));
end
%Trapezoidal rule to integrate heat flux to find heat transfer
qR = t * (delta/2) * (qR_Flux(1) + 2*sum(qR_Flux(2:end-1)) + qR_Flux(end));

%Calculating heat transfer on the bottom edge of the plate
%Forward Finite Different for Heat flux across bottom edge of the plate
for i = 1:N
    qB_Flux(i) = -k * ((-Tdata(3,i) + 4*Tdata(2,i) - 3*Tdata(1,i))/(2*delta));
end
%Trapezoidal rule to integrate heat flux to find heat transfer
qB = t * (delta/2) * (qB_Flux(1) + 2*sum(qB_Flux(2:end-1)) + qB_Flux(end));

%Calculating heat transfer on the top edge of the plate
%Backward Finite Different for Heat flux across top edge of the plate
for i = 1:N
    qT_Flux(i) = -k * ((3*Tdata(M,i) - 4*Tdata(M-1,i) + Tdata(M-2,i))/(2*delta));
end
%Trapezoidal rule to integrate heat flux to find heat transfer
qT = t * (delta/2) * (qT_Flux(1) + 2*sum(qT_Flux(2:end-1)) + qT_Flux(end));

%% Post lab calculations
%Average error between numerical and real values
ave_error = mean(error_pd)
ave_error_ave = mean(ave_error)
%Finding max error location
[row,col] = find(error_pd == max(error_pd,[],"all"))
x(1,290)
y(9,1)
%Finding uniformity in edge temperatures
TLdiff = (2*std(Tdata(:,1))/mean(Tdata(:,1))) * 100
TTdiff = (2*std(Tdata(end,:))/mean(Tdata(end,:))) * 100
TRdiff = (2*std(Tdata(:,end))/mean(Tdata(:,end))) * 100
TBdiff = (2*std(Tdata(1,:))/mean(Tdata(1,:))) * 100


