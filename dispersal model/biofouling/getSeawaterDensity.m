function rho_sw = getSeawaterDensity(p)
%GET_SEAWATER_DENSITY calculate rho_sw at each particle (kg m^-3) 
    
    % parameterization from Sharqawy et al 2010, cited by Kooi 2017
    S = p.S/1000;  % convert g/kg to kg/kg
    T = p.T;
    
    a_1 = 9.999E2;
    a_2 = 2.034E-2;
    a_3 = -6.162E-3;
    a_4 = 2.261E-5;
    a_5 = -4.657E-8;
    b_1 = 8.020E2;
    b_2 = -2.001;
    b_3 = 1.677E-2;
    b_4 = -3.060e-5;
    b_5 = -1.613e-5;
    rho_sw = (a_1 + a_2*T + a_3*T.^2 + a_4*T.^3 + a_5*T.^4) + ...
              (b_1*S + b_2*S.*T + b_3*S.*T.^2 + b_4*S.*T.^3 + b_5*S.^2.*T.^2);
end
