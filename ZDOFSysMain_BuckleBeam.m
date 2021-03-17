% This program requires a "Figures" and "Files" folder be created in the
% same folder as the program 

clear all;
close all;
clc;

addpath(genpath(pwd)) % add all subfolders to path

%% Define the system variables
L = 4/12*.3048; % origional length of beams (converting inches to m)
a = 3.5/12*.3048; % horizontal distance from wall to center portion (converting inches to m)
q_0 = 0.25/12*.3048; %initial imperfection (converting inches to m)

preload_Dist = 2/12*.3048; % preload on the vertical spring when x=0 (converting inches to m)

E = 70e9; %steel
b = 0.05; %in m
h = 0.001214; %in m, 18 gauge sheet metal https://www.metalsupermarkets.com/sheet-metal-gauge-chart/
%h = 0.000911; %in m, 20 gauge sheet metal
I = b*h^3/12; %moment of inertia

P_e = E*I*(pi/L)^2; %is the classical Euler critical load for hinged–hinged boundary

%% Create F and K plots for the designed Zero Stiffness System

a_vec = [3.2:0.1:3.8]/12*.3048;

%K_v = 16196.589007492983892102766095467;


for i=1:length(a_vec)
    a = a_vec(length(a_vec)-i+1);
    h_0 = sqrt(L^2-a^2);
    % The horizontal (negative stifness portions)
    syms 'x' 
    F = BuckleBeam(x, P_e, a, L, q_0);
    k = diff(F);

    %Convert to numbers
    x_nums(i,:) = [0:h_0*2/1000:h_0*2];
    F_nums = vpa(subs(F,x,x_nums(i,:)));
    K_nums = vpa(subs(k,x,x_nums(i,:)));

    %Plots for the negative stiffness system
    figure
    subplot(2,1,1);
    hold on; 
    plot(x_nums(i,:), F_nums);
    ylabel('F [N]')
    xlabel('Displacement from top [m]')
    title('Overall force of negative stiffness system')
    subplot(2,1,2)
    plot(x_nums(i,:), K_nums);
    ylabel('K [N/m]')
    xlabel('Displacement from top [m]')
    title('Stiffness of negative stiffness system')
    hold off; 

    %K_v = -K_nums(h_0/(h_0*2/1000)) ; %vertical spring stiffness that provides zero stiffness
    K_v = -vpa(subs(k,x,h_0))
    % K_v = 17513.38

    % F and K for the Zero Stiffness System (negative stiffness + positive
    % stiffness) 
    F_tot = BuckleBeam(x, P_e, a, L, q_0) + F_vertSpring_y(x, K_v, preload_Dist);
    k_tot = diff(F_tot);

    %Convert to numbers
    %x_nums = [0:h_0*2/1000:h_0*2];
    F_tot_nums(i,:) = vpa(subs(F_tot,x,x_nums(i,:)));
    K_tot_nums(i,:) = vpa(subs(k_tot,x,x_nums(i,:)));

end

%Plots for the zero stiffness system
figure
subplot(2,1,1);
hold on; 
plot(transpose(x_nums), transpose(F_tot_nums));
ylabel('F [N]')
xlabel('Displacement from top [m]')
title('Overall force of zero stiffness system')
subplot(2,1,2)
plot(transpose(x_nums), transpose(K_tot_nums));
ylabel('K [N/m]')
xlabel('Displacement from top [m]')
title('Stiffness of zero stiffness system')
hold off;


