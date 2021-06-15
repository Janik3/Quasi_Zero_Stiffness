% This program requires a "Figures" and "Files" folder be created in the
% same folder as the program 
addpath(genpath('\\north.cfs.uoguelph.ca\soe-other-home$\jhabegge\My Documents\MASc\Matlab\ZSS')) % add all subfolders to path

clear all;
close all;
clc;

C = {'k','b','r','g'} ;

files = dir('\\north.cfs.uoguelph.ca\soe-other-home$\jhabegge\My Documents\MASc\Matlab\ZSS\NonLinear Systems\SDOF\CompareRealToSim\CombinedTestData\*.csv');
num_files = length(files);
results = cell(length(files), 1);
for i = 1:num_files
  results{i} = xlsread(files(i).name);
end

%% 
L_min = 3.25/12*.3048; % initial height from horizontal to top (converting inches to m)
L0_springLen = 4/12*.3048;%+.044; %length of horizontal springs plus constant dist (converting inches to m)
L0_constdist = (.81*2/12*.3048);

%h_0 = sqrt(L_0^2-L_min^2); %min length of horizontal spring (check spring specs to make sure physically possible) 
K_h = 1.55*1000*3; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
K_h2 = 1.55*1000*2; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
K_h3 = 1.55*1000*4; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
%preload_dist = -((h_0 + 4/12*.3048 - 4/12*.3048)); % preload on the vertical spring when x=0 (converting inches to m), total height of part minus 4 inches (to have QZS point at zero)
K_v = 6.95*1000; %1.85*4*1000;%8.62*1000; %1.85*4*1000; %8.62*1000;

vertSpring = 8/12*0.3048;
distGroundToPivot = 2.25/12*0.3048;
distPivotToTop = 2.5/12*0.3048;

massTop = 50;
dampingRatio = 0.2;

%% Create F and K plots for the designed Zero Stiffness System

% The horizontal (negative stifness portions)
system = NonlinearSys(K_v,K_h,L_min, L0_constdist, L0_springLen, distPivotToTop, vertSpring, distGroundToPivot, massTop, dampingRatio);
system2 = NonlinearSys(K_v,K_h2,L_min, L0_constdist, L0_springLen, distPivotToTop, vertSpring, distGroundToPivot, massTop, dampingRatio);
system3 = NonlinearSys(K_v,K_h3,L_min, L0_constdist, L0_springLen, distPivotToTop, vertSpring, distGroundToPivot, massTop, dampingRatio);
%Convert to numbers
x_nums = [-system.h_0*2:system.h_0*2/1000:3*system.h_0*2];

[x_nums, F, system] = system.getStiffnessPlot(x_nums);
[x_nums2, F2, system2] = system2.getStiffnessPlot(x_nums);
[x_nums3, F3, system3] = system3.getStiffnessPlot(x_nums);

K = diff(F);

%Plots for the negative stiffness system
figure
subplot(1,1,1);
hold on; 
plot(x_nums, F);
plot(x_nums, F2);
plot(x_nums, F3);
plot(x_nums, system.f_vert);

for i = 13:16
    if i == 13
        results{i} = results{i}(results{i}(:,1) > (-0.12+.128)*1000,:); %remove extra values at beginning (due to shift below)
        plot(results{i}(:,1)/1000-(5*9.81/K_v)-0.01412, results{i}(:,2),'.', 'color',C{i-12})
    else
        plot(results{i}(:,1)/1000-0.01412, results{i}(:,2),'.', 'color',C{i-12})
    end
end
ylabel('F [N]')
xlabel('Displacement from top [m]')
title('Overall force of negative stiffness system')
% subplot(2,1,2)
% plot(x_nums, K);
ylabel('K [N/m]')
xlabel('Displacement from top [m]')
title('Stiffness of negative stiffness system')
hold off; 

