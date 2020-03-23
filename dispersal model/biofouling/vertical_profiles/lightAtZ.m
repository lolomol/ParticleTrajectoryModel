function I_z = lightAtZ(z, I_surf, chl_tot)
%LIGHTATZ calculate the light intensity at depth z, given surface light
%   intensity and the depth-integrated chlorophyll above z.
%   Method from Lorenzen 1972 (https://doi.org/10.1093/icesjms/34.2.262)
%   Inputs are vectors length n, output is vector length n
%   z: depth (m, positive down)
%   I_surf: light intensity at surface (micro mol quanta m^-2 s^-1)
%   chl_tot: depth-integrated chlorophyll concentration above z (mg m^-2)
%   returns: light intensity at depth z (micro mol quanta m^-2 s^-1)
    
    K_1 = .0384; % extinction coefficient of seawater (m^-1), Lorenzen, just after eq. 3
    K_2 = .0138; % extinction coefficient of  chlorophyll (m^-1 (mg chl m^-2)^-1), Lorenzen, just after eq. 3
    KZ = K_1*z + K_2*chl_tot;  % eq. 3, assuming only chlorophyll in water column (unitless)
    I_z = I_surf .* exp(-KZ); % from eq. 1
end

