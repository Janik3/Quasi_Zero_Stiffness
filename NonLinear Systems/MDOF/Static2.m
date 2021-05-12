% This program requires a "Figures" and "Files" folder be created in the
% same folder as the program 
addpath(genpath('\\north.cfs.uoguelph.ca\soe-other-home$\jhabegge\My Documents\MASc\Matlab\ZSS')) % add all subfolders to path

clear all;
close all;
clc;

t_step = 0.01;
disp_range(1,:) = -0.15:t_step:0.15;

%% Define the system variables
h_0 = 3/12*.3048 % initial height from horizontal to top (converting inches to m)
L_0 = 4/12*.3048 %length of horizontal springs (converting inches to m)
L_min = sqrt(L_0^2-h_0^2); %min length of horizontal spring (check spring specs to make sure physically possible) 
K_h = 17513.38; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
preload_dist = -1.5/12*.3048; % preload on the vertical spring when x=0 (converting inches to m)
k_plot = get_k_nonLinear(disp_range, h_0, L_0, L_min, K_h, preload_dist, 70);

%Plots
figure
hold on;
plot(disp_range,k_plot, 'color', 'k', 'linewidth', 2)
set(gca,'FontSize',15)
title('Stiffness of QZS System with Offset')
xlabel('Position (shifted) [m]');
ylabel('Stiffness [N/m]');
x0=100;
y0=100;
width=800;
height=500;
set(gcf,'position',[x0,y0,width,height]);
hold off;