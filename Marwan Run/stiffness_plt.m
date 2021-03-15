clear all
h_0 = 3/12*.3048; % initial height from horizontal to top (converting inches to m)
L_0 = 4/12*.3048; %length of horizontal springs (converting inches to m)
L_min = sqrt(L_0^2-h_0^2); %min length of horizontal spring (check spring specs to make sure physically possible)
K_h = 4.9348e+04;  %17513.38; %horizontal spring stiffness (based on 100lbs/in, converted to N/m)


x=[-0.1:0.01:0.1];
F=get_k_nonLinear(x, h_0, L_0, L_min, K_h);
figure
plot(x,F)
