function [p, dz] = getVerticalTransport(p, dt, settings, time)
%getVerticalTransport calculate vertical transport via any number of
% arbitrary mechanisms
%   p: particle structure
%   dt: timestep (seconds)

    % mechanism: biofouling
    p = updateForcingDataOnParticles(p, settings, time);  % load T, S, chl, I onto particle
    p = updateBiofouling(p, dt);  % make the algae grow
    p = getSettlingVelocity(p);  % calculate the settling speed
    dz = p.dzdt*dt;  % calculate movement
    
    %{
    % mechanism: force to a specific depth
    dz = settings.forcedDepth - p.z;  % jump particles straight to forced_depth
    %}
    
    %{
    % mechanism: sin wave sinking/resurfacing to forced depth
    current_time = datetime(settings.date, 'ConvertFrom', 'datenum');
    start_time = datetime(settings.initDate, 'ConvertFrom', 'datenum');
    period = 28; % days
    mean_depth = 500;  %m
    amplitude = 500; %m
    z_new = mean_depth + amplitude*sin(2*pi* days(current_time-start_time)/period);
    dz = z_new - p.z;  % jump particles to their spot on the sin wave
    %}
    
end
