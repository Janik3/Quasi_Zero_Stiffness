addpath(genpath(pwd)) % add all subfolders to path
clear all
close all

%% Define the system variables
h_0 = 4/12*.3048 % initial height from horizontal to top (converting inches to m)
L_0 = 6/12*.3048; %length of horizontal springs (converting inches to m)
L_min = sqrt(L_0^2-h_0^2); %min length of horizontal spring (check spring specs to make sure physically possible) 
K_h = 43/100*17513.38 %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
preload_Dist = 3/12*.3048; % preload on the vertical spring when x=0 (converting inches to m)


x=[-0.1:0.01:0.1];
F=get_k_nonLinear(x, h_0, L_0, L_min, K_h, preload_Dist);
figure
plot(x,F)
