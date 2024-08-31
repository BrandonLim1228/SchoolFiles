%Brandon Lim
%% Problem 3
clear, clc, close all
sut = 300; %mpa
suc = -600; %mpa

figure
%Plot Setup for BCM
%Axis centered about the origin
xline(0,"--",{"\sigma B"})
xlim([-750,550])
yline(0,"--",{"\sigma A"})
ylim([-750,550])
title("Problem 3","Brittle Mohr-Coulomb Theory for Sut = 300, Suc = -600")

hold on
grid on
%quadrant 1
plot(sut*[1,1,1,1,1],linspace(1,sut,5),'k')
plot(linspace(1,sut,5),sut*[1,1,1,1,1],'k')
%quadrant3
plot(suc*[1,1,1,1,1],linspace(1,suc,5),'k')
plot(linspace(1,suc,5),suc*[1,1,1,1,1],'k')
%quadrant2
plot(linspace(suc,0,5),linspace(0,sut,5),'k')
%quadrant4
plot(linspace(0,sut,5),linspace(suc,0,5),'k')
%Intersection Labels
text(320,-20,"Sut")
text(-70,320,"Sut")
text(-680,-20,"-Suc")
text(30,-620,"-Suc")

%Plotting cases a-c
%a)
plot(150,150,"square","MarkerFaceColor","k")
text(110,190,"case: a")
%b)
plot(96.57,-16.57,"square","MarkerFaceColor","k")
text(50,30,"case: b")
%c)
plot(161.8,-61.8,"square","MarkerFaceColor","k")
text(110,-90,"case: c")

%% Problem 5
clear, clc, close all
format long g
dmean = 15/1000; %m
dstd = (1.2/1000)/3; %m
l = 100/1000; %m
f = 550; %N
p = 4000; %N
T = 25; %Nm
sy = 280*10^6;

for i = 1:100000
    d(i) = norminv(rand,dmean,dstd);
    sigmaxA(i) = p/((pi/4)*d(i)^2);
    tauA(i) = ((16*T)/(pi*(d(i))^3)) - ((4*f)/(3*(pi/4) * d(i)^2));
    sigmaxB(i) = (p/((pi/4)*d(i)^2)) + ((f*l*(d(i)/2))/((pi/64)*(d(i))^4));
    tauB(i) = ((16*T)/(pi*(d(i))^3));

    sigmaoneA(i) = sigmaxA(i)/2 + sqrt((sigmaxA(i)/2)^2 + tauA(i)^2);
    sigmatwoA(i) = sigmaxA(i)/2 - sqrt((sigmaxA(i)/2)^2 + tauA(i)^2);

    sigmaoneB(i) = sigmaxB(i)/2 + sqrt((sigmaxB(i)/2)^2 + tauB(i)^2);
    sigmatwoB(i) = sigmaxB(i)/2 - sqrt((sigmaxB(i)/2)^2 + tauB(i)^2);

    sigmaeqA(i) = sqrt(sigmaoneA(i)^2-(sigmatwoA(i)*sigmaoneA(i))+sigmatwoA(i)^2);
    sigmaeqB(i) = sqrt(sigmaoneB(i)^2-(sigmatwoB(i)*sigmaoneB(i))+sigmatwoB(i)^2);

    nA(i) = sy/sigmaeqA(i);
    nB(i) = sy/sigmaeqB(i);

end

figure
histogram(nA)
figure
histogram(nB)

meanA = mean(nA)
stdA = std(nA)

meanB = mean(nB)
stdB = std(nB)

%% Problem 6
clear, clc, close all
sy = 270*10^6; %Pa
F = 2000; %N
P = 15000; %N
M = 150; %Nm
L = 0.1; %m
d = linspace(0.025,0.045,10); %m

for i = 1:length(d)
    sigmaone(i) = P/((pi/4) * d(i)^2);
    sigmatwo(i) = (F*L * (d(i)/2))/((pi/64)*d(i)^4);
    sigma(i) = sigmaone(i) + sigmatwo(i);

    tauT(i) = (16*M)/(pi*(d(i)^3));

    sigmaA(i) = sigma(i)/2 + sqrt((sigma(i)/2)^2 + tauT(i)^2);
    sigmaB(i) = sigma(i)/2 - sqrt((sigma(i)/2)^2 + tauT(i)^2);

    sigmaeq(i) = sqrt(sigmaA(i)^2 - sigmaA(i)*sigmaB(i) + sigmaB(i)^2);

    n(i) = sy/sigmaeq(i);
end

plot(d,n)
xlabel("Diameter [m]")
ylabel("Safety Factor")
title("Diamter vs Safety Factor")



