function chl_tot = chlAboveZ(z, chl_surf, chl_z, stratified)
%CHLABOVETZ Calculates the vertically integrated chlorophyll concentration from 0 to z, given surface
%   concentration and a boolean indicating whether the water column is
%   vertically stratified (true) or mixed (false).
%z: depth (m)
%chl_surf: surface chlorophyll-a concentration (mg m^-3)
%chl_z: chlorophyll-a concentration at depth z
%stratified: is water column stratified? (boolean.  False implies mixed water column.)
%return: integrated chlorophyll-a concentration above depth z (mg m^-2)
    chl_tot = zeros(1, length(z));
    chl_tot(stratified) = chlAboveZStratified(z(stratified), chl_surf(stratified));
    chl_tot(~stratified) = chlAboveZMixed(z(~stratified), chl_surf(~stratified), chl_z(~stratified));
end

function chl_tot = chlAboveZStratified(z, chl_surf)
    chl_tot = zeros(1, length(z));
    % coarse numeric integration.  Does ok for 0 < z < 8000, good enough
    num_samples = 25;
    for i=1:length(z)
        sample_z = logspace(log10(.1), log10(z(i)), num_samples);  % log spaced sampling from .1m depth to z, much better than linear because the profile is only interesting in top 100ms of ocean
        %sample_z = linspace(.1, z(i), num_samples);
        sample_prof = chlAtZ(sample_z, chl_surf(i)*ones(1, num_samples), true(1, num_samples));
        chl_tot(i) = trapz(sample_z, sample_prof);
    end
end

function chl_tot = chlAboveZMixed(z, chl_surf, chl_z)
    % symbolic integration of mixed profile, by parts
    z_eu = UitzConstants.ave_Z_eu_mixed(UitzConstants.mixed_concentration_class(chl_surf));
    
    chl_tot = zeros(1, length(z));
    
    case1 = (z <= z_eu);
    chl_tot(case1) = chl_surf(case1).*z(case1);
    
    case2 = ((z_eu < z) & (z < 3*z_eu));
    chl_tot(case2) = 2*chl_surf(case2).*z_eu(case2)- ...  % total amount in profile, then subtract off...
                    .5 * (3*z_eu(case2) - z(case2)) .* chl_z(case2); % area of triangle below z)
    
    case3 = (z >= 3*z_eu);
    chl_tot(case3) = 2*chl_surf(case3).*z_eu(case3);
end
    

%{
% try this to see how good the integration is
chl_surf = ones(1, 100);
stratified = logical(ones(1, 100));
figure; hold on;
subplot(2, 4, 1); hold on;
ylabel('stratified profile');
z = linspace(0, 300, 100);
chl = chlAtZ(z, chl_surf, stratified);
chl_tot = chlAboveZ(z, chl_surf, chl, stratified);
plot(chl, -z);
legend('chlAtZ (mg m^{-3})', 'location', 'south');
subplot(2, 4, 2); hold on;
plot(chl_tot, -z, 'r');
legend('chlAboveZ (mg m^{-2})', 'location', 'south');

subplot(2, 4, 3); hold on;
z = linspace(0, 8000, 100);
chl = chlAtZ(z, chl_surf, stratified);
chl_tot = chlAboveZ(z, chl_surf, chl, stratified);
plot(chl, -z);
subplot(2, 4, 4); hold on;
plot(chl_tot, -z, 'r');

subplot(2, 4, 5); hold on;
ylabel('mixed profile');
z = linspace(0, 300, 100);
chl = chlAtZ(z, chl_surf, ~stratified);
chl_tot = chlAboveZ(z, chl_surf, chl, ~stratified);
plot(chl, -z);
subplot(2, 4, 6); hold on;
plot(chl_tot, -z, 'r');

subplot(2, 4, 7); hold on;
z = linspace(0, 8000, 100);
chl = chlAtZ(z, chl_surf, ~stratified);
chl_tot = chlAboveZ(z, chl_surf, chl, ~stratified);
plot(chl, -z);
subplot(2, 4, 8); hold on;
plot(chl_tot, -z, 'r');
%}