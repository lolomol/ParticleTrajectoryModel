clear;

initYear = 1993;

for currentYear = 1997:1999
    
    loadSettings;
    p = loadParticles( settings );
    
    disp(['store output at ' datestr(settings.date)])
    p = storeOutput( p, settings);
    
    tic
    while settings.date ~= settings.finalDate % !! (settings.finalDate-settings.initDate)/settings.modelTimestep must be integer !!
        
        % get forcing constituents
        
        u=0;v=0;
        us=0;vs=0;
        uw=0;vw=0;
        Dx=0;Dy=0;
        
        if settings.ForcingCurrent
            [u,v] = getSScurrent( p, settings );
        end
        
        if settings.ForcingWind
            try
                [uw,vw] = getWindage( p, settings );
            catch
                disp(['Could not find wind data - no windage at ' datestr(settings.date)])
            end
        end
        
        if settings.ForcingWaves
            try
                [us,vs] = getStokes( p, settings );
            catch
                disp(['Could not find wave data - no stokes drift at ' datestr(settings.date)])
            end
        end
        
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
        
        if settings.date == settings.outputDate + settings.TimeAdvectDir*  settings.outputTimestep
            settings.outputDate = settings.date;
            disp(['store output at ' datestr(settings.date)])
            p = storeOutput( p, settings);
            plotParticles ( p, settings)
        end
        
        
    end
    
    writeOutput ( p, settings)
    
    
    toc
    
end