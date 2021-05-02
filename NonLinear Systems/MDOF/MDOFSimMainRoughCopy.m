% This program requires a "Figures" and "Files" folder be created in the
% same folder as the program 
addpath(genpath('\\north.cfs.uoguelph.ca\soe-other-home$\jhabegge\My Documents\MASc\Matlab\ZSS')) % add all subfolders to path

clear all;
close all;
clc;

%% Time Domain analysis

%System parameters
M = [4 4];
C = [1 1];
K = [40 80];

s = tf('s');
%[C(1)*s+K(1);0]
sys = (C(1)*s+K(1))/([M(1) 0;0 M(2)]*s^2 + [C(1)+C(2) -C(2);-C(2) C(2)]*s + [K(1)+K(2) -K(2);-K(2) K(2)])

omega = [0:0.005:5];

[mag,phase,wout] = bode(sys,omega*3);

hold on;
plot(wout/(2*pi), reshape(mag(1,1,:),1,[]));
plot(wout/(2*pi), reshape(mag(1,2,:),1,[]));
plot(wout/(2*pi), reshape(mag(2,1,:),1,[]));
plot(wout/(2*pi), reshape(mag(2,2,:),1,[]));
legend('11','12', '21', '22');
hold off

trans = []; 
freq_trans = [];
% list of frequencies to simulate in time domain 
freqList = [0.05,0.125,0.25,0.375,0.5,0.625,0.75,0.875,1,1.5,2,3,4,5,6,7,8,9,10];
freqList = 0.1:0.05:1.2;


multiplier = 0.001; % amplitude for input
m = 50; %in kg
zeta = 0.00; %damping ratio
k_v = 0.00; % vertical spring stiffness 
% w_n = sqrt(k_v/m); % natural frequency of positive stiffness sys
% c = 2*zeta*w_n*m; % damping for system 

%get the nonlinear k
disp_range(1,:) = -100:0.01:100;
%disp_range(2,:) = -100:0.01:100;
k_plot(1,:) = K(1)*disp_range(1,:);
k_plot(2,:) = K(2)*disp_range(1,:);

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
        [t_out, y_out] = ode45(@(t,q) MDOFStateSpaceSystem(t,q,freq,multiplier,M,C,disp_range,K), t, x);
        %
        %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    %calculate the transmission ratio 
    trans(i) = ampratiomeasure(u((length(u)/2):(length(u)-1)),y_out((length(y_out)/4):(length(y_out)-1),2));
    freq_trans(i) = freq; 

    %plot time domain 
    figure
    hold on; 
    plot(t_out, y_out(:,2));
    plot(t, u);
    legend('Output Position[m]','Input Position (Ground Vibrations)[m]');
    ylabel('Displacement of top [m]')
    xlabel('Time [s]')
    title(strcat('Overall Displacement of Zero Stiffness System, freq = ', num2str(freq)));
    hold off; 
    saveas(gcf,figName);
    writematrix(y_out, fileNameVals);
    writematrix(t_out, fileNameTime);
    
end

%Positive Stiffness Transmissibility (closed form, may be incorreect) 
omega = freqList*2*pi;
%omega = freq/180*pi
%trans_vert = @(omega) sqrt(k_v.^2 + (c.*omega).^2)./sqrt((-m.*omega.^2 + k_v).^2 + (c.*omega).^2)
trans_vert = @(omega) ((C(1).*omega.*i+K(1))/((((-M(1).*(omega.^2)+(C(1)+C(2)).*i.*omega+K(1)+K(2)).*(-M(2).*(omega.^2)+C(2).*i.*omega+K(2)))/(C(2).*i.*omega+K(2)))-C(2).*omega.*i-K(2)));
% 
% trans_vert2 = @(omega) ((C(1).*omega.*i+K(1)).*(C(2).*i.*omega+K(2)).^2)/((-M(1).*(omega.^2)+(C(1)+C(2)).*i.*omega+K(1)+K(2)).*(-M(2).*(omega.^2)+C(2).*i.*omega+K(2)))-(C(2).*i.*omega+K(2)).^2

%%
    nDOF = length(M);
    nStates = 2*nDOF;
    
    
    %nonlinear stiffness (update depending on current states)

    if any(isnan(K(:)))
        breakTime;
    end
    
    K_off = zeros(size(K));
    K_off(1:end-1) = K(2:end);
    K_mat = diag(-K-K_off)+diag(K_off(1:end-1),1)+diag(K_off(1:end-1),-1);
    
    C_off = zeros(size(C));
    C_off(1:end-1) = C(2:end);
    C_mat = diag(-C-C_off)+diag(C_off(1:end-1),1)+diag(C_off(1:end-1),-1);
    
    D = zeros(nStates);
    D(1:nDOF,nDOF+1:nStates) = eye(nDOF);
    D(nDOF+1:nStates,1:nDOF) = K_mat;
    D(nDOF+1:nStates,nDOF+1:nStates) = C_mat;
    
    M_mat = zeros(nStates);
    M_mat(1:nDOF,1:nDOF) = eye(nDOF);
    M_mat(nDOF+1:nStates,nDOF+1:nStates) = diag(M);
    
    F = zeros([nStates,1]);
    F(1,1) = C(1)/M(1);
    if nDOF > 1
        F(nDOF+1,1) = (-(C(1)*(C(1)+C(2)))/(M(1)*M(1)))+(K(1)/M(1));
        F(nDOF+2,1) = (C(1)*C(2))/(M(1)*M(2));
    else
        F(nDOF+1,1) = C(1)*(C(1))/(M(1)*M(1))-K(1)/M(1);
    end

for i = 1:1:length(omega) 
    %Note the phase is not passed back here (nowhere to put it)
    dampedTrans(i,:) = abs(forcedVibrationWithDamping(D,M_mat,F,omega(i)));
end

%%

for i = 1:1:length(omega) 
    %Note the phase is not passed back here (nowhere to put it)
    trans_vert_nums(i) = abs(trans_vert(omega(i)));
end

% trans_vert_nums2 = feval(trans_vert2,omega);

%Plot transmissibility 
figure()
hold on;
plot(freq_trans,trans);
plot(freqList,trans_vert_nums);
plot(wout/(2*pi), reshape(mag(2,1,:),1,[]));
plot(freqList,dampedTrans(:,1));
plot(freqList,dampedTrans(:,2));
%plot(freq_trans,abs(trans_vert_nums2));
ylabel('Transmission Ratio')
xlabel('Frequency [Hz]')
title('Transmissibility of Zero Stiffness System')
legend('Sim Mass 2','Direct', 'Bode', 'Mass1','Mass2');
hold off; 
