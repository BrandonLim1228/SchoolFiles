function c=v_dot(a,b);
c=zeros(size(a));
c(1,:)=a(1,:).*b(1,:)+a(2,:).*b(2,:)+a(3,:).*b(3,:);
c(2,:)=c(1,:);c(3,:)=c(1,:);

