function main(p,settings)


p = storeOutput( p, settings);

while settings.date ~= settings.finalDate % !! (settings.finalDate-settings.initDate)/settings.modelTimestep must be integer !!
    
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
    
    % update time
    settings.date = settings.date + settings.TimeAdvectDir* settings.modelTimestep / (24*3600);
    
    % store outputs
    if settings.date == settings.outputDate + settings.TimeAdvectDir*  settings.outputTimestep
        settings.outputDate = settings.date;
        p = storeOutput( p, settings);
%          plotParticles ( p, settings)
    end
    
    
end

% write trajectories to output file
writeOutput ( p, settings)