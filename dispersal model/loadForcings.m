function forcings = loadForcings(forcings, settings)
%LOADFORCINGS based on settings, update existing forcing data if necessary
%   this gets called every horizontal timestep, and is where the logic
%   resides to decide whether forcings need to be updated.
%   currently only loads forcing data for biofouling, but is generic enough
%   to in the future load currents, or anything really.

    if isempty(fieldnames(forcings))     %INITIALIZE FORCINGS
        % load ALL the biofouling forcing data (this may not work when files get bigger)
        if settings.verticalTransport == "biofouling"
            time_range = datetime([settings.initDate, settings.finalDate], 'convertfrom','datenum');

            [T, S] = tempSal2Hyperslab(settings.TempSaltPath, settings.forcingsLonRange, settings.forcingsLatRange, settings.forcingsDepthRange, time_range);
            chl_surf = chlSurf2Hyperslab(settings.ChlSurfPath, settings.forcingsLonRange, settings.forcingsLatRange, time_range);

            forcings.T = T;
            forcings.S = S;
            forcings.chl_surf = chl_surf;
        end
    else
        % here you could update forcing data as settings.date changes, if
        % you want to chunk forcing data because of RAM limitations
        % e.g.
        % if settings.date > forcings.T.time(end)
        %   forcings.T = *load next month of temperature data*
        % end
    end
end
