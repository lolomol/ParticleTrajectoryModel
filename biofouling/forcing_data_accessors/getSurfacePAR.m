function PAR_surf = getSurfacePAR(lat, lon, time)
%GET_SURFACE_PAR get photosynthetically active radiation irradiance using solar
% geometry.  Assumes no cloud cover.  Method from Khavrus & Shelevytsky 2012
%   lat: latitude (Degrees N)
%   lon: longitude (Degrees E)
%   date: date and time of query, UTC (matlab datetime object)
%   returns: surface PAR (micro mol quanta m^-2 s^-1)
    
    alpha = deg2rad(23.45); % Earth's axial tilt (radians)
    phi = deg2rad(lat);
    I_max = 1360;  % ave solar irradiance outside atmosphere (W m^-2) (Khavrus 2012 near eq. 2)
    T = days(time - datetime(year(time), 3, 20));
        % date counted from spring equinox (20 Mar)
    local_time = time + days(1) .* double(lon)/360; % convert to local solar time
                                        % (assuming UTC ~ GMT solar time)
    t = minutes(timeofday(local_time));
        % local solar time in minutes from midnight of day T
    
    theta = alpha*sin(2*pi*T/365.25);  % eq. 3
    z = sin(phi).*sin(theta) - cos(phi).*cos(theta).*cos(2*pi*t/1440);  % eq. 3
    z(z < 0) = 0;  % sun's height in the sky is zero when it has set
    
    AM = 1./(z + .50572*(6.07995 + asin(z)).^-1.6364); % eq. 8
    % optical air mass value (basically scales how much light reaches the
        % surface due to increased effective atmospheric thickness when
            % sun is at a low elevation above horizon)
    
    I_GN = 1.1*1.353*.7.^(AM.^.678);  % eq. 11
    % total global irradiance reaching the earth's surface on a cloudless
        % day on a plane perpendicular to the sun's rays
        
    I_surf = I_max * I_GN .* z;  % eq. 5
    
    PAR_over_tot = .48; % typical PAR/total irradiance (Fig. 1, Baker, K.S. and R. Frouin. 1987)
    micro_mol_quanta_per_m_sq_per_s_over_W_per_m_sq = 4.57; % 1 micro mol quanta m^-2 s^-1 : 1 W m^-2 for PAR (400-700nm light) (Table 3, sunlight, Thimijan and Heins 1983)
    PAR_surf = I_surf * PAR_over_tot * micro_mol_quanta_per_m_sq_per_s_over_W_per_m_sq;  % convert total surface irradiance to PAR in units micro mol quanta m^-2 s^-1
end
