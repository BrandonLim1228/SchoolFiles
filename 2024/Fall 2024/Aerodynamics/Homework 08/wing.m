function [r,rc,nw,sw,se,ne,no,we,so,ea,wp,bp]=wing(xp,zp,b,nb,vinf,sweep,dihedral,twist,taper)
% xp, zp -  1 by n vectors of points wing section, counterclockwise from trailing edge
% b      -  span
% nb     -  number of distinct points across the span
sweep=sweep*pi/180;dihedral=dihedral*pi/180;twist=twist*pi/180;

%Define vertices of panels
yp=([0:nb+1]-1)/(nb-1)*b-b/2; %evenly spaced points across span, one extra point at each end to close tips
x=repmat(xp,[nb+2 1])-0.25;     %grid of x points, shift quarter chord to origin
y=repmat(yp',[1 length(xp)]);
z=repmat(zp,[nb+2 1]);
z(1,:)=0;z(end,:)=0;y(1,:)=y(2,:);y(end,:)=y(end-1,:); %close tips

z=z.*(1+2*(taper-1)/b*abs(y));    %apply linear taper
x=x.*(1+2*(taper-1)/b*abs(y)); 
lt=(twist*2*abs(y)/b);            %apply linear twist
z1=z.*cos(lt)-x.*sin(lt);
x1=x.*cos(lt)+z.*sin(lt);       
x=x1;z=z1;
z=z+abs(y).*tan(dihedral);        %apply dihedral
x=x+abs(y).*tan(sweep);           %apply sweep
x=x+.25;                          %return leading edge to origin

%Add wake panels for trailing edge Kutta condition. Wake panels end up being last array column
wakelength=50; % number of chordlengths to extend wake panels downstrem of t.e. 
mvinf=sqrt(vinf(1)^2+vinf(2)^2); 
x(:,end+1)=x(:,end)+vinf(1)/mvinf*wakelength; %Extend wake panels downstream in the plane of the root chord 
y(:,end+1)=y(:,end)+vinf(2)/mvinf*wakelength; %(but with any side slip of the free stream)
z(:,end+1)=z(:,end); 

r=zeros([3 size(x)]);r(1,:)=x(:);r(2,:)=y(:);r(3,:)=z(:); %position vector of vertices
ri=reshape(1:prod(size(x)),size(x)); %index of vertices

%panel index is index of upper left vertex (i.e. panel i,j has corners i,j  i+1,j  i+1,j+1  i,j+1)
nw=ri(1:end-1,1:end-1);sw=ri(2:end,1:end-1); %indices of upper left and lower left corners
ne=ri(1:end-1,2:end);se=ri(2:end,2:end); %indices of upper right and lower right corners

% determine panel centers (control points) and indices 
rc=(r(:,nw)+r(:,sw)+r(:,ne)+r(:,se))/4;rc=reshape(rc,[3 size(nw)]);
ci=reshape(1:prod(size(nw)),size(nw));
wp=ci(:,end);wp=wp(:); %index of all the wake panels
bp=ci(:,1:end-1);bp=bp(:); %index of all the wing (body) panels

% determine indices of panels bordering each control point
no=ci([1 1:end-1],:);so=ci([2:end end],:); %Panels north and south 
we=ci(:,[1 1:end-1]);ea=ci(:,[2:end-1 end-1 1]); %Panels west and east. For last column, these are the two t.e. panels that the wake panel cancels


