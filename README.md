# Stiffness and Transmissibility

Models for various versions of quasi zero stiffness models

## stiffness_plt_TestForMH.m
Used to double-check the negative stiffness model. Uses the get_k_nonLinear function, which employs the spring version of the negative stiffness. Sets the h_0, L_0, L_min, and K_h parameters to run the plot. For further information of these parameters, please refer to the get_k_nonLinear section of the Readme.md file within the "Functions" folder and the Readme.md file within the "Functions/SpringForceFuction" folder. 

## ZDOFSysMain_BuckleBeam.m

Modeling for the buckling beam version of the negative stiffness system. Combines this with a positive stiffness that is properly tuned for the system to produce a plot of the Force-displacement curve around the zero stiffness condition. Does several iterations, changing the distance 'a' each time slightly to show this parameter's effects on the system. 

## ZDOFSysMain_Springs_Transmissibility.m 
Performs a time-domain simulation of the system using the designed system function. Applies inputs with varying frequencies and 5mm amplitude to eventually determine the transmissibility of the system. Compares this transmissibility to the positive stiffness system in a plot form at the end of the simulation. 