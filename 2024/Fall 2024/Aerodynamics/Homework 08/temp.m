%3D doublet panel method for acyclic flow around 3D bodies.
clear all;
vinf=[1;0;.3]; %free stream velocity

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

% determine surface area and normal vectors at control points (assumes counter clockwise around compass by RH rule points out of surface)
ac=0.5*v_cross(r(:,sw)-r(:,ne),r(:,se)-r(:,nw));nc=ac./v_mag(ac);

%determine influence coefficient matrix coef
npanels=length(rc(1,:));coef=zeros(npanels); 
for n=1:npanels
    cmn=ffil(rc(:,n),r(:,nw),r(:,sw))+ffil(rc(:,n),r(:,sw),r(:,se))+ffil(rc(:,n),r(:,se),r(:,ne))+ffil(rc(:,n),r(:,ne),r(:,nw));
    coef(n,:)=nc(1,n)*cmn(1,:)+nc(2,n)*cmn(2,:)+nc(3,n)*cmn(3,:);
end

%determine result vector and solve matrix for filament strengths
rm=(-nc(1,:)*vinf(1)-nc(2,:)*vinf(2)-nc(3,:)*vinf(3))';
coef(end+1,1:end/2)=1;coef(end,end/2+1:end)=0;rm(end+1)=0; %Sum of panel strengths on first body zero
coef(end+1,1:end/2)=0;coef(end,end/2+1:end)=1;rm(end+1)=0; %Sum of panel strengths on second body zero
ga=coef\rm;

%Determine velocity and pressure at control points
ga=repmat(ga',[3 1]); 
for n=1:npanels     %Determine velocity at each c.p. without principal value
    cmn=ffil(rc(:,n),r(:,nw),r(:,sw))+ffil(rc(:,n),r(:,sw),r(:,se))+ffil(rc(:,n),r(:,se),r(:,ne))+ffil(rc(:,n),r(:,ne),r(:,nw));
    v(:,n)=vinf+sum(ga.*cmn,2);
end                 %Determine principle value of velocity at each c.p., -grad(ga)/2
gg=v_cross((rc(:,we)-rc(:,no)).*(ga(:,we)+ga(:,no))+(rc(:,so)-rc(:,we)).*(ga(:,so)+ga(:,we))+(rc(:,ea)-rc(:,so)).*(ga(:,ea)+ga(:,so))+(rc(:,no)-rc(:,ea)).*(ga(:,no)+ga(:,ea)),nc)./v_mag(v_cross(rc(:,no)-rc(:,so),rc(:,we)-rc(:,ea)));

v=v-gg/2; %velocity vector
cp=1-sum(v.^2)/(vinf'*vinf); %pressure

%plotting surface pressure distribution and velocity vectors
h3=figure;
xl=-1.5;xh=1.5;yl=-1.5;yh=1.5;zl=-1.5;zh=1.5;cl=-2;ch=1; % axis limits
xplot=[r(1,nw);r(1,sw);r(1,se);r(1,ne)];yplot=[r(2,nw);r(2,sw);r(2,se);r(2,ne)];zplot=[r(3,nw);r(3,sw);r(3,se);r(3,ne)];
fill3(xplot,yplot,zplot,cp(:)');hold on
quiver3(rc(1,:),rc(2,:),rc(3,:),v(1,:),v(2,:),v(3,:));
axis image;axis([xl xh yl yh zl zh cl ch]);axis vis3d;
colorbar;set(gca,'Xgrid','on');set(gca,'Ygrid','on');set(gca,'Zgrid','on');
xlabel('x');ylabel('y');zlabel('z');title('C_p');

%Compute moment coefficients
cp1=repmat(cp,[3 1]);;
volume=sum(dot(rc(:,:),ac(:,:)))/3; %Volume is the integral(position dot d(area vector))/3
Cm=sum(-cp1(:,:).*v_cross(rc(:,:),ac(:,:)),2)/volume; %Moments are the -Integral(pressure position x d(area vector))
results=sprintf('Moment Coefficients \nC_R =% 6.4f\nC_P =% 6.4f\nC_Y =% 6.4f',Cm(1),Cm(2),Cm(3));
disp(results)

pause
%Extra code for plotting streamlines
fp=get(gcf,'Position');fp(3)=fp(3)/2;fp(4)=fp(4)/2;
h2=figure;set(gcf,'Position',fp);
line(yplot,zplot);hold on;
axis image;axis([yl yh zl zh]);
hhh=gca;
set(gca,'xDir','reverse');
xlabel('y');ylabel('z');title('Click to start streamline, off plot to exit');
streamstep=.05; 
while 1 
    rs=[xl+(xh-xl)*.01;0;0];axes(hhh);[rs(2),rs(3)]=ginput(1); %All streamlines start near x=xl
    if rs(2)<yl | rs(2)>yh | rs(3)<zl | rs(3)>zh break;end
    plot(rs(2),rs(3),'k+');cntr=0;figure(h3);
    while rs(1)>xl & rs(1)<xh & rs(2)>yl & rs(2)<yh & rs(3)>zl & rs(3)<zh & cntr<500  
        cmn=ffil(rs,r(:,nw),r(:,sw))+ffil(rs,r(:,sw),r(:,se))+ffil(rs,r(:,se),r(:,ne))+ffil(rs,r(:,ne),r(:,nw));
        v=vinf+sum(ga.*cmn,2);vm=sqrt(sum(v.^2));
        rs1=rs+streamstep*v/vm;
        cmn=ffil(rs1,r(:,nw),r(:,sw))+ffil(rs1,r(:,sw),r(:,se))+ffil(rs1,r(:,se),r(:,ne))+ffil(rs1,r(:,ne),r(:,nw));
        v1=(v+vinf+sum(ga.*cmn,2))/2;vm=sqrt(sum(v.^2));
        rs1=rs+streamstep*v1/vm;
        plot3([rs(1) rs1(1)],[rs(2) rs1(2)],[rs(3) rs1(3)],'b-');
        rs=rs1;cntr=cntr+1;
    end
    figure(h2);
end
hold off;
