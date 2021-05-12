clear all;
close all;
clc;

%Proves that both models match when damping is zero

%System paameters
M = 50;
K = 17929;
zeta = 0.3;
w_n = sqrt(K/M);
C = 2*zeta*sqrt(M*K)

%% For a specific system (no normallization)

%want to go to 10hz, convert to rad/sec
omega = [0:0.005:10*2*pi];

%do using systems/bode plot
s = tf('s');
sys = (C*s+K)/(M*s^2+C*s+K)
[mag,phase,wout] = bode(sys,omega);

%do using the equations
trans = @(omega,M,C,K) sqrt(K^2.+(C.*omega).^2)./sqrt((-M.*(omega.^2)+K).^2+(C.*omega).^2)

%Plots
figure
hold on;
plot(omega/(2*pi),trans(omega,M,C,K), 'color', 'k', 'linewidth', 2)
plot(squeeze(wout)/(2*pi),squeeze(mag), 'color', 'r', 'linewidth', 2, 'LineStyle', '--')
set(gca,'FontSize',15)
legend('Transmissibility Using Formula', 'Transmissibility Using Bode Plot')
title('Transmissibility of a Linear System, Ground Excitation')
xlabel('Frequency [Hz]');
ylabel('Transmission Ratio, $\frac{X}{X_g}$','Interpreter','latex');
x0=100;
y0=100;
width=800;
height=500;
set(gcf,'position',[x0,y0,width,height]);
hold off;


%% Normallized System
%want to go to 10hz, convert to rad/sec
w_n = sqrt(K/M);
r = omega/w_n;

%do using systems/bode plot
s = tf('s');
sys = (C*s+K)/(M*s^2+C*s+K)
[magr,phaser,woutr] = bode(sys,r*w_n);

%Plots
figure
hold on;
plot(r,trans(r*w_n,M,C,K), 'color', 'k', 'linewidth', 2)
plot(r,squeeze(magr), 'color', 'r', 'linewidth', 2, 'LineStyle', '--')
legend('Transmissibility Using Formula', 'Transmissibility Using Bode Plot')
title('Transmissibility of a Linear System, Ground Excitation')
set(gca,'FontSize',15)
xlabel('Frequency ratio, $\frac{\omega}{\omega_n}$','Interpreter','latex');
ylabel('Transmission Ratio, $\frac{X}{X_g}$','Interpreter','latex');
x0=100;
y0=100;
width=800;
height=500;
set(gcf,'position',[x0,y0,width,height]);
hold off;

%% ground excitation multiple zeta

figure
hold on;

r = 0:0.01:10
zetalist = [0,0.05,0.1,0.2,0.5,1]

for i =1:length(zetalist)
    M = 50;
    K = 17929;
    zeta = zetalist(i)
    w_n = sqrt(K/M);
    C = 2*zeta*sqrt(M*K);
    
    
    plot(r,trans(r*w_n,M,C,K),'linewidth', 2)
end
legend('\zeta_1=0.0','\zeta_2=0.05','\zeta_3=0.10','\zeta_4=0.20',...
    '\zeta_5=0.50','\zeta_6=1.00');
axis([0.1 10 0.01 10]);
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
title('Transmissibility of a Linear System, Ground Excitation')
set(gca,'FontSize',15)
xlabel('Frequency ratio, $\frac{\omega}{\omega_n}$','Interpreter','latex');
ylabel('Transmission Ratio, $\frac{X}{X_g}$','Interpreter','latex');
hold off;


%% direct force application multiple zeta

figure
hold on;

%do using the equations
transDirectForce = @(omega,M,C,K) (K)./sqrt((-M.*(omega.^2)+K).^2+(C.*omega).^2)

r = 0:0.01:10
zetalist = [0,0.05,0.1,0.2,0.5,1]

for i =1:length(zetalist)
    M = 50;
    K = 17929;
    zeta = zetalist(i)
    w_n = sqrt(K/M);
    C = 2*zeta*sqrt(M*K);
    
    
    plot(r,transDirectForce(r*w_n,M,C,K),'linewidth', 2)
end
legend('\zeta_1=0.0','\zeta_2=0.05','\zeta_3=0.10','\zeta_4=0.20',...
    '\zeta_5=0.50','\zeta_6=1.00');
axis([0.1 10 0.01 10]);
set(gca, 'YScale', 'log')
set(gca, 'XScale', 'log')
title('Transmissibility of a Linear System, Direct Force Application')
set(gca,'FontSize',15)
xlabel('Frequency ratio, $\frac{\omega}{\omega_n}$','Interpreter','latex');
ylabel('Transmission Ratio, $\frac{KX}{F}$','Interpreter','latex');
hold off;

%% variable K

figure
hold on;
omegavarK = [0:0.005:20*2*pi];
Klist = [0.33*K 0.5*K 1*K 2*K 3*K]

for i =1:length(Klist)
    M = 50;
    K = Klist(i);
    zeta = 0.3
    w_n = sqrt(K/M);

    plot(omegavarK/(2*pi),trans(omegavarK,M,C,K),'linewidth', 2)
end
legend('0.33K','0.5K','K = 17929 N/m','2K','3K');
title('Transmissibility of a Linear System, Ground Excitation')
set(gca,'FontSize',15)
xlabel('Frequency [Hz]');
ylabel('Transmission Ratio, $\frac{X}{X_g}$','Interpreter','latex');
x0=100;
y0=100;
width=800;
height=500;
set(gcf,'position',[x0,y0,width,height]);
hold off;

%% variable M

figure
hold on;
omegavarK = [0:0.005:20*2*pi];
Mlist = [0.33*M 0.5*M 1*M 2*M 3*M]

for i =1:length(Mlist)
    M = Mlist(i);
    K = K;
    zeta = 0.3
    w_n = sqrt(K/M);

    plot(omegavarK/(2*pi),trans(omegavarK,M,C,K),'linewidth', 2)
end
legend('0.33M','0.5M','M = 50kg','2M','3M');
title('Transmissibility of a Linear System, Ground Excitation')
set(gca,'FontSize',15)
xlabel('Frequency [Hz]');
ylabel('Transmission Ratio, $\frac{X}{X_g}$','Interpreter','latex');
x0=100;
y0=100;
width=800;
height=500;
set(gcf,'position',[x0,y0,width,height]);
hold off;