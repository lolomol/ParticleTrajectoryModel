function settings = loadForcingData(p, settings, time_range)
%LOADFORCINGDATA loads T, S, and chl_surf for given time into ram

    % load in current timestep, physical range of particles
    lon_range = [min(p.lon), max(p.lon)];
    lat_range = [min(p.lat), max(p.lat)];
    z_range = [min(p.z), max(p.z)];

    [T, S] = tempSal2Hyperslab(settings.TempPath, lon_range, lat_range, z_range, time_range);
    chl_surf = chlSurf2Hyperslab(settings.ChlSurfPath, lon_range, lat_range, time_range);

    settings.T = T;
    settings.S = S;
    settings.chl_surf = chl_surf;
end

