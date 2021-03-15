function u = inputFn(t, freq, multiplier)
    %Input to differential equation (ground excitation)
    
    omega = 2*pi*freq;

    u = multiplier*sin(omega*t);
end