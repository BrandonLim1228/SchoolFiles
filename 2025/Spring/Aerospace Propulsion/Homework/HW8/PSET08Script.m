%% Brandon Lim HW8 Script
clear, clc, close all
format longg

% Problem Variables
Mo = 2;
To = 216.65; %k
Po = 11000; %Pa
rp = 15.5;
etaC = 0.85;
etaT = 0.9;
etaN = 1;
LHV = 43 * 10^6; %Mg/kg
FAst = 0.067;
phi = 0.387;
gamma = 1.4;
R = 287; %j/kgK
cv = R/(gamma-1); %J/kgK
cp = gamma*cv; %J/kgK
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
    Pst12 = Pst11 .* (((((gamma+1)./2) .* M11.^2 .* (sind(beta2)).^2)./(1+((gamma-1)./2) .* M11.^2 .* (sind(beta2)).^2) ).^(gamma./(gamma-1))) .* ((1./ (((2.*gamma)./(gamma+1)) .* M11.^2 .* (sind(beta2)).^2 -((gamma-1)./(gamma+1)))).^(1/(gamma-1))); %Pa

%Calculating M2
    M2 = sqrt(((M12.^2) + (2./(gamma-1))) ./ (((2.*gamma)./(gamma-1)) .* (M12.^2) - 1));

%Calculating Tt2 & Pt2
    Tst2 = Tst12;
    Pst2 = Pst12 .* (((((gamma+1)./2) .* (M12.^2)) ./ (1 + ((gamma-1)/2) .* (M12.^2))) .^ (gamma./(gamma-1))) .* ((1 ./ (((2.*gamma)./(gamma + 1)) .* (M12.^2) - ((gamma-1)./(gamma+1)))).^(1./(gamma-1))); 

%State 2 to 3
    Tst3 = Tst2 .* (1 + (1./etaC) .* (rp.^((gamma-1)./gamma)-1)); %K
    Pst3 = rp .* Pst2; %Pa
%State 3 to 4
    Pst4 = Pst3; %Pa
    Tst4 = Tst3 + (phi.*FAst.*LHV)./cp; %K
%State 4 to 5
    Tst5 = Tst4 - (Tst2./etaC) .* ((rp.^((gamma-1)./gamma)) - 1);
    Pst5 = Pst4 .* ((1 - (1./(etaC .* etaT)).*(Tst2./Tst4).*((rp.^((gamma-1)./gamma)) - 1)).^(gamma./(gamma-1)));
%State 5 to 6 (No fuel fed into after burner)
    Tst6 = Tst5;
    Pst6 = Pst5;

%Calculating Exhaust Velocity
    Ve = sqrt(2.*(gamma./(gamma-1)).*etaN.*R.*Tst5.*(1-(Po./Pst5).^((gamma-1)./gamma)));

%Calculating Thrust
    T = mDot .* (Ve - Uo);
%Calculating Propuslive Efficiency
    etaP = (2*Uo)./(Ve + Uo);
%Calculating thrust specific fueld consumption
    mDotf = phi .* FAst .* mDot;
    tsfc = mDotf./T;

%% h
clear, clc, close all
format longg

% Problem Variables
Mo = 2;
To = 216.65; %k
Po = 11000; %Pa
rp = 15.5;
etaC = 0.85;
etaT = 0.9;
etaN = 1;
LHV = 43 * 10^6; %Mg/kg
FAst = 0.067;
phi = 0.387/2;
phiAB = phi;
gamma = 1.4;
R = 287; %j/kgK
cv = R/(gamma-1); %J/kgK
cp = gamma*cv; %J/kgK
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
    Pst12 = Pst11 .* (((((gamma+1)./2) .* M11.^2 .* (sind(beta2)).^2)./(1+((gamma-1)./2) .* M11.^2 .* (sind(beta2)).^2) ).^(gamma./(gamma-1))) .* ((1./ (((2.*gamma)./(gamma+1)) .* M11.^2 .* (sind(beta2)).^2 -((gamma-1)./(gamma+1)))).^(1/(gamma-1))); %Pa

%Calculating M2
    M2 = sqrt(((M12.^2) + (2./(gamma-1))) ./ (((2.*gamma)./(gamma-1)) .* (M12.^2) - 1));

%Calculating Tt2 & Pt2
    Tst2 = Tst12;
    Pst2 = Pst12 .* (((((gamma+1)./2) .* (M12.^2)) ./ (1 + ((gamma-1)/2) .* (M12.^2))) .^ (gamma./(gamma-1))) .* ((1 ./ (((2.*gamma)./(gamma + 1)) .* (M12.^2) - ((gamma-1)./(gamma+1)))).^(1./(gamma-1))); 

%State 2 to 3
    Tst3 = Tst2 .* (1 + (1./etaC) .* (rp.^((gamma-1)./gamma)-1)); %K
    Pst3 = rp .* Pst2; %Pa
%State 3 to 4
    Pst4 = Pst3; %Pa
    Tst4 = Tst3 + (phi.*FAst.*LHV)./cp; %K
%State 4 to 5
    Tst5 = Tst4 - (Tst2./etaC) .* ((rp.^((gamma-1)./gamma)) - 1);
    Pst5 = Pst4 .* ((1 - (1./(etaC .* etaT)).*(Tst2./Tst4).*((rp.^((gamma-1)./gamma)) - 1)).^(gamma./(gamma-1)));
%State 5 to 6 (No fuel fed into after burner)
    Tst6 = Tst5 + ((phiAB.*FAst.*LHV)./cp);
    Pst6 = Pst5;

%Calculating Exhaust Velocity
    Ve = sqrt(2.*(gamma./(gamma-1)).*etaN.*R.*Tst6.*(1-(Po./Pst5).^((gamma-1)./gamma)));

%Calculating Thrust
    T = mDot .* (Ve - Uo);
%Calculating Propuslive Efficiency
    etaP = (2*Uo)./(Ve + Uo);
%Calculating thrust specific fueld consumption
    mDotf = phi*2 .* FAst .* mDot;
    tsfc = mDotf./T;

%% i
clear, clc, close all
format longg

% Problem Variables
Mo = 2;
To = 216.65; %k
Po = 11000; %Pa
rp = 15.5;
etaC = 0.85;
etaT = 0.9;
etaN = 1;
LHV = 43 * 10^6; %Mg/kg
FAst = 0.067;
phi = 0.387.*linspace(1,0,100);
phiAB = 0.387.*linspace(0,1,100);
gamma = 1.4;
R = 287; %j/kgK
cv = R/(gamma-1); %J/kgK
cp = gamma*cv; %J/kgK
D = 1.212; %m
PF = 0.25;

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
    Pst12 = Pst11 .* (((((gamma+1)./2) .* M11.^2 .* (sind(beta2)).^2)./(1+((gamma-1)./2) .* M11.^2 .* (sind(beta2)).^2) ).^(gamma./(gamma-1))) .* ((1./ (((2.*gamma)./(gamma+1)) .* M11.^2 .* (sind(beta2)).^2 -((gamma-1)./(gamma+1)))).^(1/(gamma-1))); %Pa

%Calculating M2
    M2 = sqrt(((M12.^2) + (2./(gamma-1))) ./ (((2.*gamma)./(gamma-1)) .* (M12.^2) - 1));

%Calculating Tt2 & Pt2
    Tst2 = Tst12;
    Pst2 = Pst12 .* (((((gamma+1)./2) .* (M12.^2)) ./ (1 + ((gamma-1)/2) .* (M12.^2))) .^ (gamma./(gamma-1))) .* ((1 ./ (((2.*gamma)./(gamma + 1)) .* (M12.^2) - ((gamma-1)./(gamma+1)))).^(1./(gamma-1))); 

%State 2 to 3
    Tst3 = Tst2 .* (1 + (1./etaC) .* (rp.^((gamma-1)./gamma)-1)); %K
    Pst3 = rp .* Pst2; %Pa
%State 3 to 4
    Pst4 = Pst3; %Pa
    Tst4 = Tst3 + (phi.*FAst.*LHV)./cp; %K
%State 4 to 5
    Tst5 = Tst4 - (Tst2./etaC) .* ((rp.^((gamma-1)./gamma)) - 1);
    Pst5 = Pst4 .* ((1 - (1./(etaC .* etaT)).*(Tst2./Tst4).*((rp.^((gamma-1)./gamma)) - 1)).^(gamma./(gamma-1)));
%State 5 to 6 (No fuel fed into after burner)
    Tst6 = Tst5 + ((phiAB.*FAst.*LHV)./cp);
    Pst6 = Pst5;

%Calculating Exhaust Velocity
    Ve = sqrt(2.*(gamma./(gamma-1)).*etaN.*R.*Tst6.*(1-(Po./Pst5).^((gamma-1)./gamma)));

%Calculating Thrust
    T = mDot .* (Ve - Uo);
%Calculating Propuslive Efficiency
    etaP = (2*Uo)./(Ve + Uo);
%Calculating thrust specific fueld consumption
    mDotf = 0.387.* FAst .* mDot;
    tsfc = mDotf./T;

figure
plot(linspace(0,1,100).*100, T)
title("Afterburner Fuel Percentage vs Thrust"); xlabel("After-burner Fuel Percentage [%]"); ylabel("Thrust [N]")

figure 
plot(linspace(0,1,100).*100, etaP)
title("Afterburner Fuel Percentage vs Propulsive Efficiency"); xlabel("After-burner Fuel Percentage [%]"); ylabel("Propulsive Efficiency")

figure 
plot(linspace(0,1,100).*100,tsfc)
title("Afterburner Fuel Percentage vs Thrust Specific Fuel Consumption"); xlabel("After-burner Fuel Percentage [%]"); ylabel("Thrust Specific Fuel Consumption[N-kg/s]")

figure 
plot(linspace(0,1,100).*100,Tst4)
title("Afterburner Fuel Percentage vs Stagnation Temperature at State 4"); xlabel("After-burner Fuel Percentage [%]"); ylabel("Stagnation Temperature at State 4 [K]")

figure 
plot(linspace(0,1,100).*100,Tst6)
title("Afterburner Fuel Percentage vs Stagnation Temperature at State 6"); xlabel("After-burner Fuel Percentage [%]"); ylabel("Stagnation Temperature at State 6 [K]")

TtMax = PF* (1750-Tst3) + 1750;

TstMax = PF .* (Tst4 - Tst3) + Tst4;

figure 
plot(linspace(0,1,100).*100,TstMax)
title("Afterburner Fuel Percentage vs Max Stagnation Temperature"); xlabel("After-burner Fuel Percentage [%]"); ylabel("Max Stagnation Temperature [K]")

Tt4_tmax = (1750+(Tst3*PF))/(PF+1)
%% Problem 2
clear, clc, close all
format longg

% Problem Variables
Mo = linspace(2,4.5,100);
To = 216.65; %k
Po = 11000; %Pa
rp = 15.5;
etaC = 0.85;
etaT = 0.9;
etaN = 1;
LHV = 43 * 10^6; %Mg/kg
FAst = 0.067;
phi = 0.387;
gamma = 1.4;
R = 287; %j/kgK
cv = R/(gamma-1); %J/kgK
cp = gamma*cv; %J/kgK
D = 1.212; %m

%First Oblique Shock
theta1 = 10; %deg
beta1 = -1.556.*Mo.^3 + 18.66.*Mo.^2 -77.21.*Mo + 132.5; %deg
%Second Oblique Shock
theta2 = 10; %deg

%Calculating Inlet Velocity 
    Uo = Mo.*sqrt(gamma .* R .* To);  %m/s
    Tost = To.*(1+((gamma-1)./2) .* (Mo.^2)); % K
    Post = Po .* (1 + ((gamma-1)./2) .* Mo.^2).^(gamma./(gamma-1)); %Pa

%Calculating Mass Flow Rate
    A = (pi./4) .* D.^2; %m^2
    rho = Po./(R.*To); %kg/m^3
    mDot = rho .* Uo .* A; %kg/s

%Calculating Mach number after first oblique shock
    Mno = Mo .* sind(beta1);
    Mn11 = sqrt((Mno.^2 + (2./(gamma-1)))./(((2.*gamma)./(gamma-1)) .* (Mno.^2)-1));
    M11 = Mn11./(sind(beta1 - theta1));
    beta2 = -1.556.*M11.^3 + 18.66.*M11.^2 -77.21.*M11 + 132.5; %deg

%Calculating Tst1.1 & Pst1.1
    Tst11 = Tost;
    Pst11 = Post .* (((((gamma+1)./2) .* Mo.^2 .* (sind(beta1)).^2)./(1+((gamma-1)./2) .* Mo.^2 .* (sind(beta1)).^2) ).^(gamma./(gamma-1))) .* ((1./ (((2.*gamma)./(gamma+1)) .* Mo.^2 .* (sind(beta1)).^2 -((gamma-1)./(gamma+1)))).^(1/(gamma-1))); %Pa
    
%Calculating Mach number after second oblique shock
    Mn11n2 = M11 .* sind(beta2);
    Mn12 = sqrt((Mn11n2.^2 + (2./(gamma-1)))./(((2.*gamma)./(gamma-1)) .* (Mn11n2.^2)-1));
    M12 = Mn12 ./ sind(beta2-theta2);

%Calculating Tst1.2 & Pst1.2
    Tst12 = Tst11;
    Pst12 = Pst11 .* (((((gamma+1)./2) .* M11.^2 .* (sind(beta2)).^2)./(1+((gamma-1)./2) .* M11.^2 .* (sind(beta2)).^2) ).^(gamma./(gamma-1))) .* ((1./ (((2.*gamma)./(gamma+1)) .* M11.^2 .* (sind(beta2)).^2 -((gamma-1)./(gamma+1)))).^(1/(gamma-1))); %Pa

%Calculating M2
    M2 = sqrt(((M12.^2) + (2./(gamma-1))) ./ (((2.*gamma)./(gamma-1)) .* (M12.^2) - 1));

%Calculating Tt2 & Pt2
    Tst2 = Tst12;
    Pst2 = Pst12 .* (((((gamma+1)./2) .* (M12.^2)) ./ (1 + ((gamma-1)/2) .* (M12.^2))) .^ (gamma./(gamma-1))) .* ((1 ./ (((2.*gamma)./(gamma + 1)) .* (M12.^2) - ((gamma-1)./(gamma+1)))).^(1./(gamma-1))); 

%State 2 to 3
    Tst3 = Tst2 .* (1 + (1./etaC) .* (rp.^((gamma-1)./gamma)-1)); %K
    Pst3 = rp .* Pst2; %Pa
%State 3 to 4
    Pst4 = Pst3; %Pa
    Tst4 = Tst3 + (phi.*FAst.*LHV)./cp; %K
%State 4 to 5
    Tst5 = Tst4 - (Tst2./etaC) .* ((rp.^((gamma-1)./gamma)) - 1);
    Pst5 = Pst4 .* ((1 - (1./(etaC .* etaT)).*(Tst2./Tst4).*((rp.^((gamma-1)./gamma)) - 1)).^(gamma./(gamma-1)));
%State 5 to 6 (No fuel fed into after burner)
    Tst6 = Tst5;
    Pst6 = Pst5;

%Calculating Exhaust Velocity
    Ve = sqrt(2.*(gamma./(gamma-1)).*etaN.*R.*Tst5.*(1-(Po./Pst5).^((gamma-1)./gamma)));

%Calculating Thrust
    T = mDot .* (Ve - Uo);
%Calculating Propuslive Efficiency
    etaP = (2*Uo)./(Ve + Uo);
%Calculating thrust specific fueld consumption
    mDotf = phi .* FAst .* mDot;
    tsfc = mDotf./T;

figure
plot(linspace(2,4.5,100), T)
title("Mach Number vs Thrust"); xlabel("Mach Number"); ylabel("Thrust [N]")

figure
plot(linspace(2,4.5,100), tsfc)
title("Mach Number vs Thrust Specific Fuel Consumption"); xlabel("Mach Number"); ylabel("Thrust Specific Fuel Consumption [N-kg/s]")


PtwoPone = (Pst2.*(1+ ((gamma-1)/2).*Mo.^2).^(gamma/(gamma-1)))./(Post.*(1+ ((gamma-1)/2).*M2.^2).^(gamma/(gamma-1)));

figure
plot(linspace(2,4.5,100), PtwoPone)
title("Mach Number vs Compression from Shock Waves"); xlabel("Mach Number"); ylabel("Compression from Shock Waves [P2/P1]")

%% Problem 3
clear, clc, close all
format longg

% Problem Variables
Mo = linspace(2,4.5,100);
To = 216.65; %k
Po = 11000; %Pa
rp = 15.5;
etaC = 0.85;
etaT = 0.9;
etaN = 1;
LHV = 43 * 10^6; %Mg/kg
FAst = 0.067;
phi = 0.387;
gamma = 1.4;
R = 287; %j/kgK
cv = R/(gamma-1); %J/kgK
cp = gamma*cv; %J/kgK
D = 1.212; %m

%First Oblique Shock
theta1 = 10; %deg
beta1 = -1.556.*Mo.^3 + 18.66.*Mo.^2 -77.21.*Mo + 132.5; %deg
%Second Oblique Shock
theta2 = 10; %deg

%Calculating Inlet Velocity 
    Uo = Mo.*sqrt(gamma .* R .* To);  %m/s
    Tost = To.*(1+((gamma-1)./2) .* (Mo.^2)); % K
    Post = Po .* (1 + ((gamma-1)./2) .* Mo.^2).^(gamma./(gamma-1)); %Pa

%Calculating Mass Flow Rate
    A = (pi./4) .* D.^2; %m^2
    rho = Po./(R.*To); %kg/m^3
    mDot = rho .* Uo .* A; %kg/s

%Calculating Mach number after first oblique shock
    Mno = Mo .* sind(beta1);
    Mn11 = sqrt((Mno.^2 + (2./(gamma-1)))./(((2.*gamma)./(gamma-1)) .* (Mno.^2)-1));
    M11 = Mn11./(sind(beta1 - theta1));
    beta2 = -1.556.*M11.^3 + 18.66.*M11.^2 -77.21.*M11 + 132.5; %deg

%Calculating Tst1.1 & Pst1.1
    Tst11 = Tost;
    Pst11 = Post .* (((((gamma+1)./2) .* Mo.^2 .* (sind(beta1)).^2)./(1+((gamma-1)./2) .* Mo.^2 .* (sind(beta1)).^2) ).^(gamma./(gamma-1))) .* ((1./ (((2.*gamma)./(gamma+1)) .* Mo.^2 .* (sind(beta1)).^2 -((gamma-1)./(gamma+1)))).^(1/(gamma-1))); %Pa
    
%Calculating Mach number after second oblique shock
    Mn11n2 = M11 .* sind(beta2);
    Mn12 = sqrt((Mn11n2.^2 + (2./(gamma-1)))./(((2.*gamma)./(gamma-1)) .* (Mn11n2.^2)-1));
    M12 = Mn12 ./ sind(beta2-theta2);

%Calculating Tst1.2 & Pst1.2
    Tst12 = Tst11;
    Pst12 = Pst11 .* (((((gamma+1)./2) .* M11.^2 .* (sind(beta2)).^2)./(1+((gamma-1)./2) .* M11.^2 .* (sind(beta2)).^2) ).^(gamma./(gamma-1))) .* ((1./ (((2.*gamma)./(gamma+1)) .* M11.^2 .* (sind(beta2)).^2 -((gamma-1)./(gamma+1)))).^(1/(gamma-1))); %Pa

%Calculating M2
    M2 = sqrt(((M12.^2) + (2./(gamma-1))) ./ (((2.*gamma)./(gamma-1)) .* (M12.^2) - 1));

%Calculating Tt2 & Pt2
    Tst2 = Tst12;
    Pst2 = Pst12 .* (((((gamma+1)./2) .* (M12.^2)) ./ (1 + ((gamma-1)/2) .* (M12.^2))) .^ (gamma./(gamma-1))) .* ((1 ./ (((2.*gamma)./(gamma + 1)) .* (M12.^2) - ((gamma-1)./(gamma+1)))).^(1./(gamma-1))); 

%State 5 to 6 (No fuel fed into after burner)
    Tst6 = Tst2 + ((phi.*FAst.*LHV)./cp);
    Pst6 = Pst2;

%Calculating Exhaust Velocity
    Ve = sqrt(2.*(gamma./(gamma-1)).*etaN.*R.*Tst6.*(1-(Po./Pst2).^((gamma-1)./gamma)));

%Calculating Thrust
    T = mDot .* (Ve - Uo);
%Calculating Propuslive Efficiency
    etaP = (2*Uo)./(Ve + Uo);
%Calculating thrust specific fueld consumption
    mDotf = phi .* FAst .* mDot;
    tsfc = mDotf./T;

figure
plot(linspace(2,4.5,100), T)
title("Mach Number vs Thrust"); xlabel("Mach Number"); ylabel("Thrust [N]")

figure
plot(linspace(2,4.5,100), tsfc)
title("Mach Number vs Thrust Specific Fuel Consumption"); xlabel("Mach Number"); ylabel("Thrust Specific Fuel Consumption [N-kg/s]")