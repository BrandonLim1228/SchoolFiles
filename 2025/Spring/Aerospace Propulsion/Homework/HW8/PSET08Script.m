%% Brandon Lim HW8 Script
clear, clc, close all
format longg

% Problem Variables
Mo = 2;
To = 216.65; %k
Po = 11000; %Pa
rp = 15.5;
etaC = 0.85;
etat = 0.9;
LHV = 43; %Mg/kg
FAst = 0.067;
phi = 0.387;
gamma = 1.4;
R = 287; %j/kgK
D = 1.212; %m

%First Oblique Shock
theta1 = 10; %deg
beta1 = 39.32; %deg
%Second Oblique Shock
theta2 = 10; %deg
beta2 = 49.4; %deg

%Calculating Inlet Velocity 
    Uo = Mo.*sqrt(gamma .* R .* To);  %m/s
    Tost = To.*(1+((gamma-1)./2) .* (Mo.^2)); % K
    Post = Po .* (1 + ((gamma-1)./2) .* Mo.^2)^(gamma./(gamma-1)); %Pa

%Calculating Mass Flow Rate
    A = (pi./4) .* D.^2; %m^2
    rho = Po./(R.*To); %kg/m^3
    mDot = rho .* Uo .* A; %kg/s

%Calculating Mach number after first oblique shock
    Mno = Mo .* sind(beta1);
    Mn11 = sqrt((Mno.^2 + (2./(gamma-1)))./(((2.*gamma)./(gamma-1)) .* (Mno.^2)-1));
    M11 = Mn11./(sind(beta1 - theta1));

%Calculating Tst1.1 & Pst1.1
    Tst11 = Tost;
    Pst11 = Post .* (((((gamma+1)./2) .* Mo.^2 .* (sind(beta1)).^2)./(1+((gamma-1)./2) .* Mo.^2 .* (sind(beta1)).^2) ).^(gamma./(gamma-1))) .* ((1./ (((2.*gamma)./(gamma+1)) .* Mo.^2 .* (sind(beta1)).^2 -((gamma-1)./(gamma+1)))).^(1/(gamma-1))); %Pa
    
%Calculating Mach number after second oblique shock
    Mn11n2 = M11 .* sind(beta2);
    Mn12 = sqrt((Mn11n2.^2 + (2./(gamma-1)))./(((2.*gamma)./(gamma-1)) .* (Mn11n2.^2)-1));
    M12 = Mn12 ./ sind(beta2-theta2);

%Calculating Tst1.2 & Pst1.2
    Tst12 = Tst11;
    Pst12 = Pst11 .* (((((gamma+1)./2) .* M11.^2 .* (sind(beta2)).^2)./(1+((gamma-1)./2) .* M11.^2 .* (sind(beta2)).^2) ).^(gamma./(gamma-1))) .* ((1./ (((2.*gamma)./(gamma+1)) .* M11.^2 .* (sind(beta2)).^2 -((gamma-1)./(gamma+1)))).^(1/(gamma-1))) %Pa