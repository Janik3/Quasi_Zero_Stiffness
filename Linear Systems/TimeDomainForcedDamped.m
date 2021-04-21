clear all;
close all;
clc;

addpath(genpath('\\north.cfs.uoguelph.ca\soe-other-home$\jhabegge\My Documents\MASc\Matlab\ZSS')) % add all subfolders to path

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
omega = 2;

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

%time and initial conditions
time = 0:0.01:200;
IC = [0;0;0;0];

%ODE45 options
solverOptions = odeset('RelTol',1e-5, 'AbsTol', 1e-5);

%do a frequency sweep
for i = 1:1:500
    omega = i/100
    [T,X] = ode45(@StateSpaceForcedDamped,time,IC,solverOptions,M,D,F,omega);
    
    %calculate the transmission ratio 
    trans1(i) = ampratiomeasure(f1*cos(omega*time),X(:,1));
    trans2(i) = ampratiomeasure(f1*cos(omega*time),X(:,2));
    freq_trans(i) = omega;
    
end


%TO DO
%calculate and plot transmissibility, see if it matches the analytical
%move on to nonlinear sims
figure
hold on;
plot(freq_trans,trans1)
plot(freq_trans,trans2)
hold off;


