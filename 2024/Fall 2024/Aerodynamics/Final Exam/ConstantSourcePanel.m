clear all;
%Circular cylinder example, radius 2, 35 panels
npanels=35;r=2;Vinf=1;
z=r*exp(1i*[2*pi/npanels:2*pi/npanels:2*pi]);
a=1:npanels;b=[2:npanels 1];
dzds=(z(b)-z(a))./abs(z(b)-z(a));

eps=0.0001;
zc=(z(a)+z(b))/2-i*eps*(z(b)-z(a)); %control points
winf = Vinf - ((Vinf .* (r.^2))./(zc.^2)) + ((Vinf .* r .* i)./(2.*pi.*(zc - 2.*r.*i)));
cm=zeros(npanels);
for m=1:npanels
    cm(:,m)=log((zc(m)-z(a))./(zc(m)-z(b)))/2/pi./dzds(a)*dzds(m);
end
res=imag(-winf.*dzds);
q=res/imag(cm);
ut=real(q*cm+winf.*dzds);
cp=1-ut.^2/1;
figure
plot(angle(zc)*180/pi,cp,'ko');
fontsize(15,"points");
pause
%Extra code for plotting streamlines
figure;
plot([z(a);z(b)],'k');hold on;plot(zc,'k.');axis image;
fontsize(15,"points");
title('Click on plot to start streamline, outside plot to exit');
xl=-8;xh=8;yl=-8;yh=8;axis([xl xh yl yh]);
streamstep=.05;
[x,y]=ginput(1);
while x>xl & x<xh & y>yl & y<yh
    cntr=0;
    while x>xl & x<xh & y>yl & y<yh & cntr<500
        zp=x+i*y;
        w=winf+q/2/pi*(log((zp-z(a))./(zp-z(b)))./dzds(a)).';
        x1=x+streamstep*real(w)/abs(w);y1=y-streamstep*imag(w)/abs(w);zp=x1+i*y1;
        w1=winf+q/2/pi*(log((zp-z(a))./(zp-z(b)))./dzds(a)).';
        w=(w+w1)/2;
        x1=x+streamstep*real(w)/abs(w);y1=y-streamstep*imag(w)/abs(w);
        plot([x x1],[y y1],'b-');
        x=x1;y=y1;cntr=cntr+1;
    end
    [x,y]=ginput(1);
end
hold off;