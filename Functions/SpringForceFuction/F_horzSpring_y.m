function F_y = F_horzSpring_y(x, K_h, L_0, L_min, h_0)
    % The function for this code uses horizontal springs for the negative stiffness element. The resultant force is the force in the vertical direction
    % 
    % | Parameter     | Explanation | Units
    % | ------------- | :-------------:                                       |:-------------:|
    % | x             |Displacement                                           | Meter|
    % | K_h           |Horizontal Spring Stiffness (spring providing the negative stiffness in the vertical direction| Newtons/Meter|
    % |L_0            |Full Length of the springs under no load               |Meter|
    % |L_min          |Minimum Length of the springs (springs horizontal)     |Meter|
    % |h_0            |Height of the horizontal springs under no load         |Meter|
    
    F_y =  2*K_h*(L_0 - (L_min^2+(h_0-x)^2)^(1/2))*(h_0-x)/((L_min^2+(h_0-x)^2)^(1/2));
end