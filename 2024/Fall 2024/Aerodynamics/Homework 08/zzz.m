%4:1 Prolate spheroid, substitute for line 6
th=-pi/2:pi/30:pi/2;xp=sin(th);yp=cos(th)/4;nc=20;

%NACA 0030 body of revolution, substitute for line 6
xp=[0	0.025	0.075	0.15	0.2	0.3	0.4	0.5	0.6	0.7	0.8	0.9	1]*2-1;
yp=[0	0.02615	0.042	0.05345	0.05737	0.06002	0.05803	0.05294	0.04563	0.03664	0.02623	0.01448		0]*5;
nc=20;

%Two prolate spheroids, substitute for line 6 and 7... 
th=-pi/2:pi/20:pi/2;xp=sin(th);yp=cos(th)/2;nc=20;
[r1,rc1,nw1,sw1,se1,ne1,no1,we1,so1,ea1]=bodyOfRevolution(xp,yp,nc);
r1(3,:)=r1(3,:)-0.6;rc1(3,:)=rc1(3,:)-0.6; % shift first ellipsoid down to -0.6
[r2,rc2,nw2,sw2,se2,ne2,no2,we2,so2,ea2]=bodyOfRevolution(xp,yp,nc);
r2(3,:)=r2(3,:)+0.6;rc2(3,:)=rc2(3,:)+0.6; % shift second ellipsoid up to 0.6
r=[r1(:,:) r2(:,:)]; %combine bodies
nw=[nw1(:); nw2(:)+length(r1(1,:))];sw=[sw1(:); sw2(:)+length(r1(1,:))];
ne=[ne1(:); ne2(:)+length(r1(1,:))];se=[se1(:); se2(:)+length(r1(1,:))];
rc=[rc1(:,:) rc2(:,:)];
no=[no1(:); no2(:)+length(no1(:))];so=[so1(:); so2(:)+length(so1(:))];
ea=[ea1(:); ea2(:)+length(ea1(:))];we=[we1(:); we2(:)+length(we1(:))];
%...and substitute these for line 21
coef(end+1,1:end/2)=1;coef(end,end/2+1:end)=0;rm(end+1)=0; %Sum of panel strengths on first body zero
coef(end+1,1:end/2)=0;coef(end,end/2+1:end)=1;rm(end+1)=0; %Sum of panel strengths on second body zero
