function dz = getVerticalTransport(p, dt, settings)
%getVerticalTransport calculate vertical transport via any number of
% arbitrary mechanisms
%   p: particle structure
%   dt: timestep (seconds)

    % mechanism: biofouling
    %{
    p = updateBiofouling(p);
    dzdt = getSettlingVelocity(p);
    dz = dzdt*dt;
    %}

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
