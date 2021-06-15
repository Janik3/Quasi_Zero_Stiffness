% This program requires a "Figures" and "Files" folder be created in the
% same folder as the program 
addpath(genpath('\\north.cfs.uoguelph.ca\soe-other-home$\jhabegge\My Documents\MASc\Matlab\ZSS')) % add all subfolders to path

clear all;
close all;
clc;

files = dir('CombinedTestData\*.csv');
num_files = length(files);
results = cell(length(files), 1);
for i = 1:num_files
  results{i} = xlsread(files(i).name);
end

% %% Define the system variables
% L_min = 3.85/12*.3048; % initial height from horizontal to top (converting inches to m)
% L_0 = 4/12*.3048+.044; %length of horizontal springs plus constant dist (converting inches to m)
% h_0 = sqrt(L_0^2-L_min^2) %min length of horizontal spring (check spring specs to make sure physically possible) 
% K_h = 1.55*1000*6; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
% preload_dist = -0.045; % preload on the vertical spring when x=0 (converting inches to m)
% K_v = 8.82*1000 %1.85*4*1000; %8.62*1000;

%% Define the system variables
massDisplacement2HorizSpring = 0.0;%0.0065

L_min = 3.25/12*.3048; % initial height from horizontal to top (converting inches to m)
L_0 = 4/12*.3048+(.81*2/12*.3048)%+.044; %length of horizontal springs plus constant dist (converting inches to m)
h_0 = sqrt(L_0^2-L_min^2); %min length of horizontal spring (check spring specs to make sure physically possible) 
K_h_1 = 1.55*1000*2; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
K_h_2 = 1.55*1000*3; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
K_h_3 = 1.55*1000*4; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
preload_dist = -0.030; % preload on the vertical spring when x=0 (converting inches to m)
%preload_dist = -(h_0 + 4/12*.3048 - 8/12*.3048); % preload on the vertical spring when x=0 (converting inches to m)
K_v = 6.95*1000; %1.85*4*1000;%8.62*1000; %1.85*4*1000; %8.62*1000;

%% Create F and K plots for the designed Zero Stiffness System

% The horizontal (negative stifness portions)
syms 'x' 
Fh1 = F_horzSpring_y(x-massDisplacement2HorizSpring, K_h_1, L_0, L_min, h_0);
Fh2 = F_horzSpring_y(x-massDisplacement2HorizSpring, K_h_2, L_0, L_min, h_0);
Fh3 = F_horzSpring_y(x-massDisplacement2HorizSpring, K_h_3, L_0, L_min, h_0);
Fv = F_vertSpring_y(x, K_v, preload_dist);
Fv2 = F_vertSpring_y(x, K_v, preload_dist+0.0254);

%Convert to numbers
x_nums = [0:h_0*2/1000:0.14];
F_vert =  max(max(vpa(subs(Fv,x,x_nums)),0)-52.8, 0);
F_nums1 = max(vpa(subs(Fh1,x,x_nums)) + max(vpa(subs(Fv,x,x_nums)),0)-52.8, 0);
F_nums2 = max(vpa(subs(Fh2,x,x_nums)) + max(vpa(subs(Fv,x,x_nums)),0)-52.8, 0);
F_nums4 = max(vpa(subs(Fh2,x,x_nums)) + max(vpa(subs(Fv2,x,x_nums)),0)-52.8, 0);
F_nums3 = max(vpa(subs(Fh3,x,x_nums)) + max(vpa(subs(Fv,x,x_nums)),0)-52.8, 0);

%Plots for the negative stiffness system
figure
hold on; 
plot(x_nums, F_nums1);
plot(x_nums, F_nums2);
plot(x_nums, F_nums3);
plot(x_nums, F_nums4);
plot(x_nums, F_vert);
for i = 14:18
    %plot(results{i}(:,1)/1000-0.003, results{i}(:,2)+45,'.')
    plot(results{i}(:,1)/1000, results{i}(:,2),'.')
end
ylabel('F [N]')
xlabel('Displacement from top [m]')
title('Overall force of negative stiffness system')
hold off; 
