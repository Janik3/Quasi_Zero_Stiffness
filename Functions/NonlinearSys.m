classdef NonlinearSys
    properties
        K_v;                                    %Veritical stiffness (total)
        K_h;                                    %Horizontal stiffness (one half)
        
        L_min;                                  %Constant horizontal separtation of pivot points H spring
        L0_constdist;                           %Any distance that is constant along length of H spring
        L0_springLen;                           %length of H spring
        L_0;                                    %total pivot to pivot distance at no load
        h_0;                                    %height of H springs (pivot to pivot) at start 
        total_hieght;                           %totla hieght of working range (inside to inside)
        vert_springLen;            %total hieght of vertical spring
        vert_distToZero;           %dist from base to pivot
        preload_dist;                           %preload on springs (gap at top is negative)

        massTop;                                %mass on top of the system
        dampingRatio;                           %damping ratio of the system
        
        max_x;                                  %maximum x value posssible(bottom out), m below zero stiffness
        min_x;                                  %maximum x value posssible(bottom out), m below zero stiffness
        
    end
    methods
        function obj = NonlinearSys(K_v,K_h,L_min, L0_constdist, L0_springLen, total_hieght, vertSpring, distToZero, massTop, dampingRatio)
            obj.K_v = K_v;                              %Veritical stiffness (total)
            obj.K_h = K_h;                              %Horizontal stiffness (one half)

            obj.L_min = L_min;                          %Constant horizontal separtation of pivot points H spring
            obj.L0_constdist = L0_constdist;            %Any distance that is constant along length of H spring
            obj.L0_springLen = L0_springLen;            %length of H spring
            obj.L_0 = L0_constdist + L0_springLen;      %total pivot to pivot distance at no load
            obj.h_0 = sqrt(obj.L_0^2-obj.L_min^2);      %height of H springs (pivot to pivot) at start 
            obj.total_hieght = total_hieght;            %total hieght of working range (inside to inside)
            obj.vert_springLen = vertSpring;            %total hieght of vertical spring
            obj.vert_distToZero = distToZero;           %dist from base to pivot
            obj.preload_dist = 0;                       %preload on springs (gap at top is negative)

            obj.massTop = massTop;                      %mass on top of the system
            obj.dampingRatio = dampingRatio;            %damping ratio of the system

            obj.max_x = obj.vert_distToZero             %maximum x value posssible(bottom out), m below zero stiffness
            obj.min_x = -(obj.vert_springLen - obj.vert_distToZero)%maximum x value posssible(bottom out), m below zero stiffness
        end
        function [x_out, Force_values] = getStiffnessPlot(obj, x_in)
            syms 'x' 
            Fh = F_horzSpring_y(x, obj.K_h, obj.L_0, obj.L_min, obj.h_0);
            Fv = F_vertSpring_y(x, obj.K_v, obj.preload_dist);
            
            F_vert =  vpa(subs(Fv,x,x_in));

            [ d, max_ix ] = min( abs( x_in-obj.max_x-obj.h_0 ) );
            [ d, min_ix ] = min( abs( x_in-obj.min_x-obj.h_0 ) );
            %F_vert = min(F_vert,F_vert(max_ix));
            F_vert(F_vert>F_vert(max_ix)) = 10000;
            F_vert = max(F_vert,F_vert(min_ix));
            
            
            Force_values = vpa(subs(Fh,x,x_in)) + F_vert;
            
            x_out = x_in;
            
        end
    end
end



function k_nonLinear = get_k_nonLinear(x_in, h_0, L_0, L_min, K_h, preload_dist, M_above)
    %% Define the non-linear F and K based on their equations
    % The equations
    syms 'x' 
    syms 'F_tot'
    
    F = F_horzSpring_y(x, K_h, L_0, L_min, h_0);
    k = diff(F);

    K_v = -vpa(subs(k,x,h_0)); %vertical spring stiffness that provides zero stiffness
    
    % The total force in the vertical direction is the sum of the force
    % from the vertical and horizonatal springs
    F_tot = F_horzSpring_y(x, K_h, L_0, L_min, h_0) + F_vertSpring_y(x, K_v, preload_dist);
    
    %determine the operating location due to the mass
    eqn1 = M_above*9.81 == F_horzSpring_y(x, K_h, L_0, L_min, h_0) + F_vertSpring_y(x, K_v, preload_dist);
    massDisplacement = solve(eqn1,x);

    %K is the derivative of the force
    k_tot = diff(F_tot);
   
    x_in;
    %Convert to numbers
    x_nums = x_in + massDisplacement(1); %include an offset to work in the zero stiffness area of the system
    
    %Convert to numbers
    % x_nums = [0:h_0*2/1000:h_0*2];
    F_tot_nums = vpa(subs(F_tot,x,x_nums));
    F_actualZero = vpa(subs(F_tot,x,massDisplacement(1)));
    F_desiredZero = vpa(subs(F_tot,x,h_0));
    correctOffset = (F_actualZero - F_desiredZero)/K_v

    
%     %Plots
%     figure
%     hold on;
%     plot(x_in,F_tot_nums, 'color', 'k', 'linewidth', 2)
%     set(gca,'FontSize',15)
%     title('Stiffness of QZS System with Offset')
%     xlabel('Position (shifted) [m]');
%     ylabel('Force [N]');
%     x0=100;
%     y0=100;
%     width=800;
%     height=500;
%     set(gcf,'position',[x0,y0,width,height]);
%     hold off;
    
    % F_nums = vpa(subs(F_tot,x,x_nums));
    k_nonLinear = double(vpa(subs(k_tot,x,x_nums)));
end