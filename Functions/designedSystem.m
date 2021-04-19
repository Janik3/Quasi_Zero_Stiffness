function dydt = designedSystem(t,q,freq,multiplier,m,c, h_0, L_0, L_min, K_h, preload_dist)
    %horizontal spring y component force
    %SDOF with gound excitation
    
    %%% States %%%%%
    % q(1) = x, displacemnt of top
    % q(2) = x_dot - u, where u is the input (ground excitation)
    %%%%%%%%%%%%%%%%
    
    %nonlinear stiffness (update depending on current states)
    k = get_k_nonLinear(q(1), h_0, L_0, L_min, K_h, preload_dist);
    
    u = inputFn(t,freq,multiplier);%input

    dydt =  [q(2)+u; -k/m*q(1)-c/m*q(2)+(-c+k)/m*u];
end