function F_y = F_vertSpring_y(x, K_v, h_0)
    %horizontal spring y component force
    F_y =  K_v*(x-(h_0-(2/12*.3048)));
end