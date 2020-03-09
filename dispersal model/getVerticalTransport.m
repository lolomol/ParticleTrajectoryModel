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

    % mechanism: force to a specific depth
    dz = settings.forcedDepth - p.z;  % jump particles straight to forced_depth
end
