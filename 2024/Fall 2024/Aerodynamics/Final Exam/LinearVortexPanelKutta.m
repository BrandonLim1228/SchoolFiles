clear, clc, close all
%NACA0020 air foil
data = readmatrix("NACA0020.txt");
x = data(:,1)';
y = data(:,2)';
z = x + i*y; npanels = 150; k = npanels; alpha = [-20:20]*pi/180;
for nn = 1:length(alpha)
    winf = exp(-i*alpha(nn));
        
    a=[1:npanels];b=[2:npanels 1];c=[3:npanels 1 2];
    dzds=(z(b)-z(a))./abs(z(b)-z(a));
    
    eps=0.0001;
    zc=(z(a)+z(b))/2-i*eps*(z(b)-z(a)); %control points
    
    cm=zeros(npanels);
    for m=1:npanels
        cm(:,m)=-i*(((zc(m)-z(a))./(z(b)-z(a)).*log((zc(m)-z(a))./(zc(m)-z(b)))-1)./dzds(a)/2/pi...
           -((zc(m)-z(c))./(z(b)-z(c)).*log((zc(m)-z(c))./(zc(m)-z(b)))-1)./dzds(b)/2/pi)*dzds(m);
    end
    res=imag(-winf*dzds);
    cm1=imag(cm);cm1(:,end)=0;cm1(k,end)=1;
    res(end)=0;
    q=res/cm1;

    ut=real(q*cm+winf*dzds);
    cp=1-ut.^2/abs(winf).^2;

    cy(nn) = sum(real(z(b) - z(a)) .* (cp));
    cx(nn) = sum(imag(z(b) - z(a)) .* (cp));
end

cl = cy.*cos(alpha) - cx.*sin(alpha);
figure
plot(alpha*180/pi,cl,'ro');
xlabel("Angle of Attack [Deg]")
ylabel("Coefficient of Lift")
title("Angle of Attack vs Coefficient of Lift for NACA0020")

