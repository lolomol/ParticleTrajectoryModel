function p = updateParticles(p,dx,dy,settings)

% updateParticles
% -------------
%
% update particle position
% check for land and grid boundary
% returns p structure

dlon = m2lon(dx,p.lat);
dlat = m2lat(dy,p.lat);

lon_new = p.lon + dlon;
lat_new = p.lat + dlat;


% Greenwich meridian
lon_new = mod(lon_new,360);

% North Pole
lat_new(lat_new>90)=90;

% Check for coastlines 
id = getIndex(lon_new,settings.grid.lon) ;
jd = getIndex(lat_new,settings.grid.lat) ;

land=zeros(p.np,1);
for k=1:p.np
    land(k) = settings.grid.land(id(k),jd(k));
end

[lon_new, lat_new] = treatShoreline(p, settings, dlon, dlat, id, jd,...
                                        lon_new, lat_new, land);
     


% Check for release dates- dont update unreleased particles
if settings.TimeAdvectDir==1
    lat_new(p.releaseDate > settings.date) = p.lat(p.releaseDate > settings.date);
    lon_new(p.releaseDate > settings.date) = p.lon(p.releaseDate > settings.date);
else
    lat_new(p.releaseDate < settings.date) = p.lat(p.releaseDate < settings.date);
    lon_new(p.releaseDate < settings.date) = p.lon(p.releaseDate < settings.date);
end

% returns
p.lon = lon_new;
p.lat = lat_new;