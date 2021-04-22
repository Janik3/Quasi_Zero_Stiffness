% This program requires a "Figures" and "Files" folder be created in the
% same folder as the program 
addpath(genpath('\\north.cfs.uoguelph.ca\soe-other-home$\jhabegge\My Documents\MASc\Matlab\ZSS')) % add all subfolders to path
clear all;
close all;
clc;

%% Define the system variables
h_0 = 4/12*.3048 % initial height from horizontal to top (converting inches to m)
L_0 = 6/12*.3048; %length of horizontal springs (converting inches to m)
L_min = sqrt(L_0^2-h_0^2); %min length of horizontal spring (check spring specs to make sure physically possible) 
K_h = 43/100*17513.38 %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
preload_Dist = 3/12*.3048; % preload on the vertical spring when x=0 (converting inches to m)

%% Create F and K plots for the designed Zero Stiffness System

% The horizontal (negative stifness portions)
syms 'x' 
F = F_horzSpring_y(x, K_h, L_0, L_min, h_0);
k = diff(F);

%Convert to numbers
x_nums = [0:h_0*2/1000:h_0*2];
F_nums = vpa(subs(F,x,x_nums));
K_nums = vpa(subs(k,x,x_nums));

%Plots for the zero stiffness system
figure
subplot(2,1,1);
hold on; 
plot(x_nums, F_nums);
ylabel('F [N]')
xlabel('Displacement from center [m]')
title('Overall force of zero stiffness system')
subplot(2,1,2)
plot(x_nums, K_nums);
ylabel('K [N/m]')
xlabel('Displacement from center [m]')
title('Stiffness of zero stiffness system')
hold off;

%vertical spring stiffness that provides zero stiffness
K_v = -K_nums(h_0/(h_0*2/1000)) ; 
K_v = -vpa(subs(k,x,h_0))
 
% F and K for the Zero Stiffness System (negative stiffness + positive
% stiffness) 
F_tot = F_horzSpring_y(x, K_h, L_0, L_min, h_0) + F_vertSpring_y(x, K_v, preload_Dist);
k_tot = diff(F_tot);

%Convert to numbers
x_nums = [0:h_0*2/1000:h_0*2];
x_plot = x_nums - h_0; %include an offset to work in the zero stiffness area of the system
F_tot_nums = vpa(subs(F_tot,x,x_nums));
K_tot_nums = vpa(subs(k_tot,x,x_nums));


%Plots for the zero stiffness system
figure
subplot(2,1,1);
hold on; 
plot(x_plot, F_tot_nums);
ylabel('F [N]')
xlabel('Displacement from center [m]')
title('Overall force of zero stiffness system')
subplot(2,1,2)
plot(x_plot, K_tot_nums);
ylabel('K [N/m]')
xlabel('Displacement from center [m]')
title('Stiffness of zero stiffness system')
hold off;
