function plotParticles ( p, settings)

% plotParticles
% -------------
%


% imagesc(settings.landmass.lon,settings.landmass.lat,settings.landmass.data');

contour(settings.landmass.lon,settings.landmass.lat,settings.landmass.data',[1 1],'k')
hold on
plot(p.lon(p.releaseDate < settings.date),p.lat(p.releaseDate < settings.date),'.k')
plot(p.lon(p.releaseDate >= settings.date),p.lat(p.releaseDate >= settings.date),'.b','markersize',1)
hold off

axis xy
axis image

xlim([min(p.lon) max(p.lon)])
ylim([min(p.lat) max(p.lat)])

title(datestr(settings.date))
drawnow