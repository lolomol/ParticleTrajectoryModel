function p = updateForcingDataOnParticles(p, settings)
%LOADFORCINGDATA loads the local forcing data conditions onto each particle
%   p: the particle structure
%   returns: the modified particle structure

    %% Temp/Salinity
    p.S = settings.S.select(p.lon, p.lat, p.z, settings.date*ones(1, p.np));  % g / kg
    p.T = settings.T.select(p.lon, p.lat, p.z, settings.date*ones(1, p.np));  % g / kg
    
    %% Chlorophyll
    chl_surf = settings.chl_surf.select(p.lon, p.lat, p.z, settings.date*ones(1, p.np));  % mg m^-3
    chl_surf(isnan(chl_surf)) = median(chl_surf, 'omitnan');  % not the best assumption, but we can't have nans
    %stratified = true(1, p.np);  % assume all waters stratified
    stratified = false(1, p.np); % assume all waters mixed
    p.chl = chlAtZ(p.z, chl_surf, stratified);
    
    %% Light
    I_surf = getSurfacePAR(p.lat, p.lon, datetime(settings.date, 'convertfrom', 'datenum'));  % will calculate from I_surf, micro mol quanta m^-2 s^-1
    chl_tot = chlAboveZ(p.z, chl_surf, p.chl, stratified);
    p.I = lightAtZ(p.z, I_surf, chl_tot);
end

