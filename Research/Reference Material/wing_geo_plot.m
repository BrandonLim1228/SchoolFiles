%% paper figure setup parameters
% get(groot,'factory'); % check property names
set(groot, 'defaultLineLineWidth', 3)
set(groot, 'defaultLineMarkerSize', 10)
set(groot, 'defaultAxesFontSize', 24)
set(groot, 'defaultTextFontSize', 24)
set(groot, 'defaultFigureColor', 'w')
set(groot, 'defaultFigurePosition', [500 200 1000 750])
set(groot, 'defaultLegendInterpreter', 'latex')
set(groot, 'defaultTextInterpreter', 'latex')
set(groot, 'defaultAxesTickLabelInterpreter', 'latex')
set(groot, 'defaultColorbarTickLabelInterpreter', 'latex')
set(groot, 'defaultLegendFontName', 'Times New Roman')
set(groot, 'defaultColorbarFontName', 'Times New Roman')
set(groot, 'defaultAxesFontName', 'Times New Roman')
% line colors
colorR = [0.8500 0.3250 0.0980];
colorB = [0.0000 0.4470 0.7410];
colorG = [0.4660 0.6740 0.1880];
colorY = [0.9290 0.6940 0.1250];
colorP = [0.4940 0.1840 0.5560]+0.1;
colorM = [1.0000 0.0700 0.6500];
colorC = [0.0600 1.0000 1.0000];
colorK = [0.1500 0.1500 0.1500];
colorLB = [0.3010 0.7450 0.9330];
colorDR = [0.6350 0.0780 0.1840]+0.05;
colorDB = [0.2000 0.3000 1.0000];
colorDG = [0.0400 0.4500 0.0000];
colorOrder = {colorB; colorR; colorG; colorP; colorC; colorM; colorDB; colorDR; colorDG; colorLB; colorK};
defaultColorOrder = [colorB; colorR; colorG; colorP; colorC; colorM; colorDB; colorDR; colorDG; colorLB; colorK];
set(groot, 'defaultAxesColorOrder', defaultColorOrder)
% R&B color map
mapR = [linspace(1, 0.66, 256)', linspace(1, 0.1, 256)', linspace(1, 0, 256)'];
mapB = [linspace(1, 0, 256)', linspace(1, 0.44, 256)', linspace(1, 0.66, 256)'];
mapRB = [flip(mapB(16:end, :)); [1 1 1]; mapR(16:end, :)];
% Y&G color map
mapY = [linspace(1, 0.5, 256)', linspace(1, 0.3, 256)', linspace(1, 0, 256)'];
mapG = [linspace(1, 0, 256)', linspace(1, 0.5, 256)', linspace(1, 0.4, 256)'];
mapYG = [flip(mapG(16:end, :)); [1 1 1]; mapY(16:end, :)];
% gradiant color map
mapRBg = [[linspace(0, 0.33, 128)'; linspace(0.33, 0.66, 128)'], ...
          [linspace(0.44, 0.66, 128)'; linspace(0.66, 0.1, 128)'], ...
          [linspace(0.66, 0.1, 128)'; linspace(0.1, 0, 128)']];
mapYGg = [linspace(0, 0.5, 256)', ...
          linspace(0.5, 0.3, 256)', ...
          linspace(0.4, 0, 256)'];
set(groot, 'defaultFigureColormap', mapRB)
% draw arrow function
% example: drawArrow([x1, x2],[y1, y2], 'MaxHeadSize', 0.5, 'linewidth', 3, 'color', 'r')
drawArrow = @(x, y, varargin) quiver(x(1), y(1), x(2)-x(1), y(2)-y(1), 0, varargin{:});
% plot shadow confidence interval function
% x, y_upper, y_lower must be column vectors
plotci = @(x, y_upper, y_lower, color) fill([x; flip(x)], [y_upper; flip(y_lower)], color, ...
           'LineStyle', 'none', 'FaceAlpha', 0.4);
       
%%
cr = 0.36; % root chord length [m]
mac = 233.2953e-3; % mean aerodynamic chord [m]
b = 313.1127e-3; % wing span [m]
s = b/2; % half wing span [m]
Lambda = 65; % sweeping angle [deg]
l_LE = s/cosd(Lambda); % length of leading edge [m]
x_trans = (7/12)*l_LE*sind(Lambda) + 5e-3; % x coordinate of trasducer on the chord [m]
x0_mac = 104.1271e-3; % x-coordinate (longitudinal) of the leading edge of the mac [m]
x_quatmac = 162.4509e-3; % x-coordinate of the 1/4 mac [m] 252e-3

px = [36; 101.6; 176.9; 167.2; 242.5; 232.8; 298.4; ...
      36; 101.6; 176.9; 167.2; 242.5; 232.8; 298.4];
py = [-8; -38.5; -48.3; -69.1; -78.9; -99.7; -78.9; ...
       8; 38.5; 48.3; 69.1; 78.9; 99.7; 78.9];
ratio = 360/330;
ref = [330, 288]*ratio;
O = [0, 0];
M = [330, 0];
P = [308, -144];
PT = [330, -96];
PV = [308, -48];
S = [308, 144];
ST = [330, 96];
SV = [308, 48];

MAC1 = [x0_mac/360e-3, 44.51/288];
MAC2 = [(x0_mac+mac)/360e-3, 44.51/288];
MAC4 = [x_quatmac/360e-3, 44.51/288];

O = round(O*ratio)./ref;
M = round(M*ratio)./ref;
P = round(P*ratio)./ref;
PT = round(PT*ratio)./ref;
PV = round(PV*ratio)./ref;
S = round(S*ratio)./ref;
ST = round(ST*ratio)./ref;
SV = round(SV*ratio)./ref;

px = px/(330*ratio);
py = py/(288*ratio);

close all
figure
% set(gcf, 'Position', get(0, 'Screensize'));
hold on
for i = 1 : 3
    plot(px(i), py(i), 'o', 'color', colorB)
    plot(px(i+7), py(i+7), 'o', 'color', colorB)
end
text(px([1:3, 8:10])+0.05, py([1:3, 8:10])-0.04, {'p1', 'p2', 'p3', 's1', 's2', 's3'}, 'color', colorB, 'fontsize', 24)
for i = 4 : 7
    plot(px(i), py(i), 'o', 'color', colorB)
    plot(px(i+7), py(i+7), 'o', 'color', colorB)
    text(px(i)+0.03, py(i)-0.01, {['p' num2str(i)]}, 'color', colorB, 'fontsize', 24)
    text(px(i+7)+0.05, py(i+7)-0.04, {['s' num2str(i)]}, 'color', colorB, 'fontsize', 24)
end
line([O(1), P(1)], [O(2), P(2)], 'color', colorK)
line([P(1), PT(1)], [P(2), PT(2)], 'color', colorK)
line([PT(1), PV(1)], [PT(2), PV(2)], 'color', colorK)
line([PV(1), M(1)], [PV(2), M(2)], 'color', colorK)
line([M(1), SV(1)], [M(2), SV(2)], 'color', colorK)
line([SV(1), ST(1)], [SV(2), ST(2)], 'color', colorK)
line([ST(1), S(1)], [ST(2), S(2)], 'color', colorK)
line([S(1), O(1)], [S(2), O(2)], 'color', colorK)
grid on
xlabel('$x/c_\mathrm{r}$')
ylabel('$y/b$')
axis equal
xlim([0, 1])
ylim([-0.5, 0.5])
yticks([-0.5:0.25:0.5])
% text(px+0.015, py-0.01, {'p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 's1', 's2', 's3', 's4', 's5', 's6', 's7'})
legend({'pressure sensor location'}, 'fontsize', 16, 'Location', 'northeast', 'interpreter', 'latex', 'Box', 'off')
% saveas(gca, 'sensor_location.jpg')
% camroll(-90)
view([90 90])
%%
figure
% set(gcf, 'Position', get(0, 'Screensize'));
hold on
line([O(1), P(1)], [O(2), P(2)], 'color', colorK)
line([P(1), PT(1)], [P(2), PT(2)], 'color', colorK)
line([PT(1), PV(1)], [PT(2), PV(2)], 'color', colorK)
line([PV(1), M(1)], [PV(2), M(2)], 'color', colorK)
line([M(1), SV(1)], [M(2), SV(2)], 'color', colorK)
line([SV(1), ST(1)], [SV(2), ST(2)], 'color', colorK)
line([ST(1), S(1)], [ST(2), S(2)], 'color', colorK)
line([S(1), O(1)], [S(2), O(2)], 'color', colorK)
lg1 = line([O(1), M(1)], [O(2), M(2)], 'color', colorB, 'linestyle', '-');
lg2 = line([P(1), S(1)], [P(2), S(2)], 'color', [0.4 0.4 0.4], 'linestyle', '--');
lg3 = line([MAC1(1), MAC2(1)], [MAC1(2), MAC2(2)], 'color', colorR, 'linestyle', '-');
lg4 = plot(MAC4(1), MAC4(2), 'x', 'color', colorR, 'markersize', 20);
text(0.52, -0.01, {'$c_r=360~\mathrm{mm}$'}, 'HorizontalAlignment', 'right')
text(0.7, 0.16, {'$\bar{\bar{c}}=233~\mathrm{mm}$'}, 'HorizontalAlignment', 'left')
text(0.89, -0.4, {'$b=313~\mathrm{mm}$'}, 'HorizontalAlignment', 'left')
grid on
xlabel('$x/c_\mathrm{r}$')
ylabel('$y/b$')
axis equal
xlim([0, 1])
ylim([-0.5, 0.5])
% yticks([-0.5:0.25:0.5])
yticks([-0.5:0.05:0.5])
% text(px+0.015, py-0.01, {'p1', 'p2', 'p3', 'p4', 'p5', 'p6', 'p7', 's1', 's2', 's3', 's4', 's5', 's6', 's7'})
hlegend = legend([lg1, lg2, lg3, lg4], ...
                 {'root chord', 'span', 'mean aerodynamic chord', 'm.a.c./4'}, ...
                 'fontsize', 14, 'Location', 'northeast', 'interpreter', 'latex', 'Box', 'off');
% saveas(gca, 'sensor_location.jpg')
% camroll(-90)
view([90 90])
% set(hlegend.BoxFace, 'ColorType','truecoloralpha', 'ColorData',uint8(255*[1; 1; 1; 0.7])); % transparent legend