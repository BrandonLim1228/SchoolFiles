%3D doublet panel method for lifting wings.
clear all;
vinf=[cosd(3);0;sind(3)]; %free stream velocity

%Specify wing geometry (NACA 0012 section)
xp=[1	0.9	0.8	0.7	0.6	0.5	0.4	0.3	0.25	0.2	0.15	0.1	0.075	0.05	0.025	0.0125	0	0.0125	0.025	0.05	0.075	0.1	0.15	0.2	0.25	0.3	0.4	0.5	0.6	0.7	0.8	0.9 1];
zp=[0	0.01448	0.02623	0.03664	0.04563	0.05294	0.05803	0.06002	0.05941	0.05737	0.05345	0.04683	0.042	0.03555	0.02615	0.01894	0	-0.01894	-0.02615	-0.03555	-0.042	-0.04683	-0.05345	-0.05737	-0.05941	-0.06002	-0.05803	-0.05294	-0.04563	-0.03664	-0.02623	-0.01448 0];
nb=25;b=2.5;sweep=30;dihedral=15;twist=10;taper=.5;
[r,rc,nw,sw,se,ne,no,we,so,ea,wp,bp]=wing(xp,zp,b,nb,vinf,sweep,dihedral,twist,taper);
xl=-1;xh=5;yl=-3;yh=3.5;zl=-1;zh=1;cl=-2;ch=1; % plotting limits

% determine surface area and outward pointing normal vectors at control points (assumes counter clockwise around compass by RH rule points out of surface)
ac=0.5*v_cross(r(:,sw)-r(:,ne),r(:,se)-r(:,nw));nc=ac./v_mag(ac);

%determine influence coefficient matrix
npanels=length(rc(1,:));coef=zeros(npanels);
for nn=1:length(bp)
    n=bp(nn);
    cmn=ffil(rc(:,n),r(:,nw),r(:,sw))+ffil(rc(:,n),r(:,sw),r(:,se))+ffil(rc(:,n),r(:,se),r(:,ne))+ffil(rc(:,n),r(:,ne),r(:,nw));
    coef(n,:)=nc(1,n)*cmn(1,:)+nc(2,n)*cmn(2,:)+nc(3,n)*cmn(3,:);
end
for nn=2:length(wp)
    n=wp(nn);
    coef(n,ea(n))=1;coef(n,we(n))=-1;coef(n,n)=1;
end

%determine result matrix
rm=(-nc(1,:)*vinf(1)-nc(2,:)*vinf(2)-nc(3,:)*vinf(3))';
rm(wp)=0;
coef(end+1,bp)=1;rm(end+1)=0; %prevents singular matrix - sum of panel strengths on closed body is zero
ga=coef\rm;

%Determine velocity and pressure at control points
ga=repmat(ga',[3 1]); 
for n=1:npanels     %Determine velocity at each c.p. without principal value
    cmn=ffil(rc(:,n),r(:,nw),r(:,sw))+ffil(rc(:,n),r(:,sw),r(:,se))+ffil(rc(:,n),r(:,se),r(:,ne))+ffil(rc(:,n),r(:,ne),r(:,nw));
    v(:,n)=vinf+sum(ga.*cmn,2);
end                 %Determine principle value of velocity at each c.p., -grad(ga)/2
gg=v_cross((rc(:,we)-rc(:,no)).*(ga(:,we)+ga(:,no))+(rc(:,so)-rc(:,we)).*(ga(:,so)+ga(:,we))+(rc(:,ea)-rc(:,so)).*(ga(:,ea)+ga(:,so))+(rc(:,no)-rc(:,ea)).*(ga(:,no)+ga(:,ea)),nc)./v_mag(v_cross(rc(:,no)-rc(:,so),rc(:,we)-rc(:,ea)));
te=find([1:npanels]'==ea(:));gg(:,te)=gg(:,te)/2;
te=find([1:npanels]'==we(:));gg(:,te)=gg(:,te)/2;

v=v-gg/2; %velocity vector
cp=1-sum(v.^2)/(vinf'*vinf); %pressure

h3=figure;
xplot=[r(1,nw(bp));r(1,sw(bp));r(1,se(bp));r(1,ne(bp))];yplot=[r(2,nw(bp));r(2,sw(bp));r(2,se(bp));r(2,ne(bp))];zplot=[r(3,nw(bp));r(3,sw(bp));r(3,se(bp));r(3,ne(bp))];
fill3(xplot,yplot,zplot,cp((bp)));hold on
quiver3(rc(1,bp),rc(2,bp),rc(3,bp),v(1,bp),v(2,bp),v(3,bp));
axis image;axis([xl xh yl yh zl zh cl ch]);axis vis3d;
colorbar;set(gca,'Xgrid','on');set(gca,'Ygrid','on');set(gca,'Zgrid','on');
xlabel('x');ylabel('y');zlabel('z');title('C_p');

%Compute forces and moments
cp1=repmat(cp,[3 1]);area=sum(abs(ac(3,bp)))/2;cbar=area/b;alpha=atan(vinf(3)/vinf(1));
rc1=rc;rc1(1,:)=rc1(1,:)-0.25; %Compute moments about quarter chord
Cf=sum(-cp1(:,bp).*ac(:,bp),2)/area; %Forces are the -Integral(pressure d(area vector))
Cm=sum(-cp1(:,bp).*v_cross(rc1(:,bp),ac(:,bp)),2)/area/cbar; %Moments are the -Integral(pressure position x d(area vector))
Cl=Cf(3)*cos(alpha)-Cf(1)*sin(alpha);Cd=Cf(3)*sin(alpha)+Cf(1)*cos(alpha);
results=sprintf('Forces and Moments \nC_X =% 6.4f  C_R =% 6.4f\nC_Y =% 6.4f C_P =% 6.4f\nC_Z =% 6.4f  C_Y =% 6.4f\nC_L =% 6.4f\nC_D =% 6.4f\n',Cf(1),Cm(1),Cf(2),Cm(2),Cf(3),Cm(3),Cl,Cd);
disp(results);

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
