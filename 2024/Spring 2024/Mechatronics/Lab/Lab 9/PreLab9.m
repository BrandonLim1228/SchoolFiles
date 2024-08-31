% Brandon Lim u1244501
%% Problem 3
clear,clc,close all

t = 0:0.01:1; % time array with 0.01 sample time  
pos = 10*cos(2*pi*t); % continuous angular position (deg) vs. time  
enc_pos = round(pos,1); % simulated encoder reading with resolution of 0.1

%a)
subplot(2,1,1)
hold on
plot(t,pos)
xlabel("Time [Sec]")
ylabel("Position")
title("Angular and Encoder Position vs Time")
plot(t,enc_pos)
legend("Angular Position", "Encoder Positon")
hold off

angularVel(1) = 0;
encoderVel(1) = 0;
for i = 2:length(pos)
    angularVel(i) = (pos(i) - pos(i-1)) / 0.01;
    encoderVel(i) = (enc_pos(i) - pos(i-1)) / 0.01;
end

subplot(2,1,2)
sgtitle("Brandon Lim | u1244501")
hold on 
plot(t,angularVel)
xlabel("Time [Sec]")
ylabel("Velocity")
title("Angular and Encoder Velocity vs Time")
plot(t,encoderVel)

%c)
encVelFiltered(1) = encoderVel(1);
for i = 2:length(encoderVel)
encVelFiltered(i) = 0.3 * encoderVel(i) + (1-0.3) * encVelFiltered(i-1);
end
plot(t,encVelFiltered)
legend("Angular Velocity", "Encoder Velocity","Encoder Filtered Velocity", "location","southeast")
hold off

%c-b)
enc_posFiltered(1) = enc_pos(1);
for i = 2:length(enc_pos)
enc_posFiltered(i) = 0.3 * enc_pos(i) + (1-0.3) * enc_posFiltered(i-1);
end

encoderVelfilteredPrior(1) = 0;
for i = 2:length(enc_posFiltered)
    encoderVelfilteredPrior(i) = (enc_posFiltered(i) - enc_posFiltered(i-1)) / 0.01;
end
figure
plot(t,encVelFiltered)
hold on
plot(t,encoderVelfilteredPrior)
plot(t,encoderVel)
title("Encoder Velocity | Brandon Lim u1244501")
xlabel("Time [sec]")
ylabel("Encoder Velocity")
legend("Encoder Velocity Filtered After", "Encoder Velocity Filtered Before","Encoder Velocity Raw")
%% Problem 4
clear, clc, close all
rw = 2; %cm
D = 50; %cm

xdesired = 50; %cm
thetad(1) = 0; %radians
tdesired = 5; %sec
deltat = 0.1; %sec

%a) 
thetaf = xdesired/rw; %radians
wd = thetaf/tdesired;
i = 1;
while thetad < thetaf 
    thetad(i+1) = thetad(i) + wd * deltat;
    i = i + 1;
end

figure
plot(0:0.1:5,thetad,"k")
hold on
plot([5:10],thetaf*ones(6),"k")
xlabel("Time [Sec]")
ylabel("Theta Desired [Radians]")
title("Time vs Theta Desired for Wheels 1 & 2 | Brandon Lim u1244501")

%b)
yawAngle = pi; %desired turning angle in radians
thetafturn1 = (yawAngle * (D/2))/rw;
thetafturn2 = -(yawAngle * (D/2))/rw;
thetadturn1 = 0;
thetadturn2 = 0;
wd = thetafturn1/tdesired;
i = 1;
while thetadturn1 < thetafturn1
    thetadturn1(i+1) = thetadturn1(i) +wd * deltat;
    thetadturn2(i+1) = thetadturn2(i) -wd * deltat;
    i = i + 1;
end

figure
plot(0:0.1:5,thetadturn1,"k")
hold on
plot([5:10],thetafturn1*ones(6),"k")
xlabel("Time [Sec]")
ylabel("Theta Desired [Radians]")
title("Time vs Theta Desired for Wheel 1 Turning | Brandon Lim u1244501")


figure
plot(0:0.1:5,thetadturn2,"k")
hold on
plot([5:10],thetafturn2*ones(6),"k")
xlabel("Time [Sec]")
ylabel("Theta Desired [Radians]")
title("Time vs Theta Desired for Wheel 2 TUrning | Brandon Lim u1244501")

%c)
R = 50; %cm
yawAnglec = pi/2;
innerwheelthetaf = (yawAnglec * R)/rw;
outerwheelthetaf = (yawAnglec * (R+D))/rw;
innerwheelthetad = 0;
outerwheelthetad = 0;
wdouter = outerwheelthetaf/tdesired;
wdinner = innerwheelthetaf/tdesired;
i = 1;
while innerwheelthetad<innerwheelthetaf
    innerwheelthetad(i+1) = innerwheelthetad(i) +wdinner * deltat;
    outerwheelthetad(i+1) = outerwheelthetad(i) +wdouter * deltat;
    i = i + 1;
end
figure
plot(0:0.1:5,innerwheelthetad,"k")
hold on
plot([5:10],innerwheelthetaf*ones(6),"k")
xlabel("Time [Sec]")
ylabel("Theta Desired [Radians]")
title("Time vs Theta Desired for Inner Arc Wheel | Brandon Lim u1244501")

figure
plot(0:0.1:5,outerwheelthetad,"k")
hold on
plot([5:10],outerwheelthetaf*ones(6),"k")
xlabel("Time [Sec]")
ylabel("Theta Desired [Radians]")
title("Time vs Theta Desired for Outer Arc Wheel | Brandon Lim u1244501")