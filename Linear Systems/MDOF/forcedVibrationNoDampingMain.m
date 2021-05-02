clear all;
close all;
clc; 

%System Parameters
m1 = 5;
m2 = 5;
k1 = 10;
k2 = 10;
k3 = 10;
f1 = 1;
f2 = 0;
omega = [0:0.005:5];

%Matricies
M = [m1 0;
    0   m2];

K = [k1+k2 -k2;
    -k2   k2+k3];

F = [f1;
    f2];

%Initialize the transmissibility matrix
trans = zeros(2,length(omega));

%For loop for all frequencies
for i = 1:1:length(omega)    
    i
    trans(:,i) = abs(forcedVibrationNoDamping(K,M,F,omega(i)));
end

%Plot 
plot(omega,trans)