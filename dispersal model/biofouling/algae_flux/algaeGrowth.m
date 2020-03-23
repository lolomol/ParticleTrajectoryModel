function dAdt = algaeGrowth(p)
% ALGAEGROWTH: calculates rate of algae growth for each particle. Kooi 2017, eq. 11, first term
% p: particle structure
% return: change in concentration of algae on particle surface due to growth (# algal cells m^-2 s^-1)
    
    %% Growth under optimal temp conditions
    %Kooi 2017 eq. 17, from Bernard 2012, eq. 3.
    mu_max = BiofoulingConstants.mu_max; % maximum growth rate (s^-1)
    alpha = BiofoulingConstants.alpha;   % initial slope (s^-1)
    I_opt = BiofoulingConstants.I_opt;   % optimal light intensity (micro mol quanta m^-2 s^-1)
    % I and I_opt must use Bernard's light units (the parameterization is unit dependent): micro mol quanta m^-2 s^-1
    
    optimal_temp_growth = mu_max * p.I ./ (p.I + mu_max/alpha * (p.I ./ I_opt - 1).^2);  % growth per unit algae (s^-1)
    
    %% Temp influence on growth
    % Kooi 2017 Eq. 18
    T_min = BiofoulingConstants.T_min;   % min temp for growth (Celsius)
    T_max = BiofoulingConstants.T_max;   % max temp for growth (Celsius)
    T_opt = BiofoulingConstants.T_opt;   % optimal temp for growth (Celsius)
    T = p.T;
    temperature_influence = ((T - T_max) .* (T - T_min).^2) ./  ... 
        ((T_opt - T_min) * ((T_opt - T_min)*(T - T_opt) - (T_opt - T_max)*(T_opt + T_min - 2*T)));
    temperature_influence(T < T_min | T > T_max) = 0;  % no growth outside acceptable temp range
    
    %% Total growth
    dAdt = optimal_temp_growth .* temperature_influence .* p.A; % (# algae cells m^-2 s^-1)
end
