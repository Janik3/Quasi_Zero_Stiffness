function dydt = MDOFStateSpaceSystem(t,q,freq,multiplier,M,C,disp_range,k_plot,F_direct)
    %MDOF with gound excitation
    
    %%% States %%%%%
    % first half of the states are postions
    % second half are velocities
    %%%%%%%%%%%%%%%%
    
    nDOF = length(M);
    nStates = 2*nDOF;
    
    u = [inputFn(t,freq,multiplier); F_direct];%input
    
    %nonlinear stiffness (update depending on current states)
    K = zeros([1 nDOF]);
    if size(k_plot,2) == 1
        K = k_plot;
    else
        for i = 1:nDOF
            if i == 1
                K(i) = interp1(disp_range,k_plot(i,:),q(1)-u(1));
            else
                K(i) = interp1(disp_range,k_plot(i,:),q(i)-q(i-1));
            end
        end
    end
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
    
    F = zeros([nStates,nDOF+1]);
    F(nDOF+1:end,2:end) = eye(nDOF);%multiply input forces by unity (direct forces)
    F(1,1) = C(1)/M(1);
    if nDOF > 1
        F(nDOF+1,1) = (-(C(1)*(C(1)+C(2)))/(M(1)*M(1)))+(K(1)/M(1));
        F(nDOF+2,1) = (C(1)*C(2))/(M(1)*M(2));
    else
        F(nDOF+1,1) = C(1)*(C(1))/(M(1)*M(1))-K(1)/M(1);
    end
    
    dydt =  (((D'/M_mat)')*q + F*u);
end