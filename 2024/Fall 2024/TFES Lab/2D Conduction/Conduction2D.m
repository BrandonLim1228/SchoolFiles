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
    delta = 15.24/320; %length and height of a single pixel in cm
    k = 152; %Conduction heat transfer coeffcient for aluminium T6-6061 W/mK
    t = 0.318; %cm, thickness of plate
    error = 1000;
    lamda = 1.2;

%Parsing Data
    Tdata = readmatrix("Section09.csv"); %Reading in CSV file of data
    Tdata = flipud(Tdata);
    [M,N] = size(Tdata); %Finding data size
    L = delta * N; %Calculating Image length from data
    H = delta * M; %Calculating Image height from data
    x = linspace(0,L,N);
    y = linspace(0,H,M)';

%Plotting contour 
    contourf(x,y,Tdata,20);
    colorbar;
    xlabel("Plate Length [cm]")
    ylabel("Plate Height [cm]")
    title("Contour Plot of Measured Temperatures for the Hot Plate")
    close all

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
            qR_Flux(i) = -k * ((3*Tdata(i,N) - 4*Tdata(i,N-1) - Tdata(i,N-2))/(2*delta));
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
            qT_Flux(i) = -k * ((3*Tdata(M,i) - 4*Tdata(M-1,i) - Tdata(M-2,i))/(2*delta));
        end
    %Trapezoidal rule to integrate heat flux to find heat transfer
        qT = t * (delta/2) * (qT_Flux(1) + 2*sum(qT_Flux(2:end-1)) + qT_Flux(end));

%Creating Boundary Conditions
    T = ones(M,N); %Creating empty matrix for temperature values
    T(:,1) = Tdata(:,1); %Setting left edge measured temperatures to left edge boundary conditions
    T(M,:) = Tdata(M,:); %Setting top edge measured tempreratures to top edge boundary conditions
    T(:,N) = Tdata(:,N); %Setting right edge measured temperatures to right edge bounary conditions

    while error >= 1.5*10^-5
        for i = 1:M-1
            for j = 2:N-1
                Told(i,j) = T(i,j);
                if i == 1
                    T(1,j) = 0.25 * (T(1,j-1) + 2*T(2,j) + T(1,j+1)); %Calculating Bottom Boundary Condition
                else 
                    T(i,j) = 0.25 * (T(i,j-1) + T(i,j+1) + T(i-1,j) + T(i+1,j)); %Caculating Inner Nodes
                    T(i,j) = lamda * T(i,j) + ( 1 - lamda) * Told(i,j);
                end
            end
        end
        error = abs(T(i,j) - Told(i,j))/T(i,j)
    end

    contourf(x,y,T,20)