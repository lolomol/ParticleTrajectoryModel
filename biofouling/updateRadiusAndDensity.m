function p = updateRadiusAndDensity(p)
%UPDATERADIUSANDDENSITY updates the total radius and density for each particle
%   from Kooi 2017
    V_A = BiofoulingConstants.V_A; % volume of single algal particle (m^3)
    rho_A = BiofoulingConstants.rho_A;  % density of algae (kg m^-3)
    
    V_pl = 4/3 * pi * p.r_pl.^3;  % volume of the plastic particle (m^3)
    theta_pl = 4 * pi * p.r_pl.^2;  % surface area of the plastic particle (m^2)
    
    new_V_bf = V_A * p.A .* theta_pl;  % volume of attached algae (m^3)
    new_V_tot = new_V_bf + V_pl;      % total volume of conglomerate (m^3)
    
    p.r_tot = (3/(4*pi) * new_V_tot).^(1/3);  % total radius of conglomerate (m)
    p.rho_tot = (p.rho_pl.*V_pl + rho_A.*new_V_bf) ... % total density of conglomerate (kg m^-3)
                    ./ new_V_tot;
end
