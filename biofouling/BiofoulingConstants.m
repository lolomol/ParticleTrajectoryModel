classdef BiofoulingConstants
    % Constants needed for biofouling calculations
    properties (Constant)
        % PHYSICAL CONSTANTS
        g = 9.81;  % gravitational acceleration (m s^-2, positive down)
        k = 1.38064852e-23 % boltzmann constant (m^2 kg s^-2 K^-1)
        
        % ALGAE PROPERTIES
        V_A = 2e-16; % volume of individual algae particle (m^3)
        r_A = nthroot(3 / (4*pi) * BiofoulingConstants.V_A, 3);  % radius of algal cell (m)
        rho_A = 1388; % density of algae (kg m^-3)
        
        % GROWTH PROPERTIES
        gamma = 1.7e5 / seconds(days(1)); % shear rate (s^-1)
        carbon_per_algae = 2726 * 1e-9; % mass carbon per algal cell (mg carbon (algal cell)^-1)
        %m_A = .39 / constants.seconds_per_day;  % mortality rate (s^-1)
        %T_min = .2;   % min temp for growth (Celsius)
        %T_max = 33.3;   % max temp for growth (Celsius)
        %T_opt = 26.7;   % optimal temp for growth (Celsius)
        %Q_10 = 2; % Temperature dependence coefficient respiration (unitless)
        %Resp_A = .1 / constants.seconds_per_day; % Respiration rate (s^-1)
        %mu_max = 1.85 / constants.seconds_per_day; %  max growth rate algae (s^-1)
        %alpha = .12 / constants.seconds_per_day;  % initial slope growth rate algae (s^-1)
        %I_opt = 1.75392e13 / constants.seconds_per_day; % optimal light intensity algae growth (micro mol quanta m^-2 s^-1)
    end
end
