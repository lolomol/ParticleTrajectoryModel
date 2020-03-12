function chl = chlAtZ(z, chl_surf, stratified)
%CHLATZ Calculates the chlorophyll concentration at depth, given surface
%   concentration and a boolean indicating whether the water column is
%   vertically stratified (true) or mixed (false).  Method from Uitz 2006, cited by Kooi 2017.
%   Operates on vectors length n, returns vector length n.
%z: depth (m)
%chl_surf: surface chlorophyll-a concentration (mg m^-3)
%stratified: is water column stratified? (boolean.  False implies mixed water column.)
    % stratified acts as a mask
    chl = zeros(1, length(z));
    chl(stratified) = chlAtZStratified(z(stratified), chl_surf(stratified));
    chl(~stratified) = chlAtZMixed(z(~stratified), chl_surf(~stratified));
end

function chl = chlAtZStratified(z, chl_surf)
%CHLATZSTRATIFIED calculates the chl-a concentration at depth z in a stratified water mass,
%   given the surface concentration.  Inputs and output are vectors length n.
%z: depth (m)
%chl_surf: surface chlorophyll-a concentration (mg m^-3)
%returns: chlorophyll-a concentration at depth z (mg m^-3)
    % Assume a euphotic depth based on chl_surf (Uitz table 3)
    % and convert z to zeta (fraction of euphotic depth)
    Z_eu = UitzConstants.ave_Z_eu_stratified;
    Si = UitzConstants.stratified_concentration_class(chl_surf);
    zeta = z./Z_eu(Si);

    % get the normalized concentration
    c = c_vs_zeta_stratified(zeta, Si);  % normalized concentration, chl_a(zeta)/(average [chl_a] in euphotic zone)

    % now, we scale the normalized concentration to the real concentration
    % not by estimating average [chl_a] in euphotic zone, as Uitz does it,
    % but by directly scaling to match surface chlorophyll, as it's the
    % value we actually know.  I think this is better than Uitz (Doug Klink)
    c_surf = c_vs_zeta_stratified(0, Si);
    scaling_factor = chl_surf./c_surf;   % note, if chl_surf=0, the profile will be flattened to zeros.  But, if chl_surf=0, assuming no chlorophyll through whole water column isn't entirely unreasonable.
    chl = c.*scaling_factor;
end


function c = c_vs_zeta_stratified(zeta, Si)
%CHL_VS_Z_STRATIFIED the shape of profile of chlorophyll_a in stratified
%                       waters given by Uitz 2006
%   zeta: dimensionless depth (depth / euphotic depth), vector length n
%   Si: concentration class of surface chlorophyll, vector length n
%   return: dimensionless chlorophyll concentration at depth zeta ((chl_a concentration at zeta) / (mean chl_a concentration in euphotic layer)), vector length n
    
    % all these have 9 entries corresponding to concentration classes S1, S2, ..., S9
    C_b = UitzConstants.C_b_stratified;
    s = UitzConstants.s_stratified;
    C_max = UitzConstants.C_max_stratified;
    zeta_max = UitzConstants.zeta_max_stratified;
    delta_zeta = UitzConstants.delta_zeta_stratified;
    
    c = C_b(Si) - s(Si).*zeta + C_max(Si) .* exp(-((zeta - zeta_max(Si))./delta_zeta(Si)).^2);  % Uitz eq. 7
    
    c(c < 0) = 0;  % no negative concentrations please
end


function chl = chlAtZMixed(z, chl_surf)
%CHLATZMIXED calculates the chl-a concentration at depth z in a mixed water mass,
%   given the surface concentration.  Inputs and output are vectors length n.
%   method follows Uitz 2006's description of chl_a profile in mixed
%   waters, section 4.2.2.
%z: depth (m)
%chl_surf: surface chlorophyll-a concentration (mg m^-3)
%returns: chlorophyll-a concentration at depth z (mg m^-3)
    Mi = UitzConstants.mixed_concentration_class(chl_surf);
    z_eu = UitzConstants.ave_Z_eu_mixed(Mi);  % get Uitz' estimated euphotic depth given surface concentration class

    chl = zeros(1, length(z));
    case1 = z < z_eu;     % profile flat until z_eu
    chl(case1) = chl_surf(case1);
    
    case2 = (z_eu < z) & (z < 3*z_eu); % profile decreasese linearly after z_eu, halving by 2*z_eu (thus reaching zero at 3*z_eu)
    chl(case2) = chl_surf(case2) - chl_surf(case2)./(2*z_eu(case2)) .* (z(case2) - z_eu(case2));
    
    case3 = z > 3*z_eu;  % no chlorophyll below 3*z_eu
    chl(case3) = 0;
end