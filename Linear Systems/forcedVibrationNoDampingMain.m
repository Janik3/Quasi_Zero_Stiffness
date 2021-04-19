clear all;
close all;
clc; 

m1 = 5;
m2 = 5;
k1 = 10;
k2 = 10;
f1 = 1;
f2 = 0;
omega = [0:0.005:5];

M = [m1 0;
    0   m2];

K = [k1+k2 -k2;
    -k2   k2];

F = [f1;
    f2];

trans = zeros(2,length(omega));

for i = 1:1:length(omega)    
    i
    trans(:,i) = abs(forcedVibrationNoDamping(K,M,F,omega(i)));
end

plot(omega,trans)