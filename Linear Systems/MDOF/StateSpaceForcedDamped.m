function [x_dot] = stateSpace(t,X, M, D, F, omega)
% obtained from https://www.brown.edu/Departments/Engineering/Courses/En4/Notes/vibrations_mdof/vibrations_mdof.htm

%state space form of a MDOF system

%Convert F back into a sinusoid (amplitude and frequency given seperatley)
F = F*sin(omega*t);

x_dot = inv(M)*(-D)*X+inv(M)*F;