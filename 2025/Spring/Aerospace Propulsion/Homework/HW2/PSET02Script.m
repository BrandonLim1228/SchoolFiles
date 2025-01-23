%% Homework 2 Aerospace Propulsion
%% Part e) Computing Adiabatic Flame Temperature Iteratively 
clear, clc, close all

%Element weight
C = 12.01; %g/mol
O = 16; %g/mol
N = 14.01; %g/mol
H = 1.008; %g/mol

%Molecule weight
C2H4 = 2*C + 4*H; %g/mol
O2 = 2*O; %g/mol
N2 = 2*N; %g/mol
CO2 = C + 2* O; %g/mol
CO = C + O; %g/mol
H2O = H * 2 + O; %g/mol

%Mass Fractions
Yr_C2H4 = 0.0755;
Yr_O2 = 0.2154;
Yr_N2 = 0.7091;
Yp_CO2 = 0.1185;
Yp_CO = 0.0755;
Yp_H20 = 0.09699;
Yp_N2 = 0.7089;

%Reactants
hs_C2H4_To = 32.847 * (1/C2H4) * 1000; %kJ/kg
hf_C2H4_Tref = 52.467 * (1/C2H4) * 1000; %kJ/Kg
hs_O2_To = 15.835 * (1/O2) * 1000; %kJ/kg
hf_O2_Tref = 0 * 1000; %kJ/kg
hs_N2_To = 15.046 * (1/N2) * 1000; %kJ/kg
hf_N2_Tref = 0 * 1000; %kJ/kg

%Products
hf_CO2_Tref = -393.522 * (1/CO2) * 1000; %kJ/kg
hf_CO_Tref = -110.527 * (1/CO) * 1000; %kJ/kg
hf_H2O_Tref = -241.826 * (1/H2O) * 1000; %kJ/kg

%Importing Janaf Table Data from TXT file
H2O_Prop = importdata("H2O Properties.txt");
hs_H2O_T = H2O_Prop.data(:,5) .* (1./H2O) .* 1000;
CO2_Prop = importdata("CO2 Properties.txt");
hs_CO2_T = CO2_Prop.data(:,5) .* (1./CO2) .* 1000;
CO_Prop = importdata("CO Properties.txt");
hs_CO_T = CO_Prop.data(:,5) .* (1./CO) .* 1000;
N2_Prop = importdata("N2 Properties.txt");
hs_N2_T = N2_Prop.data([2:3,5:6,8,10:end],1) .* (1./N2) .* 1000;
T = H2O_Prop.data(:,1);

LHS = Yr_C2H4 * (hs_C2H4_To + hf_C2H4_Tref) + Yr_O2 * (hs_O2_To + hf_O2_Tref) + Yr_N2 * (hs_N2_To + hf_N2_Tref);

for i = 1:length(hs_CO2_T)
    RHS(i) = Yp_CO2 * (hs_CO2_T(i) + hf_CO2_Tref) + Yp_CO * (hs_CO_T(i) + hf_CO_Tref) + Yp_H20 * (hs_H2O_T(i) + hf_H2O_Tref) + Yp_N2 * (hs_N2_T(i) + hf_N2_Tref);
end

LHS = LHS .* ones(length(RHS),1);
RHS = RHS';
DIFF = LHS - RHS;
index = find(DIFF < 0);

Tad = (0 - DIFF(index(1)-1))/(DIFF(index(1)) - DIFF(index(1)-1)) * (T(index(1)) - T(index(1)-1)) + T(index(1)-1)

Iterations = table(T, LHS ,RHS, DIFF, hs_CO2_T, hs_CO_T, hs_H2O_T, hs_N2_T)
