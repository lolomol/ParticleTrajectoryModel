function main(p,settings)

forcings = struct();  % init forcings

p = storeOutput( p, settings);
while settings.TimeAdvectDir*settings.date < settings.TimeAdvectDir*settings.finalDate % !! (settings.finalDate-settings.initDate)/settings.modelTimestep must be integer !!
    forcings = loadForcings(forcings, settings);  % attempt to refresh forcings every model step
    
    % init forcing constituents
    u=0;v=0;
    us=0;vs=0;
    uw=0;vw=0;
    Dx=0;Dy=0;
    
    % get sea surface current constituents
    if settings.ForcingCurrent
        [u,v] = getSScurrent( p, settings );
    end
    
    
    % get wind constituents
    if settings.ForcingWind
        try
            [uw,vw] = getWindage( p, settings );
        catch
            disp(['Could not find wind data - no windage at ' datestr(settings.date)])
        end
    end
    
    % get stokes drift constituents
    if settings.ForcingWaves
        try
            [us,vs] = getStokes( p, settings );
        catch
            disp(['Could not find wave data - no stokes drift at ' datestr(settings.date)])
        end
    end
    
    % get turbulent diffusion constituents
    if settings.ForcingDiffusion
        [Dx,Dy] = getDiffusion( p, settings );
    end
    
    % advect
    dt = settings.modelTimestep;
    dx = settings.TimeAdvectDir *( u*dt + us*dt + uw*dt + Dx );
    dy = settings.TimeAdvectDir *( v*dt + vs*dt + vw*dt + Dy );
    p = updateParticles( p, dx, dy, settings);
    
    % transport vertical, with smaller timesteps
    small_dt = settings.modelTimestep/settings.nestedVerticalTimesteps;
    for i=1:settings.nestedVerticalTimesteps
        [p, dz] = getVerticalTransport(p, small_dt, settings, forcings);
        p = updateParticlesVertical(p, dz, settings);
        
        % update time
        settings.date = settings.date + settings.TimeAdvectDir*days(seconds(small_dt));
        % store if we need to
        if settings.date >= settings.outputDate
            p = storeOutput( p, settings);
            plotParticles ( p, settings)
            settings.outputDate = settings.outputDate + settings.TimeAdvectDir*  settings.outputTimestep;
        end
    end
    
end

% write trajectories to output file
writeOutput ( p, settings)