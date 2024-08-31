%Brandon Lim
clear, clc, close all

sys = tf(1.538,[0.0615, 1]);
figure
subplot(2,1,1)
step(sys)
title("Unit Step Response of Motor Transfer Function | Brandon Lim")
ylabel("Veloctiy")
xlabel("Time")


tau = 0.0615;
tauss = 4*tau;
omegass = 1.538;
subplot(2,1,2)
plot(linspace(0,tauss,10),ones(10))
ylabel("Voltage")
xlabel("Time")

t = linspace(0,tauss,100);
omega = omegass.*(1-exp(-t./tau));

figure
plot(t,log(1-(omega./omegass)))
xlabel("Time [s]");
ylabel("ln(1-(omega_t/omega_s_s))")
title("Time vs ln(1-(omega_t/omega_s_s)) | Brandon Lim u1244501")

