function p = updateForcingDataOnParticles(p, settings)
%LOADFORCINGDATA loads the local forcing data conditions onto each particle
%   p: the particle structure
%   returns: the modified particle structure

    %% Temp/Salinity
    p.S = settings.S.select(p.lon, p.lat, p.z, settings.date*ones(1, p.np));  % g / kg
    p.T = settings.T.select(p.lon, p.lat, p.z, settings.date*ones(1, p.np));  % g / kg
    
    %% Chlorophyll
    p.chl = settings.chl_surf.select(p.lon, p.lat, p.z, settings.date*ones(1, p.np));  % mg m^-3
    
    %% Light
    p.I = 1000*ones(1, p.np);  % will calculate from I_surf, micro mol quanta m^-2 s^-1
end

