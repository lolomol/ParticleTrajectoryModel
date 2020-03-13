function [p, dz] = getVerticalTransport(p, dt, settings)
%getVerticalTransport calculate vertical transport via any number of
% arbitrary mechanisms
%   p: particle structure
%   dt: timestep (seconds)

    if settings.verticalTransport == "biofouling"
        % mechanism: biofouling
        p = updateForcingDataOnParticles(p, settings);  % load T, S, chl, I onto particle
        p = updateBiofouling(p, dt);  % make the algae grow
        p = getSettlingVelocity(p);  % calculate the settling speed
        dz = p.dzdt*dt;  % calculate movement
    elseif settings.verticalTransport == "fixed_depth"
        % mechanism: force to a specific depth
        dz = settings.fixedDepth - p.z;  % jump particles straight to forced_depth
    elseif settings.verticalTransport == "oscillating"
    % mechanism: sin wave sinking/resurfacing to forced depth
        current_time = datetime(settings.date, 'ConvertFrom', 'datenum');
        start_time = datetime(settings.initDate, 'ConvertFrom', 'datenum');
        period = 28; % days
        mean_depth = 500;  %m
        amplitude = 500; %m
        z_new = mean_depth + amplitude*sin(2*pi* days(current_time-start_time)/period);
        dz = z_new - p.z;  % jump particles to their spot on the sin wave
    else
        error('You must specify a vertical transport mechanism.  See loadSettings.m');
    end
end
