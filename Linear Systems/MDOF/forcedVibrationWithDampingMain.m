clear all;
close all;
clc;

%Proves that both models match when damping is zero

%System paameters
m1 = 5;
m2 = 5;
k1 = 10;
k2 = 10;
k3 = 10;
c1 = 5;
c2 = 5;
c3 = 5;
f1 = 1;
f2 = 0;
omega = [0:0.005:5];

%System matricies
M = [1 0 0 0;
    0 1 0 0 ;
    0 0 m1 0;
    0 0 0 m2];
D = [ 0 0 -1 0;
    0 0 0 -1;
    k1+k2 -k2 c1+c2 -c2;
    -k2   k2+k3 -c2   c2+c3];
F = [0;
    0;
    f1;
    f2];

nStates = 4
nDOF = 2
F = zeros([nStates,1]);
    F(1,1) = c1/m1;
    if nDOF > 1
        F(nDOF+1,1) = (-(c1*(c1+c2))/(m1*m1))+(k1/m1);
        F(nDOF+2,1) = (c1*c2)/(m1*m2);
    end

%empty arrays
dampedTrans = zeros(length(omega),2);

%for loop across all frequencies
for i = 1:1:length(omega) 
    %Note the phase is not passed back here (nowhere to put it)
    dampedTrans(i,:) = abs(forcedVibrationWithDamping(D,M,F,omega(i)));
end


%Matricies
M1 = [m1 0;
    0   m2];

K1 = [k1+k2 -k2;
    -k2   k2+k3];

F1 = [f1;
    f2];

%Initialize the transmissibility matrix
undampedTrans = zeros(2,length(omega));

%For loop for all frequencies
for i = 1:1:length(omega)    
    undampedTrans(:,i) = abs(forcedVibrationNoDamping(K1,M1,F1,omega(i)));
end

%Plots
figure
hold on;
plot(omega,dampedTrans(:,1))
plot(omega,undampedTrans(1,:))
hold off;
title('Mass 1')

figure
hold on;
plot(omega,dampedTrans(:,2))
plot(omega,undampedTrans(2,:))
hold off;
title('Mass 2')