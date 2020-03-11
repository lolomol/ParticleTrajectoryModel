function [p, dz] = biofoulingTransport(p, dt, settings)
%BIOFOULINGTRANSPORT calculate the vertical transport due to biofouling
% dynamics for particles, across timestep dt
%   p: particle structure
%   dt: timestep (seconds)
%   settings: the current model settings
%   returns dz: vertical transport during timestep (m, positive down)
    
    % load forcing data for this timestep
    S = 35;  % some netcdf reading, g / kg
    T = 25;  % some netcdf reading, celsius
    chl = 0.05;  % some netcdf reading, mg m^-3
    I_surf = 1380;  % calculated from geometry, micro mol quanta m^-2 s^-1
    
    % extract forcing for every particle
    p.S = S*ones(1, p.np);  % will pull from real data, g / kg
    p.T = T*ones(1, p.np);  % will pull from real data, celsius
    p.chl = chl*ones(1, p.np);  % will pull from real data, mg m^-3
    p.I = I_surf*ones(1, p.np);  % will calculate from I_surf, micro mol quanta m^-2 s^-1
    
    p = updateBiofouling(p, dt);  % make the algae grow
    p = getSettlingVelocity(p);  % calculate the settling speed
    dz = p.dzdt*dt;  % calculate movement
end
