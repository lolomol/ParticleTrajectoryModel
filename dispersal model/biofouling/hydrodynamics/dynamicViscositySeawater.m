function mu_sw = dynamicViscositySeawater (S, T)
% dynamic_viscosity_seawater: calculate dynamic viscosity of seawater at each particle
% empirical parameterization used in Kooi 2017 eq. 26-29, from Sharqawy 2010 (DOI: 10.5004/dwt.2010.1079) eq. 22-23
% S: salinity (g / kg)
% T: water temp (celsius)
% return: dynamic viscosity of seawater (kg m^-1 s^-1)

  S = S / 1000;  % we need kg / kg for this parameterization
  mu_w = 4.2844e-5 + (0.157 * (T + 64.993).^2 - 91.296).^-1;
  % mu_w: dynamic viscosity of water (kg m^-1 s^-1)
  
  A = 1.541 + 1.998e-2 * T - 9.52e-5 * T.^2;
  B = 7.974 - 7.561e-2 * T + 4.724e-4 * T.^2;
  mu_sw = mu_w .* (1 + A.*S + B.*S.^2);
end