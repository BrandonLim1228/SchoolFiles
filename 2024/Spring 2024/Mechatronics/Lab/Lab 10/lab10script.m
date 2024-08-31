clear, clc, close all
Volts = [-1.483 -1.429 -1.37 -1.313 -1.259 -1.198 -1.142 -1.084 -1.03 -0.9818 -0.4057 0.1476 0.7023 1.262 2.929 4.044 ];
Force = [.0981 0.1962 0.2943 0.3924 0.4905 0.5886 0.6867 0.7848 0.8829 0.981 1.962 2.943 3.924 4.905 7.848 9.810];

figure();
plot(Volts,Force,'o');
xlabel('Volts [v]');
ylabel('Force [N]');
title('Force vs Volts | Brandon Lim u1244501'); 

m = [ 0.01 0.03 0.05 0.07 0.09 0.1 0.2 0.3 0.4 0.5 0.8 1];
V = [-1.233 -0.7963 -0.4176 -0.062 0.292 0.4924 1.957 3.45 4.254 5.289 7.00 8.362];
I = [0.34 0.51 0.65 0.78 0.88 0.95 1.53 1.96 2.01 2.39 2.31 2.5];
g = 9.81;
Hz = [65 60 55 50 47 44 30 15 12 3 1 1];
numStripes = 10;
RPM = (Hz ./numStripes) .* 60;
rad = (RPM .* (2*pi))./(60);
r = .03;
F = 1.757 .* V + 2.696;
T = (F-(m.*g)).*r;
n = (T .* rad)./(5 .* I);

figure()
plot(RPM,T,'o')
xlabel('RPM');
ylabel('Torque [Nm]'); 
title('Torque vs RPM | Brandon Lim u1244501');

figure()
plot(RPM,n,'o');
xlabel('RPM')
ylabel('n')
title('n vs RPM | Brandon Lim u1244501')