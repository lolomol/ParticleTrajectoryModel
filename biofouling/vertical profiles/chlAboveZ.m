function chl_tot = chlAboveZ(z, chl_surf, stratified)
%CHLABOVETZ Calculates the vertically integrated chlorophyll concentration from 0 to z, given surface
%   concentration and a boolean indicating whether the water column is
%   vertically stratified (true) or mixed (false).  Method is coarse numerical
%   integration of chlAtZ.  
%z: depth (m)
%chl_surf: surface chlorophyll-a concentration (mg m^-3)
%stratified: is water column stratified? (boolean.  False implies mixed water column.)
%return: integrated chlorophyll-a concentration above depth z (mg m^-2)
    chl_tot = zeros(1, length(z));
    % coarse numeric integration.  Does ok for 0 < z < 8000, good enough
    num_samples = 25;
    for i=1:length(z)
        sample_z = logspace(log10(.1), log10(z(i)), num_samples);  % log spaced sampling from .1m depth to z, much better than linear because the profile is only interesting in top 100ms of ocean
        %sample_z = linspace(.1, z(i), num_samples);
        sample_prof = chlAtZ(sample_z, chl_surf(i)*ones(1, num_samples), logical(stratified(i)*ones(1, num_samples)));
        chl_tot(i) = trapz(sample_z, sample_prof);
    end
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
chl_tot = chlAboveZ(z, chl_surf, stratified);
plot(chl, -z);
legend('chlAtZ (mg m^{-3})', 'location', 'south');
subplot(2, 4, 2); hold on;
plot(chl_tot, -z, 'r');
legend('chlAboveZ (mg m^{-2})', 'location', 'south');

subplot(2, 4, 3); hold on;
z = linspace(0, 8000, 100);
chl = chlAtZ(z, chl_surf, stratified);
chl_tot = chlAboveZ(z, chl_surf, stratified);
plot(chl, -z);
subplot(2, 4, 4); hold on;
plot(chl_tot, -z, 'r');

subplot(2, 4, 5); hold on;
ylabel('mixed profile');
z = linspace(0, 300, 100);
chl = chlAtZ(z, chl_surf, ~stratified);
chl_tot = chlAboveZ(z, chl_surf, ~stratified);
plot(chl, -z);
subplot(2, 4, 6); hold on;
plot(chl_tot, -z, 'r');

subplot(2, 4, 7); hold on;
z = linspace(0, 8000, 100);
chl = chlAtZ(z, chl_surf, ~stratified);
chl_tot = chlAboveZ(z, chl_surf, ~stratified);
plot(chl, -z);
subplot(2, 4, 8); hold on;
plot(chl_tot, -z, 'r');
%}