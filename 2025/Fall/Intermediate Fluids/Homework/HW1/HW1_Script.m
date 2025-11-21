%% HW1
% P3
clear, clc, close all

%Problem Conditions
xo = 0.52;
yo = 6;
x = linspace(xo,10,100);
y = (-x.^2 + sqrt(x.^4 + 4.*x*((xo^2) * yo + (yo^2) * xo)))./(2.*x); %Calculating Pathlines

%Plotting Pathlines
figure
plot(x,y)
legend("Pathline")
xlabel("x"); ylabel("y"); title("Particle Pathline")

%Calculating Acceleration Magnitude
ax = (2.*x).*((x.^2) + (x.*y) + (y.^2));
ay = (2.*y).*((x.^2) + (x.*y) + (y.^2));
a = sqrt(ax.^2 + ay.^2);
ds = x.^2 +y.^2;

%Plotting accleration magnitude vs distance
figure
plot(ds,a)
xlabel("Distance Traveled: S"); ylabel("Accerlation Magnitude"); title("Acceleration Magnitude vs Distance Traveled")

%% P4
clear, clc, close all

%Problem Conditions
x = linspace (-1,1,100); %x-values to test
c = linspace (0, 0.5, 10); %constant values to test

figure
hold on
for i = 1:length(c)
    y = sqrt(x.^2 + c(i)); %Calculating streamline y-values
    plot(x,y) %Plotting
    xlabel("x"),ylabel("y")
end
%% P5
clear, clc, close all
% Problem conditions
t = 2;
xo = 1;
yo = 1;

%Streakline calculation
x = linspace(xo,11,10);
y = x.^((2*(1+t))./(2+t));
%Pathline Calculation
tp = linspace(1,10,10);
xp = xo.*(tp+1);
yp = (yo./4).*(2+tp).^2;

%Plotting
figure
hold on
plot(x,y)
plot(xp,yp,"-o")
legend("Streamline at t=2", "Pathline", "location","northwest")
xlabel("x"); ylabel("y"); title("Streakline and Pathline")
for i = 1:length(tp)
    text(xp(i),yp(i)-1,"t="+num2str(tp(i)))
end

