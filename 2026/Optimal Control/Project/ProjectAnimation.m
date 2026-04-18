clear, clc, close all
Opt = readmatrix("Opt.txt");
Raw = readmatrix("Raw.txt");

t = linspace(0,10,1000);

phi_opt = Opt(:,1); psi_opt = Opt(:,2);
phi_raw = Raw(:,1); psi_raw = Raw(:,2);

% Read STL file of the F16
TR = stlread('F16.stl');
F = TR.ConnectivityList; %Triangle surface faces from stl 
V = TR.Points; %Geomeotry points from stl

% Center model at its centroid
V = V - mean(V,1);

% Optional scale so it fits nicely in view
V = V ./ max(max(V) - min(V));

% Original vertices
V0 = V;

% Rotation matrices in degrees
Rx = @(phi)[1 0 0;
            0 cosd(phi) sind(phi);
            0 -sind(phi)  cosd(phi)];

Rz = @(psi)[cosd(psi) sind(psi) 0;
            -sind(psi)  cosd(psi) 0;
            0          0         1];

% Roll Reference Lines
pw = [-0.13127 -0.13127; 0.35 0.6; -0.0155534 -0.0155534];
sw = [-0.13127 -0.13127; -0.35 -0.6; -0.0155534 -0.0155534];
heading = [0.55 1.5; -0.013 -0.013; 0.0500035 0.0500035];

wing = [-0.13127 -0.13127; -0.6 0.6; -0.0155534 -0.0155534];
Fuselage = [-0.5 10; -0.013 -0.013; 0.0500035 0.0500035];


view1 = -90;
view2 = 22;

figure('WindowState','maximized')

plt1 = subplot(1,2,1); hold on
set(gca,'ZDir','reverse'); axis equal; grid on;
xlabel('X'); ylabel('Y'); zlabel('Z')
xlim([-1.2 1.2]); ylim([-1.2 1.2]); zlim([-1.2 1.2])

p_raw = patch('Faces',F,'Vertices',V0, ...
    'FaceColor',[0.8 0.8 0.8], ...
    'EdgeColor','none');
view(view1,view2); camlight; lighting gouraud

pw_raw = plot3(plt1, pw(1,:), pw(2,:), pw(3,:), 'r--', 'LineWidth', 2);
set(pw_raw,'XData',pw(1,:), 'YData',pw(2,:), 'ZData',pw(3,:))
sw_raw = plot3(plt1, sw(1,:), sw(2,:), sw(3,:), 'r--', 'LineWidth', 2);
set(sw_raw,'XData',sw(1,:), 'YData',sw(2,:), 'ZData',sw(3,:))
heading_raw = plot3(plt1, heading(1,:), heading(2,:), heading(3,:), 'r--', 'LineWidth', 2);
set(heading_raw,'XData',heading(1,:), 'YData',heading(2,:), 'ZData',heading(3,:))

% plt2 = subplot(1,3,2); hold on
% set(gca,'ZDir','reverse'); axis equal; grid on;
% xlabel('X'); ylabel('Y'); zlabel('Z')
% xlim([-1.2 1.2]); ylim([-1.2 1.2]); zlim([-1.2 1.2])
% view(view1,35); camlight; lighting gouraud
% 
% wing_raw =  plot3(plt2, wing(1,:), wing(2,:), wing(3,:), 'r--', 'LineWidth', 2);
% set(wing_raw,'XData',wing(1,:), 'YData',wing(2,:), 'ZData',wing(3,:))
% fus_raw =  plot3(plt2, Fuselage(1,:), Fuselage(2,:), Fuselage(3,:), 'r--', 'LineWidth', 2);
% set(fus_raw,'XData',Fuselage(1,:), 'YData',Fuselage(2,:), 'ZData',Fuselage(3,:))
% 
% wing_opt =  plot3(plt2, wing(1,:), wing(2,:), wing(3,:), 'b--', 'LineWidth', 2);
% set(wing_opt,'XData',wing(1,:), 'YData',wing(2,:), 'ZData',wing(3,:))
% fus_opt =  plot3(plt2, Fuselage(1,:), Fuselage(2,:), Fuselage(3,:), 'b--', 'LineWidth', 2);
% set(fus_opt,'XData',Fuselage(1,:), 'YData',Fuselage(2,:), 'ZData',Fuselage(3,:))

plt3 = subplot(1,2,2); hold on
set(gca,'ZDir','reverse'); axis equal; grid on; 
xlabel('X'); ylabel('Y'); zlabel('Z')
xlim([-1.2 1.2]); ylim([-1.2 1.2]); zlim([-1.2 1.2])

p_opt = patch('Faces',F,'Vertices',V0, ...
    'FaceColor',[0.8 0.8 0.8], ...
    'EdgeColor','none');
view(view1,view2); camlight; lighting gouraud

pw_opt = plot3(plt3, pw(1,:), pw(2,:), pw(3,:), 'b--', 'LineWidth', 2);
set(pw_opt,'XData',pw(1,:), 'YData',pw(2,:), 'ZData',pw(3,:))
sw_opt = plot3(plt3, sw(1,:), sw(2,:), sw(3,:), 'b--', 'LineWidth', 2);
set(sw_opt,'XData',sw(1,:), 'YData',sw(2,:), 'ZData',sw(3,:))
heading_opt = plot3(plt3, heading(1,:), heading(2,:), heading(3,:), 'b--', 'LineWidth', 2);
set(heading_opt,'XData',heading(1,:), 'YData',heading(2,:), 'ZData', heading(3,:))

% legend(plt2,"Aileron Step Input Attitude Indicator","", "Optimal Input Attitude Indicator", "location","southoutside")
%Showing the time progression
title(plt1,"Aileron Step Input")
% title(plt2,"Attitude Comparison")
title(plt3,"Optimal Input")

headingC_raw = plot3(plt3, heading(1,:), heading(2,:), heading(3,:), 'r--', 'LineWidth', 2);
headingC_opt = plot3(plt1, heading(1,:), heading(2,:), heading(3,:), 'b--', 'LineWidth', 2);

% 
% h_time = annotation('textbox',[0.45 0.93 0.1 0.05], ...
%     'String','t = 0.00 s', ...
%     'EdgeColor','none', ...
%     'HorizontalAlignment','center', ...
%     'FontSize',18, ...
%     'FontWeight','bold');

tic
for k = 1:10:length(t)

    %Rotating Original Geometry through rotational matricies
    phi_raw_k = phi_raw(k);
    psi_raw_k = psi_raw(k);
    R_raw = Rx(phi_raw_k)*Rz(psi_raw_k);
    V_rot_raw = (R_raw * V0')';

    pwR_raw = R_raw * pw;
    set(pw_raw,'XData',pwR_raw(1,:), 'YData',pwR_raw(2,:), 'ZData',pwR_raw(3,:))
    swR_raw = R_raw * sw;
    set(sw_raw,'XData',swR_raw(1,:), 'YData',swR_raw(2,:), 'ZData',swR_raw(3,:))
    headingR_raw = R_raw * heading;
    set(heading_raw,'XData',headingR_raw(1,:), 'YData',headingR_raw(2,:), 'ZData',headingR_raw(3,:))
    % wingR_raw = R_raw * wing;
    % set(wing_raw,'XData',wingR_raw(1,:), 'YData',wingR_raw(2,:), 'ZData',wingR_raw(3,:))
    % Fuse_raw = R_raw * Fuselage;
    % set(fus_raw,'XData',Fuse_raw(1,:), 'YData',Fuse_raw(2,:), 'ZData',Fuse_raw(3,:))

    %Rotating Original Geometry through rotational matricies
    phi_opt_k = phi_opt(k);
    psi_opt_k = psi_opt(k);
    R_opt = Rx(phi_opt_k)*Rz(psi_opt_k);
    V_rot_opt = (R_opt * V0')';

    pwR_opt = R_opt * pw;
    set(pw_opt,'XData',pwR_opt(1,:), 'YData',pwR_opt(2,:), 'ZData',pwR_opt(3,:))
    swR_opt = R_opt * sw;
    set(sw_opt,'XData',swR_opt(1,:), 'YData',swR_opt(2,:), 'ZData',swR_opt(3,:))
    headingR_opt = R_opt * heading;
    set(heading_opt,'XData',headingR_opt(1,:), 'YData',headingR_opt(2,:), 'ZData',headingR_opt(3,:))
    % wingR_opt = R_opt * wing;
    % set(wing_opt,'XData',wingR_opt(1,:), 'YData',wingR_opt(2,:), 'ZData',wingR_opt(3,:))
    % Fuse_opt = R_opt * Fuselage;
    % set(fus_opt,'XData',Fuse_opt(1,:), 'YData',Fuse_opt(2,:), 'ZData',Fuse_opt(3,:))
    
    set(headingC_raw,'XData',headingR_raw(1,:), 'YData',headingR_raw(2,:), 'ZData',headingR_raw(3,:))
    set(headingC_opt,'XData',headingR_opt(1,:), 'YData',headingR_opt(2,:), 'ZData',headingR_opt(3,:))

    %Re-orienting the original render
    set(p_raw,'Vertices',V_rot_raw)
    set(p_opt,'Vertices',V_rot_opt)

    % % % set(h_time,'String',sprintf('t = %.2f s', t(k)))
    drawnow

    while toc < t(k)/3
    end
end
% set(gcf,'Units','inches','Position',[0 0 10 6])  % width x height
lg1 = legend(plt1,"","Aileron Step Input Attitude Indicator","","","Optimal Input Attitude Indicator", "location","southoutside");
lg1.Position = [0.3 0.02 0.4 0.05];
exportgraphics(gcf,'Sim.pdf','ContentType','vector')
