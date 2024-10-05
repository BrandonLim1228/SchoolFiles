%--------------------------------------------------------------------------
% TFES Lab ME EN 4650
%
% Flow around a circular cylinder - Data Analysis
%
% Required Plots:
%   1a. Plot the mean horizontal velocity in the wake vurses y/D
%   1b. Plot the horizontal turblunece intesnity vurses y/D
%   1c. Plot the pressure coefficient versus angular poistion 
%   1d. Plot Cd vs ReD for published results, cylinder static pressure measurments, and analyis of conservation of mass and momentum
%
% Brandon Lim
% 10/2/24
%--------------------------------------------------------------------------

clear, clc, close all

% Experimental Conditions
    WindTunnelFrequency = 20; %Hz
    Patm = 854 * 100; %Pa
    Tatm = 22.1; %C

% Parsing Data that was taken in the lab
    % define array of polar angles examined in the experiment
        theta = [0:5:90,100:20:180];
    % total number of data files collected
        N_theta = length(theta);
    % create arrays to store the mean and standard deviation
        pmean = zeros(size(theta));
        pstd = zeros(size(theta));
    % loop through all data files
        for (i=1:N_theta)
            % filename of ith file
                FileName=['Pcyl_deg',num2str(theta(i)),'.csv'];
            % read in data from the file
                data = readmatrix(FileName);
            % calculate mean and std
                pmean(i) = mean(data);
                pstd(i) = std(data);
        end

% 
  
