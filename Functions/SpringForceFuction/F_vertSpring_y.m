function F_y = F_vertSpring_y(x, K_v, h_0)
    % Linear approximation of springs with the resultant force acting along the axial direction (Postive stiffness). An offset can be provided to the displacment x 
    % 
    % | Parameter     | Explanation | Untis
    % | ------------- | :-------------:       |:-------------: |
    % | x             |Displacement           |Meter|
    % | K_v           |Spring Stiffness       |Newtons/meter|
    % |h_0            |Desired spring offset  |Meter|
    F_y =  K_v*(x-(h_0));
end