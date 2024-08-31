%Brandon Lim
clear,clc,close all

r = 0:0.2:2.8; %in
r = [r, 2.9, 2.95, 2.98, 3];
r = r./12;
vel = [30 29.71 29.39 29.06 28.70 28.31 27.89 27.42 26.90 26.32 25.64 24.84 23.84 22.5 20.38 18.45 16.71 14.66 0]; %ft/s


plot(vel,r);
xlabel("Axial Velocity [ft/s]")
ylabel("Radial Distance from Center Pipe [ft]")
title("Velocity Profile along Radial Distance of Pipe")

hold on
for i = 1:length(r)
 velline = plot([0, vel(i)],[r(i),r(i)],"k");
 line2arrow(velline);
end

integration = trapz(r,(vel .* r));
mass_flow_rate = integration * 2 * pi * 0.00238 