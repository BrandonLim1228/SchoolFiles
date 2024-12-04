function q=ffil(r,rs,re);

warning off;
r1(1,:)=rs(1,:)-r(1,:); r1(2,:)=rs(2,:)-r(2,:); r1(3,:)=rs(3,:)-r(3,:);
r2(1,:)=re(1,:)-r(1,:); r2(2,:)=re(2,:)-r(2,:); r2(3,:)=re(3,:)-r(3,:);
r0(1,:)=r1(1,:)-r2(1,:);r0(2,:)=r1(2,:)-r2(2,:);r0(3,:)=r1(3,:)-r2(3,:);
c=v_cross(r1,r2);
c2=v_dot(c,c);
q=c./c2.*v_dot(r0,r1./v_mag(r1)-r2./v_mag(r2))/4/pi;
q(isnan(q))=0;
warning on;
