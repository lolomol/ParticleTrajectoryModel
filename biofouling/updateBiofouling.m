function p = updateBiofouling(p, dt)
%UPDATEBIOFOULING calculate algae growth for particles, update particles
%   p: particle structure
%   dt: timestep, seconds
    % get change in time
    dAdt = algaeCollisions() + algaeGrowth() - algaeRespiration() - algaeMortality();
    
    p.A = p.A + dAdt*dt;
    
    % the algae has changed, so update the associated partice properties
    p = updateRadiusAndDensity(p);  % [m, kg m^-3]
end
