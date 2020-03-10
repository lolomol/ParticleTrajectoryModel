function [p, dz] = biofoulingTransport(p, dt, settings)
%BIOFOULINGTRANSPORT calculate the vertical transport due to biofouling
% dynamics for particles, across timestep dt
%   p: particle structure
%   dt: timestep (seconds)
%   settings: the current model settings
%   returns dz: vertical transport during timestep (m, positive down)
    
    % load forcing data for this timestep
    S = 35;  % some netcdf reading
    T = 25;  % some netcdf reading
    chl = 0.05;  % some netcdf reading
    
    % extract forcing for every particle
    p.S = S*ones(1, p.np);  % will pull from real data
    p.T = T*ones(1, p.np);  % will pull from real data
    p.chl = chl*ones(1, p.np);  % will pull from real data
    
    p = updateBiofouling(p, dt);  % make the algae grow
    dzdt = getSettlingVelocity(p);  % calculate the settling speed
    dz = dzdt*dt;  % calculate movement
end
