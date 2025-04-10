%Brandon Lim HW11
clear, clc, close all

A = [-3 5; 0 -2];
B = [1; -1];
C = [1 0];

O = [C; C*A];
RankO= rank(O);

