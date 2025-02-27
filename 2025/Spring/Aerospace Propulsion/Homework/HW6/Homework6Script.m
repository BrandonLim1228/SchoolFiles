%Brandon Lim, PSET06 Aerospace Propulsion
clear, clc, close all
format longg

%Fluid properties
gamma = 1.4;
R = 287; %J/kgK
cv = R/(gamma-1); %J/kgK
cp = gamma*cv; %J/kgK
%Inital Fluid States
To = 216.65; %Kelvin
Po = 21.4*1000; %Pascals
Mo = 0.78;
%Efficiencies
etaD = 1;
etaf = 0.95;
etaC = 0.95;
etaHPT = 0.9;
etaLPT = etaHPT;
etaNC = 1;
etaNBP = 1;
%Mechanical Ratios
rf = 1.5;
rp = 60;
BPR = 12.5;
%Fuel Properties
mFuel = 12*12.01 + 26*1.008;
mO2 = 2*16;
mN2 = 2*14.01;
nFuel = 1;
nO2 = 18.5;
nN2 = 3.76*18.5;
rFAst = (nFuel*mFuel)/(nO2*mO2 + nN2*mN2);
phi = 0.25;
LHV = 42.8*10^6; %J/kgK

%State 1 & 2
Tt2 = To*(1+((gamma-1)/2) * (Mo^2)); % K
Tto = Tt2; % Kelvin
Pt2 = Po * (1 + etaD * ((gamma-1)/2) * Mo^2)^(gamma/(gamma-1)); %Pa
Pto = (Pt2 * (1+((gamma-1)/2) * Mo^2)^((gamma)/(gamma-1))) / ((1+((gamma-1)/2) * Mo^2)^(gamma/(gamma-1))); 

%State 13
Tt13 = Tt2 * (1 + (1/etaf) * ((rf^((gamma-1)/gamma)) -1)); %K
Pt13 = rf * Pt2; %Pa

%State 3
Pt3 = rp * Pt13; %Pa
Tt3 = Tt13 * (1 + (1/etaC) * (rp^((gamma-1)/gamma)-1)); %K

%State 4
Pt4 = Pt3; %Pa
Tt4 = Tt3 + (phi*rFAst*LHV)/cp; %K

%State 4.5
Tt45 = Tt4 - (Tt13/etaC) * (rp^((gamma-1)/gamma)-1);
Pt45 = Pt4 * (1-(1/(etaC*etaHPT)*(Tt13/Tt4)*(rp^((gamma-1)/gamma)-1)))^(gamma/(gamma-1));

%State 5
Tt5 = Tt45 - (1+BPR)*(Tt2/etaf)*(rf^((gamma-1)/gamma)-1);
Pt5 = Pt45 * (1-((1+BPR)/(etaf*etaLPT)*(Tt2/Tt45)*(rf^((gamma-1)/gamma)-1)))^(gamma/(gamma-1));

%Exit velocity
Vec = sqrt(2*gamma/(gamma-1) * etaNC * R * Tt5 * (1-(Po/Pt5)^((gamma-1)/gamma)))
Vbp = sqrt(2*gamma/(gamma-1) * etaNBP * R * Tt13 * (1-(Po/Pt13)^((gamma-1)/gamma)))

%Inlet velocity
Vo = Mo * sqrt(gamma*R*To);

%Specific Thrust
ThrustSpec = BPR * (Vbp-Vo) + (Vec-Vo);

%Specific Thrust Fuel Consumption
tstf = (phi*rFAst)/ThrustSpec;

%% n
%Brandon Lim, PSET06 Aerospace Propulsion
clear, clc, close all
format longg

%Fluid properties
gamma = 1.4;
R = 287; %J/kgK
cv = R/(gamma-1); %J/kgK
cp = gamma*cv; %J/kgK
%Inital Fluid States
To = 216.65; %Kelvin
Po = 21.4*1000; %Pascals
Mo = 0.78;
%Efficiencies
etaD = 1;
etaf = 0.95;
etaC = 0.95;
etaHPT = 0.9;
etaLPT = etaHPT;
etaNC = 1;
etaNBP = 1;
%Mechanical Ratios
rf = 1.5;
rp = 13:0.01:60;
BPR = 12.5;
%Fuel Properties
mFuel = 12*12.01 + 26*1.008;
mO2 = 2*16;
mN2 = 2*14.01;
nFuel = 1;
nO2 = 18.5;
nN2 = 3.76*18.5;
rFAst = (nFuel*mFuel)/(nO2*mO2 + nN2*mN2);
phi = 0.25;
LHV = 42.8*10^6; %J/kgK

%State 1 & 2
Tt2 = To*(1+((gamma-1)/2) * (Mo^2)); % K
Tto = Tt2; % Kelvin
Pt2 = Po * (1 + etaD * ((gamma-1)/2) * Mo^2)^(gamma/(gamma-1)); %Pa
Pto = (Pt2 * (1+((gamma-1)/2) * Mo^2)^((gamma)/(gamma-1))) / ((1+((gamma-1)/2) * Mo^2)^(gamma/(gamma-1))); 

%State 13
Tt13 = Tt2 * (1 + (1/etaf) * ((rf^((gamma-1)/gamma)) -1)); %K
Pt13 = rf * Pt2; %Pa

%State 3
Pt3 = rp .* Pt13; %Pa
Tt3 = Tt13 * (1 + (1/etaC) .* (rp.^((gamma-1)./gamma)-1)); %K

%State 4
Pt4 = Pt3; %Pa
Tt4 = Tt3 + (phi.*rFAst.*LHV)./cp; %K

%State 4.5
Tt45 = Tt4 - (Tt13./etaC) .* (rp.^((gamma-1)./gamma)-1);
Pt45 = Pt4 .* (1-(1./(etaC.*etaHPT).*(Tt13./Tt4).*(rp.^((gamma-1)./gamma)-1))).^(gamma./(gamma-1));

%State 5
Tt5 = Tt45 - (1+BPR).*(Tt2./etaf).*(rf.^((gamma-1)./gamma)-1);
Pt5 = Pt45 .* (1-((1+BPR)./(etaf.*etaLPT).*(Tt2./Tt45)*(rf.^((gamma-1)./gamma)-1))).^(gamma./(gamma-1));

%Exit velocity
Vec = sqrt(2.*gamma./(gamma-1) .* etaNC .* R .* Tt5 .* (1-(Po./Pt5).^((gamma-1)./gamma)))
Vbp = sqrt(2.*gamma./(gamma-1) .* etaNBP .* R .* Tt13 .* (1-(Po./Pt13).^((gamma-1)/gamma)))

%Inlet velocity
Vo = Mo .* sqrt(gamma.*R.*To);

%Specific Thrust
ThrustSpec = BPR .* (Vbp-Vo) + (Vec-Vo);

%Specific Thrust Fuel Consumption
tstf = (phi.*rFAst)./ThrustSpec;

figure
plot(rp, ThrustSpec, "LineWidth",1.5)
xlabel("Compressor Pressure Ratio"); ylabel("Specific Net Thrust [Ns/kg]"); title("Compressor Pressure Ratio vs Specific Net Thrust")
legend("BPR = 12.5", "location", "southeast")

figure
plot(rp,tstf, "LineWidth",1.5)
xlabel("Compressor Pressure Ratio"); ylabel("Thrust Specific Fuel Consumption [Kg/Ns]"); title("Compressor Pressure Ratio vs Thrust Specific Fuel Consumption")
legend("BPR = 12.5", "location", "southeast")
%% o
%Brandon Lim, PSET06 Aerospace Propulsion
clear, clc, close all
format longg

%Fluid properties
gamma = 1.4;
R = 287; %J/kgK
cv = R/(gamma-1); %J/kgK
cp = gamma*cv; %J/kgK
%Inital Fluid States
To = 216.65; %Kelvin
Po = 21.4*1000; %Pascals
Mo = 0.78;
%Efficiencies
etaD = 1;
etaf = 0.95;
etaC = 0.95;
etaHPT = 0.9;
etaLPT = etaHPT;
etaNC = 1;
etaNBP = 1;
%Mechanical Ratios
rf = 1.5;
rp = 60;
BPR = 7:0.01:14.5;
%Fuel Properties
mFuel = 12*12.01 + 26*1.008;
mO2 = 2*16;
mN2 = 2*14.01;
nFuel = 1;
nO2 = 18.5;
nN2 = 3.76*18.5;
rFAst = (nFuel*mFuel)/(nO2*mO2 + nN2*mN2);
phi = 0.25;
LHV = 42.8*10^6; %J/kgK

%State 1 & 2
Tt2 = To*(1+((gamma-1)/2) * (Mo^2)); % K
Tto = Tt2; % Kelvin
Pt2 = Po * (1 + etaD * ((gamma-1)/2) * Mo^2)^(gamma/(gamma-1)); %Pa
Pto = (Pt2 * (1+((gamma-1)/2) * Mo^2)^((gamma)/(gamma-1))) / ((1+((gamma-1)/2) * Mo^2)^(gamma/(gamma-1))); 

%State 13
Tt13 = Tt2 * (1 + (1/etaf) * ((rf^((gamma-1)/gamma)) -1)); %K
Pt13 = rf * Pt2; %Pa

%State 3
Pt3 = rp .* Pt13; %Pa
Tt3 = Tt13 * (1 + (1/etaC) .* (rp.^((gamma-1)./gamma)-1)); %K

%State 4
Pt4 = Pt3; %Pa
Tt4 = Tt3 + (phi.*rFAst.*LHV)./cp; %K

%State 4.5
Tt45 = Tt4 - (Tt13./etaC) .* (rp.^((gamma-1)./gamma)-1);
Pt45 = Pt4 .* (1-(1./(etaC.*etaHPT).*(Tt13./Tt4).*(rp.^((gamma-1)./gamma)-1))).^(gamma./(gamma-1));

%State 5
Tt5 = Tt45 - (1+BPR).*(Tt2./etaf).*(rf.^((gamma-1)./gamma)-1);
Pt5 = Pt45 .* (1-((1+BPR)./(etaf.*etaLPT).*(Tt2./Tt45)*(rf.^((gamma-1)./gamma)-1))).^(gamma./(gamma-1));

%Exit velocity
Vec = sqrt(2.*gamma./(gamma-1) .* etaNC .* R .* Tt5 .* (1-(Po./Pt5).^((gamma-1)./gamma)))
Vbp = sqrt(2.*gamma./(gamma-1) .* etaNBP .* R .* Tt13 .* (1-(Po./Pt13).^((gamma-1)/gamma)))

%Inlet velocity
Vo = Mo .* sqrt(gamma.*R.*To);

%Specific Thrust
ThrustSpec = BPR .* (Vbp-Vo) + (Vec-Vo);

%Specific Thrust Fuel Consumption
tstf = (phi.*rFAst)./ThrustSpec;

plot(BPR,ThrustSpec, "linewidth", 1.5)
xlabel("BPR"); ylabel("Thrust Specific Fuel Consumption [Kg/Ns]"); title("BPR vs Thrust Specific Fuel Consumption")
legend("r_p = 60", "location", "southeast")