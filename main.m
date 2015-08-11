clear;

loadSettings;

% for country=24%1:length(settings.UNSDlist)
%     
%     settings.UNSD = num2str( settings.UNSDlist(country) );
    
    settings.date = settings.initDate;
    settings.outputDate = settings.initDate;
    settings.outputDateList = settings.initDate : settings.TimeAdvectDir* settings.outputTimestep : settings.finalDate;
    
%     try
        p = loadParticles( settings );
%     catch
%         disp(['error loading particles source for UNSD ' settings.UNSD ' - Skipping'])
%         continue
%     end
%     
    LON=zeros( length(settings.outputDateList) ,p.np);
    LAT=zeros( length(settings.outputDateList) ,p.np);
    
    [LON,LAT] = storeOutput( LON, LAT, p, settings);

%     createOutputFile( p, settings )
%     writeOutput ( p, settings) 

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
            [uw,vw] = getWindage( p, settings );
        end

        if settings.ForcingWaves
            [us,vs] = getStokes( p, settings );
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
%             writeOutput ( p, settings) 
            [LON,LAT] = storeOutput( LON, LAT, p, settings);
%             disp('done')
            plotParticles ( p, settings)
        end


    end
    
     writeOutput ( p, settings)
     
     
    toc

% end

