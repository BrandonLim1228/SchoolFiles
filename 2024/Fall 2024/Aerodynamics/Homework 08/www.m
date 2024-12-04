%Parabolic dihedral. Replace line 20 of wing.m with...
z=z+abs(y).*tan(dihedral).*abs(y)/b*2; 
%...then change it back to...
z=z+abs(y).*tan(dihedral);
%...or all your subsequent wings will have parabolic forms

%Margason et al. (1985) wing. Replace line 8 of DoubletPanel3DWing.m with...
nb=25;b=2.25;sweep=45;dihedral=0;twist=0;taper=0.5;

%Clark Y Wing. Replace lines 3 through 10 of DoubletPanel3DWing.m with...
alpha=5;alpha=(5+2)*pi/180;
vinf=[cos(alpha);0;sin(alpha)]; %free stream velocity
%Specify wing geometry (Clark Y section, by convention section data is given with z coordinate origin offset 2 deg from chord line. AoA measured from this offset!)
xp=[1	0.9	0.8	0.7	0.6	0.5	0.4	0.3	0.2	0.15	0.1	0.075	0.05	0.025	0.0125	0	0.0125	0.025	0.05	0.075	0.1	0.15	0.2	0.3	0.4	0.5	0.6	0.7	0.8	0.9 1];
zp=[0 .028 .0522 .0735 .0915 .102 .114 .117 .113 .106 .096 .088 .079 .065 .0545 .035 .0193 .0147 .0093 .0063 .0042 .000915 .000603  0 0 0 0 0 0 0 0];
zp=zp-(1-xp)*.035; %correct for offset (makes true chordline parallel to x, must add 2 deg. to AoA's now though).
nb=25;b=5.6;sweep=0;dihedral=0;twist=0;taper=1;
[r,rc,nw,sw,se,ne,no,we,so,ea,wp,bp]=wing(xp,zp,b,nb,vinf,sweep,dihedral,twist,taper);
xl=-1;xh=2;yl=-3;yh=3;zl=-1;zh=1;cl=-2;ch=1; % plot limits




