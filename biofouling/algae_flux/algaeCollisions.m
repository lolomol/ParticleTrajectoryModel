function dAdt = algaeCollisions(p)
% get_algae_collisions: calculates rate of algae/particle collisions. Kooi 2017, eq. 11, first term
% p: particle structure
% return: change in concentration of algae on particle surface due to collisions (# algal cells m^-2 s^-1)

    %% Brownian Motion Kernel Rate
    r_A = BiofoulingConstants.r_A;  % radius of single algal cell
    mu_sw = dynamicViscositySeawater(p.S, p.T);  % dynamic viscosity seawater at each particle (kg m^-1 s^-1)
    k = BiofoulingConstants.k; % boltzmann constant (m^2 kg s^-2 K^-1)

    D_pl = k * (p.T + 273.16) ./ (6*pi * mu_sw .* p.r_tot);   % diffusivity of plastic particle (m^2 s^-1)
    D_A = k * (p.T + 273.16) ./ (6*pi * mu_sw * r_A);      % diffusivity of algae cell (m^2 s^-1)
    
    Beta_A_brownian = 4*pi * (D_pl + D_A) .* (p.r_tot + r_A);  % brownian motion kernel rate (m^3 s^-1)
    
    %% Settling Velocity Kernel Rate
    Beta_A_settling = 1/2 * pi * p.r_tot.^2 .* abs(p.dzdt);  % differential settling kernel rate (m^3 s^-1)
    
    %% Shear Kernel Rate
    gamma = BiofoulingConstants.gamma; % s^-1
    Beta_A_shear = 1.3 * gamma * (p.r_tot + r_A).^3;  % advective shear kernel rate (m^3 s^-1)
    
    %% Total Kernel Rate
    Beta_A = Beta_A_brownian + Beta_A_settling + Beta_A_shear;  % encounter kernel rate (m^3 s^-1)
    
    %% Ambient Algae Concentration
    % chl_to_C parameterization from Cloern 1995, Kooi's source
    mu_prime = 1; %from N / (K_N + N), Cloern eq. 14, when N (limiting nutrient concentration) is very large (i.e. no nutrient limitation, which Kooi assumes)       
    I_cloern_units = p.I * 1e-6 * seconds(days(1));  % mol quanta m^-2 day^-1, as Cloern uses
    chl_to_carbon_ratio = 0.003 + 0.0154 * exp(0.050*p.T) .* exp(-0.059 * I_cloern_units) * mu_prime;  % mass chlorophyll-a to mass Carbon ratio (kg chl (kg C)^-1)
    A_A = p.chl .* 1./chl_to_carbon_ratio .* 1/BiofoulingConstants.carbon_per_algae; % ambient algae concentration (# algae cells m^-3)
    %% Final Collision Rate
    theta_pl = 4 * pi * p.r_pl.^2;  % surface area of the plastic particle (m^2)
    dAdt = Beta_A .* A_A ./ theta_pl;  % (# algae cells m^-2 s^-1)
end
