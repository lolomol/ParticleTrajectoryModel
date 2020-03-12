function p = loadForcingData(p, settings)
%LOADFORCINGDATA loads the local forcing data conditions onto each particle
%   p: the particle structure
%   returns: the modified particle structure

    % load in current timestep, physical range of particles
    lon_range = [min(p.lon), max(p.lon)];
    lat_range = [min(p.lat), max(p.lat)];
    z_range = [min(p.z), max(p.z)];
    time_range = datetime([settings.date, settings.date], 'ConvertFrom', 'datenum');
    
    %% Salinity
    S = tempSal2Hyperslab(settings.SaltPath, 'salinity', lon_range, lat_range, z_range, time_range);
    p.S = S.select(p.lon, p.lat, p.z, settings.date*ones(1, p.np));  % g / kg
    
    %% Temperature
    T = tempSal2Hyperslab(settings.TempPath, 'water_temp', lon_range, lat_range, z_range, time_range);
    p.T = T.select(p.lon, p.lat, p.z, settings.date*ones(1, p.np));  % g / kg
    
    %% Chlorophyll
    chl_surf = chlSurf2Hyperslab(settings.ChlSurfPath, lon_range, lat_range, time_range);
    p.chl = chl_surf;  % mg m^-3
    
    %% Light
    p.I = 1000*ones(1, p.np);  % will calculate from I_surf, micro mol quanta m^-2 s^-1
end

