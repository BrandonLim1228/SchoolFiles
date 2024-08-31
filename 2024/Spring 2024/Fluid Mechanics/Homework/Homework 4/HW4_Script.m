%Brandon Lim
clear, clc, close all
y1 = [-5:5];
x1 = y1 + ((y1.^2)./2);
y2 = [-3:3];
x2 = y2 + ((y2.^2)./2);
y3 = [-1:1];
x3 = y3 + ((y3.^2)./2);

figure
streamLine1 = plot(x1,y1,'b');
line2arrow(streamLine1);
hold on 
streamLine2 = plot(x2,y2,'b');
line2arrow(streamLine2);
hold on
streamLine3 = plot(x3,y3,'b');
line2arrow(streamLine3);
hold on
grid on
xline(0)
yline(0)
xlabel("x")
ylabel("y")
%%
clear, clc, close all

x0 = 1;
y0 = 1;
t = linspace(0,1,11);

x = x0 .* exp(5.*(t+((t.^2)./2)));
y = y0 .* exp(5.*(-t+((t.^2)./2)));

plot(x,y)
grid on
xline(0)
yline(0)
xlim([-1,10])
ylim([-1,1.5])
xlabel("x(t)")
ylabel("y(t)")




