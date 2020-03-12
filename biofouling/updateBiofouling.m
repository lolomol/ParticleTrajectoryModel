function p = updateBiofouling(p, dt)
%UPDATEBIOFOULING calculate algae growth for particles, update particles
%   p: particle structure
%   dt: timestep, seconds
    % calculate various components of algae flux
    dAdt = algaeCollisions(p) + algaeGrowth(p) + algaeRespiration(p) + algaeMortality(p);
    
    % apply flux across timestep
    p.A = p.A + dAdt*dt;
    
    % the algae has changed, so update the associated partice properties
    % (it would be more robust if this happened automagically, but it don't)
    p = updateRadiusAndDensity(p);  % [m, kg m^-3]
end
