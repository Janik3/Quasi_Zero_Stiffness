% This program requires a "Figures" and "Files" folder be created in the
% same folder as the program 
addpath(genpath('\\north.cfs.uoguelph.ca\soe-other-home$\jhabegge\My Documents\MASc\Matlab\ZSS')) % add all subfolders to path

clear all;
close all;
clc;

files = dir('\\north.cfs.uoguelph.ca\soe-other-home$\jhabegge\My Documents\MASc\Matlab\ZSS\NonLinear Systems\SDOF\CompareRealToSim\CombinedTestData\*.csv');
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
L_0 = 4/12*.3048+(.81*2/12*.3048);%+.044; %length of horizontal springs plus constant dist (converting inches to m)
h_0 = sqrt(L_0^2-L_min^2); %min length of horizontal spring (check spring specs to make sure physically possible) 
K_h_1 = 1.55*1000*2; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
K_h_2 = 1.55*1000*3; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
K_h_3 = 1.55*1000*4; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
preload_dist = -(h_0); % preload on the vertical spring when x=0 (converting inches to m), total height of part minus 4 inches (to have QZS point at zero)
K_v = 6.95*1000; %1.85*4*1000;%8.62*1000; %1.85*4*1000; %8.62*1000;

%% Create F and K plots for the designed Zero Stiffness System

% The horizontal (negative stifness portions)
syms 'x' 
Fh1 = F_horzSpring_y(x, K_h_1, L_0, L_min, h_0);
Fh2 = F_horzSpring_y(x, K_h_2, L_0, L_min, h_0);
Fh3 = F_horzSpring_y(x, K_h_3, L_0, L_min, h_0);
Fv = F_vertSpring_y(x, K_v, preload_dist);
Fv2 = F_vertSpring_y(x, K_v, preload_dist+0.0254);

%Convert to numbers
x_nums = [0:h_0*2/1000:0.14];
F_vert =  vpa(subs(Fv,x,x_nums));
max_x = 4/12*0.3048
min_x = -3.18/12*0.3048
[ d, max_ix ] = min( abs( x_nums-max_x-h_0 ) );
[ d, min_ix ] = min( abs( x_nums-min_x-h_0 ) );
F_vert = min(F_vert,F_vert(max_ix));
F_vert = max(F_vert,F_vert(min_ix));

F_nums1 = vpa(subs(Fh1,x,x_nums)) + F_vert;
F_nums2 = vpa(subs(Fh2,x,x_nums)) + F_vert;
F_nums4 = vpa(subs(Fh2,x,x_nums)) + vpa(subs(Fv2,x,x_nums));
F_nums3 = vpa(subs(Fh3,x,x_nums)) + F_vert;

%Plots for the negative stiffness system
C = {'k','b','r','g'} 
figure
hold on;
plot(x_nums-h_0, F_vert, 'color',C{1});
plot(x_nums-h_0, F_nums1, 'color',C{2});
plot(x_nums-h_0, F_nums2, 'color',C{3});
plot(x_nums-h_0, F_nums3, 'color',C{4});
for i = 13:16
    if i == 13
        results{i} = results{i}(results{i}(:,1) > (-0.12+.128)*1000,:); %remove extra values at beginning (due to shift below)
        plot(results{i}(:,1)/1000-0.128-(5*9.81/K_v), results{i}(:,2)-559.1,'.', 'color',C{i-12})
    else
        plot(results{i}(:,1)/1000-0.128, results{i}(:,2)-559.1,'.', 'color',C{i-12})
    end
end
legend('0 Horizontal Springs, Simulation', '4 Horizontal Springs, Simulation', '6 Horizontal Springs, Simulation', '8 Horizontal Springs, Simulation', '0 Horizontal Springs, Experimental', '4 Horizontal Springs, Experimental', '6 Horizontal Springs, Experimental', '8 Horizontal Springs, Experimental')
ylabel('F [N]')
xlabel('Displacement from Zero Stiffness Point [m]')
set(gca,'FontSize',15)
x0=100;
y0=100;
width=800;
height=500;
set(gcf,'position',[x0,y0,width,height]);
hold off; 
