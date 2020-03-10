function omega_star = dimensionlessSettlingVelocity (p, rho_sw, nu_sw)
% dimensionless_settling_velocity: kooi 2017 eq. 3 & 4
% p: particle structure
% rho_sw: seawater density at each particle
% nu_sw: kinematic viscosity of seawater at each particle
% return: dimensionless settling velocity for each particle (unitless)
    
    % calculate dimensionless particle diameter
    g = BiofoulingConstants.g; % m s^-2
    D_n = 2*p.r_tot;  % equivalent spherical particle diameter
    D_star = abs(p.rho_tot - rho_sw) .* g .* D_n.^3 ./ (rho_sw .* nu_sw.^2);
    
    
    % calculate dimensionless settling velocity
    omega_star = zeros([1, p.np]);
    case1 = D_star < .05;
    omega_star(case1) = 1.74e-4 * D_star(case1).^2;
    
    case2 = D_star <= 5e9;
    D_star2 = D_star(case2);
    omega_star(case2) = 10.^(-3.76715 + 1.92944*log10(D_star2) - ...
      0.09815 * log10(D_star2).^2 - 0.00575 * log10(D_star2).^3 + ...
        0.00056*log10(D_star2).^4);
        
    case3 = D_star > 5e9;
    omega_star(case3) = nan;
end
