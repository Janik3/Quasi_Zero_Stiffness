function F = BuckleBeam(x, P_e, a, L, q_0)
    % The function for this code was obtained from [[1]](#1). The resultant force is the force in the vertical direction
    % 
    % | Parameter     | Explanation | Units
    % | ------------- | :-------------: |:-------------: |
    % | x             |Displacement| Meter |
    % | P_e           |P<sub>e</sub> = EI( &pi; /L)<sup>2</sup>  - Classic Euler critical load for hinge-hinged boundary| Newtons|
    % |a              |Horizontal distance between mass and reference (see diagram)|Meter |
    % |L              |Full Length of the beam| Meter|
    % |q_0            |Initial imperfection at the center of the beam| Meter|

    %obtained from https://www.sciencedirect.com/science/article/pii/S0022460X13000813
    gamma = a/L; %also equal to cos(theta)
    delta = 1-sqrt(1-(2*x/L)*sqrt(1-gamma^2)+(x/L)^2);
    
    % Output force in the vertical direction
    F = P_e*(1-(pi*q_0/L)*((pi*q_0/L)^2+4*delta)^(-1/2))*(2+(pi*q_0/(2*L))^2+delta)*((sqrt(1-gamma^2)-(x/L))/sqrt((x/L)^2-(2*x/L)*sqrt(1-gamma^2)+1));
end