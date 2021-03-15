function F_y = F_horzSpring_y(x, K_h, L_0, L_min, h_0)
    %horizontal spring y component force
    F_y =  2*K_h*(L_0 - (L_min^2+(h_0-x)^2)^(1/2))*(h_0-x)/((L_min^2+(h_0-x)^2)^(1/2));
end