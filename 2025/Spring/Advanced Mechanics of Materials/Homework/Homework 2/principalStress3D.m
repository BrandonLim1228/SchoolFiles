function [sigma1, sigma2, sigma3, tauMax] = principalStress3D(A)

[V,D] = eig(A); %Finding principal stresses using eigen values

sigmaVec = sort([D(1), D(5), D(9)]);

%Principal Stress Output
s1 = sigmaVec(3);
s2 = sigmaVec(2);
s3 = sigmaVec(1);

%Direction output 
d1 = find(D == s1);
d2 = find(D == s2);
d3 = find(D == s3);

%Finding directions
if d1 == 1
    direc1 = V(:,1);
elseif d1 == 5
    direc1 = V(:,2);
else
    direc1 = V(:,3);
end

if d2 == 1
    direc2 = V(:,1);
elseif d2 == 5
    direc2 = V(:,2);
else
    direc2 = V(:,3);
end

if d3 == 1
    direc3 = V(:,1);
elseif d3 == 5
    direc3 = V(:,2);
else
    direc3 = V(:,3);
end

%Outputs
sigma1 = sprintf("Sigma1=") + num2str(s1) + sprintf(", [l=%s, m=%s, n=%s]",num2str(direc1(1)),num2str(direc1(2)),num2str(direc1(3)));
sigma2 = sprintf("Sigma2=") + num2str(s2) + sprintf(", [l=%s, m=%s, n=%s]",num2str(direc2(1)),num2str(direc2(2)),num2str(direc2(3)));
sigma3 = sprintf("Sigma3=") + num2str(s3) + sprintf(", [l=%s, m=%s, n=%s]",num2str(direc3(1)),num2str(direc3(2)),num2str(direc3(3)));
tauMax = (1/2) * (s1 - s3);


end