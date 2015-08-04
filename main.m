clear;

loadSettings;

p = loadParticles( settings );

createOutputFile( p, settings )
writeOutput ( p, settings) 

 tic
while settings.date <= settings.finalDate 
    
    % get forcing constituents
    [u,v] = getSScurrent( p, settings );
    [us,vs] = getStokes( p, settings );
    [uw,vw] = getWindage( p, settings );
    [Dx,Dy] = getDiffusion( p, settings );
    
%     u=0;v=0;
%     us=0;vs=0;
%     uw=0;vw=0; 
%     Dx=0;Dy=0; 
    
    % advect
    dt = settings.modelTimestep;
    dx = u*dt + us*dt + uw*dt + Dx;
    dy = v*dt + vs*dt + vw*dt + Dy;

    p = updateParticles( p, dx, dy, settings);
    
    % update time
    settings.date = settings.date + settings.modelTimestep / (24*3600);
    
    if settings.date >= settings.outputDate + settings.outputTimestep
        settings.outputDate = settings.date;
        disp(['write output at ' datestr(settings.date)])
        writeOutput ( p, settings) 
        disp('done')
    end

    plotParticles ( p, settings)

end
toc


