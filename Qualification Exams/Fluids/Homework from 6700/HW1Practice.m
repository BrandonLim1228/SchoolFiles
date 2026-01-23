clear,clc,close all

%P3
x = linspace(0,10, 100);
y = (-x.^2 + sqrt(x.^4 + 4.*x.*(0.52.^2 .* 6 + 6.^2 .* 0.52)))./(2.*x);

ax = 2.*x.^3 + 2.*x.*y.^2 + 2.*x.^2.*y;
ay = 2.*y.^3 + 2.*x.^2.*y + 2.*x.*y.^2;

a = sqrt(ax.^2 + ay.^2);

figure
plot(x,y)
hold on
plot(x,a)
