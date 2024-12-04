function [r,rc,nw,sw,se,ne,no,we,so,ea]=bodyOfRevolution(xp,yp,nc)
% xp, yp -  1 by n vectors of points defining body profile,
%           yp(1)and yp(end) must be = 0. Otherwise yp>0 
%           xp must be in increasing order
% nc     -  number of distinct points on circumference

%Define vertices of panels
x=repmat(xp,[nc+1 1]);     %grid of x points
al=[0:nc]/(nc)*2*pi;    %vector of circumferential angles (about x axis)
y=cos(al)'*yp;
z=sin(al)'*yp;
r=zeros([3 size(x)]);r(1,:)=x(:);r(2,:)=y(:);r(3,:)=z(:); %position vector of vertices
ri=reshape(1:prod(size(x)),size(x)); %index of vertices

%panel index is index of upper left vertex (i.e. panel i,j has corners i,j  i+1,j  i+1,j+1  i,j+1)
nw=ri(1:end-1,1:end-1);sw=ri(2:end,1:end-1); %indices of upper left and lower left corners
ne=ri(1:end-1,2:end);se=ri(2:end,2:end); %indices of upper right and lower right corners

% determine panel centers (control points) and indices 
rc=(r(:,nw)+r(:,sw)+r(:,ne)+r(:,se))/4;rc=reshape(rc,[3 size(nw)]);
ci=reshape(1:prod(size(nw)),size(nw));

% determine indices of panels bordering each control point
no=ci([end 1:end-1],:);so=ci([2:end 1],:); %Panels above and below. For body of rev., row indices terminate on zero longitude, so should wrap here.
we=ci(:,[1 1:end-1]);ea=ci(:,[2:end end]); %Panels to left and right. For body of rev., column indices terminate at grid edges (poles) so repeat edge point here
