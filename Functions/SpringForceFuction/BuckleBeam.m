function F = BuckleBeam(x, P_e, a, L, q_0)
    %obtained from https://www.sciencedirect.com/science/article/pii/S0022460X13000813
    gamma = a/L; %also equal to cos(theta)
    delta = 1-sqrt(1-(2*x/L)*sqrt(1-gamma^2)+(x/L)^2);
    
    % Output force in the vertical direction
    F = P_e*(1-(pi*q_0/L)*((pi*q_0/L)^2+4*delta)^(-1/2))*(2+(pi*q_0/(2*L))^2+delta)*((sqrt(1-gamma^2)-(x/L))/sqrt((x/L)^2-(2*x/L)*sqrt(1-gamma^2)+1));
end