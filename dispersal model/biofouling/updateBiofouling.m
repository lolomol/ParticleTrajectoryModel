function p = updateBiofouling(p, dt)
%UPDATEBIOFOULING calculate algae growth for particles, update particles
    canGrow = p.r_tot < 5*p.r_pl;
    p.A(canGrow) = 2 * p.A(canGrow);  % limited exponential growth, dummy for now
    
    
    % the algae has changed, so update the associated partice properties
    p = updateRadiusAndDensity(p);  % [m, kg m^-3]
end
