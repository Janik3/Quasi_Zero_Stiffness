function dydt = designedSystem(t,q,freq,multiplier,m,c,disp_range,k_plot)
    %horizontal spring y component force
    %SDOF with gound excitation
    
    %%% States %%%%%
    % q(1) = x, displacemnt of top
    % q(2) = x_dot - u, where u is the input (ground excitation)
    %%%%%%%%%%%%%%%%
    
    %nonlinear stiffness (update depending on current states)
    k = interp1(disp_range,k_plot,q(1))
    
    u = inputFn(t,freq,multiplier);%input

    dydt =  [q(2)+u; -k/m*q(1)-c/m*q(2)+(-c+k)/m*u];
end