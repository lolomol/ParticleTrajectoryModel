function plotParticles ( p, settings)

% plotParticles
% -------------
%


% imagesc(settings.landmass.lon,settings.landmass.lat,settings.landmass.data');



plot(p.lon,p.lat,'.k')


axis xy
axis image

title(datestr(settings.date))
drawnow