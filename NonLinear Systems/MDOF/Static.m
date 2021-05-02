% This program requires a "Figures" and "Files" folder be created in the
% same folder as the program 
addpath(genpath('\\north.cfs.uoguelph.ca\soe-other-home$\jhabegge\My Documents\MASc\Matlab\ZSS')) % add all subfolders to path

clear all;
close all;
clc;

%% Time Domain analysis

%System parameters
M = [4 ;1];
K = [120000 ;17928];
zeta = [0.3; 0.3]; 
C = [2*zeta(1)*sqrt(K(1)*M(1));2*zeta(2)*sqrt(K(2)*M(2))];
F_direct = [0 ;70];

s = tf('s');
%[C(1)*s+K(1);0]
sys = (C(1)*s+K(1))/([M(1) 0;0 M(2)]*s^2 + [C(1)+C(2) -C(2);-C(2) C(2)]*s + [K(1)+K(2) -K(2);-K(2) K(2)])

omega = [0:0.005:5]*3;

[mag,phase,wout] = bode(sys,omega);

trans = []; 
freq_trans = [];
% list of frequencies to simulate in time domain 
freqList = [0.05,0.125,0.25,0.375,0.5,0.625,0.75,0.875,1,1.5,2,3,4,5,6,7,8,9,10];
freqList = 0.1:0.5:10;
freqList = 5

multiplier = 0.00; % amplitude for input
m = 50; %in kg
zeta = 0.00; %damping ratio
k_v = 0.00; % vertical spring stiffness 
% w_n = sqrt(k_v/m); % natural frequency of positive stiffness sys
% c = 2*zeta*w_n*m; % damping for system 

%get the nonlinear k
t_step = 0.01;
disp_range(1,:) = -100:t_step:100;
%disp_range(2,:) = -100:0.01:100;
k_plot(1,:) = diff(K(1)*disp_range(1,:))/t_step;
k_plot(2,:) = 10000000;
k_plot = [k_plot k_plot(:,end)]; %extend by 1 element to make length good


%get the nonlinear k
%% Define the system variables
h_0 = 3/12*.3048; % initial height from horizontal to top (converting inches to m)
L_0 = 4/12*.3048; %length of horizontal springs (converting inches to m)
L_min = sqrt(L_0^2-h_0^2); %min length of horizontal spring (check spring specs to make sure physically possible) 
K_h = 17513.38; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)
preload_dist = 3/12*.3048; % preload on the vertical spring when x=0 (converting inches to m)
k_plot(2,1:10010) = get_k_nonLinear(disp_range(1:10010), h_0, L_0, L_min, K_h, preload_dist);

plot(disp_range, k_plot)

for i = 1:1:length(freqList)
    forceSim = 1; % used to manually force a simulation that has previously already been completed
    
    %Print to screen 
    "Simulation at a frequency of :"
    freq = freqList(i)
    
    % time variables (Change as required)
    tf = 40/freq; % Final time 

    T = 0.001; % Sampling time
    t = 0:T:tf; % time vector
    t_span = [0 tf];

    %Initial Conditions
    x = zeros(length(M)*2,1);
    u = inputFn(t,freq,multiplier);
    
    %for saving results (speeds up runs in the future) 
    figName = strcat('Figures/','ZSS_ ', strrep(num2str(freq),'.','') ,'_',  strrep(num2str(multiplier),'.',''), '_', strrep(num2str(m),'.',''), '_', strrep(num2str(zeta),'.',''), '_' , strrep(num2str(k_v),'.',''), '.jpeg');
    fileNameTime = strcat('Files/','ZSS, ', num2str(freq) ,',',  num2str(multiplier), ',', num2str(m), ',', num2str(zeta), ',' , num2str(k_v), 'time.txt');
    fileNameVals = strcat('Files/','ZSS, ', num2str(freq) ,',',  num2str(multiplier), ',', num2str(m), ',', num2str(zeta), ',' , num2str(k_v), 'vals.txt');
    
    if exist(fileNameVals) && forceSim == 0
        % this has already been simulated. Pull the reults. Do not repeat the simulation
        t_out = readmatrix(fileNameTime);
        y_out = readmatrix(fileNameVals);
    else
        %%%%%%%%%%%%% Perform the time domain simulation %%%%%%%%%%%%%
        %
        %
        [t_out, y_out] = ode45(@(t,q) MDOFStateSpaceSystem(t,q,freq,multiplier,M,C,disp_range,k_plot, F_direct), t, x);
        %
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end

    %plot time domain 
    figure
    hold on; 
    plot(t_out, y_out(:,1));
    plot(t_out, y_out(:,2));
    plot(t_out, y_out(:,2) - y_out(:,1))
    legend('Mass 1[m]','Mass 2[m]');
    ylabel('Displacement of top [m]')
    xlabel('Time [s]')
    title(strcat('Overall Displacement of Zero Stiffness System, freq = ', num2str(freq)));
    hold off; 
    saveas(gcf,figName);
    writematrix(y_out, fileNameVals);
    writematrix(t_out, fileNameTime);
    
end
