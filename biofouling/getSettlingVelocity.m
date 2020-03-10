function dzdt = getSettlingVelocity(p)
%GETSETTLINGVELOCITY return the vertical buoyancy driven terminal velocity
%   for the particles provided
    %    Kooi 2017, eq. 2
    % p: particle structure
    % return: settling velocity of the particles (m/s)
    g = BiofoulingConstants.g;  % gravitational acceleration, m s^-2
        
    rho_sw = getSeawaterDensity(p);  % calculates seawater density at each particle
    
    nu_sw = dynamicViscositySeawater(p)./rho_sw;   % kinematic viscosity (m^2 s^-1)
    
    omega_star = dimensionlessSettlingVelocity(p, rho_sw, nu_sw);
    
    dzdt = nthroot(((p.rho_tot - rho_sw)./rho_sw .* g .* omega_star.*nu_sw), 3); 
end
