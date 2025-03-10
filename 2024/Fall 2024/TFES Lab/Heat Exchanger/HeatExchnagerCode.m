%--------------------------------------------------------------------------
% TFES Lab ME EN 4650
%
% Heat Exchanger - Data Analysis
%
% Brandon Lim
% 12/6/24
%--------------------------------------------------------------------------
clear, clc, close all
format longG
%Parsing Data
Patm = 88.1261; %kPa

T1 = ([114.2 115.7 113.9 116.3] - 32) .* (5/9); %degC
T2 = ([104.9 103.1 106.7 103.9] - 32) .* (5/9); %degC
T3 = ([51.8 51.5 51.5 51.2] - 32) .* (5/9); %degC
T4 = ([64.0 63.7 64.4 63.8] - 32) .* (5/9); %degC
T5 = ([95.6 96.8 97.2 97.1] - 32) .* (5/9); %degC
T6 = ([70.4 70.5 70.4 70.2] - 32) .* (5/9); %degC

VdotC = [3.8 3.7 3.2 3.4] ./ 60 ./ 264.172; %m^3/s
VdotH = [4.6 3.0 5.2 3.0] ./ 60 ./ 264.172; %m^3/s

%Calculating average temperature
TcBar = (1/2) .* (T3 + T4); %degC
ThBar = (1/2) .* (T1 + T2); %degC

%Finding water properties using function
for i = 1:length(TcBar)
    [rhoC(i),CpC(i)] = WaterProperties(TcBar(i));
    [rhoH(i),CpH(i)] = WaterProperties(ThBar(i));
end

%Calculating Mass Flow Rate
MdotC = rhoC .* VdotC; %kg/s
MdotH = rhoH .* VdotH; %kg/s

%Calculating Temperature Difference
deltaTh = T1 - T2; %degC
deltaTc = T4 - T3; %degC 

%Calculating Heat Capacities 
Cc = MdotC .* CpC;
Ch = MdotH .* CpH;
Cmin = min(Cc,Ch);
Cmax = max(Cc,Ch);
Cr = Cmin./Cmax;

%Calculating heat transfer
qh = MdotH .* CpH .* deltaTh; % Watts
qc = MdotC .* CpC .* deltaTc; % Watts
deltaq = (abs(qh-qc)./(0.5 .* (qh + qc))) .* 100; % Watts

%Calculating Overall heat transfer coefficent
delta2 = T2 - T3; %degC
delta1 = T1 - T4; %degC
deltaTlm = ((delta1) - (delta2)) ./ log((delta1)./(delta2)); %Log Mean Temperature differnce K

N = 31; % number of tubes
Di = 0.1940 * 0.0254; %inside diameter in meters
L = 0.2286; %meters
Ai = N * pi * Di * L; %m^2
Ui = qh./(Ai .* deltaTlm); %W/m^2K

%Calculating NTU
NTU = (Ui .* Ai) ./ Cmin;

%Calculating efftiveness
deltaTmax = T1 - T3; %degC
epsilonAct = qh ./ (Cmin .* (deltaTmax));
epsilonTheo = (1 - exp(-NTU .* (1 - Cr)))./(1 - Cr .* exp(-NTU .* (1 - Cr)));
delta_epsilon = (abs(epsilonAct - epsilonTheo) ./ epsilonTheo) .* 100;

%Plotting effectivness vs NTU
f1 = openfig("EffectivenessNTU.fig","invisible");
ax1 = gca;
f2 = openfig("EffectivenessNTU.fig","invisible");
ax2 = gca;

figure
s1 = subplot(1,2,1);
hold on
fig1 = get(ax1,"children");
copyobj(fig1,s1);
hold on
plot(NTU,epsilonAct, "bo")
plot(NTU,epsilonTheo, "k+")
xlabel("NTU")
ylabel("Effectiveness")
legend("Measured Effectiveness","Calculated Theoretical Effectiveness")
s2 = subplot(1,2,2);
hold on
fig2 = get(ax2,"children");
copyobj(fig2,s2);
xlim([0.18 0.26]);
ylim([0.16 0.22]);
plot(NTU,epsilonAct,"ob")
plot(NTU,epsilonTheo,"k+")
xlabel("NTU")
ylabel("Effectiveness")
sgtitle("Effectivness versus NTU")


%Calculating heat transfer due to radiation and convection
Ts = T5 + 273.15; %K
Tinf = T6 + 273.15; %K
Tf = (1/2) .* (Ts + Tinf); %K
L = 0.2286; %meters
Ds = 0.053848; %meters

for i = 1:length(Tf)
    [rho(i),mu(i),k(i),Cp(i)] = AirProperties(Tf(i),Patm*1000);
end

beta = 1./Tf;
v = mu./rho;
alpha = k./(rho.*Cp);
Rad = (9.81 .* beta .* (Ts-Tinf) .* (Ds.^3))./(v.*alpha);

NudBar = 0.48.*(Rad.^(1/4));
hBar = (k.*NudBar)./Ds;
sigma = 5.6703 * (10^-8);
eps = 0.95;

qconv = hBar .* pi .* Ds .* L .* (Ts-Tinf);
qrad = eps .* sigma .* ((Ts.^4)-(Tinf.^4)) .* pi .* Ds .* L;

