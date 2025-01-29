function [epsilon1, epsilon2, epsilon3, tauMax] = PrincipalStrain3D(A)
[V,D] = eig(A); %Finding principal stresses using eigen values

epsilonVec = sort([D(1), D(5), D(9)]);

%Principal strain Output
e1 = epsilonVec(3);
e2 = epsilonVec(2);
e3 = epsilonVec(1);

%Direction output 
d1 = find(D == e1);
d2 = find(D == e2);
d3 = find(D == e3);

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
epsilon1 = sprintf("Epsilon1=") + num2str(e1) + sprintf(", [l=%s, m=%s, n=%s]",num2str(direc1(1)),num2str(direc1(2)),num2str(direc1(3)));
epsilon2 = sprintf("Epsilon2=") + num2str(e2) + sprintf(", [l=%s, m=%s, n=%s]",num2str(direc2(1)),num2str(direc2(2)),num2str(direc2(3)));
epsilon3 = sprintf("Epsilon3=") + num2str(e3) + sprintf(", [l=%s, m=%s, n=%s]",num2str(direc3(1)),num2str(direc3(2)),num2str(direc3(3)));
tauMax = (e1 - e3);

end