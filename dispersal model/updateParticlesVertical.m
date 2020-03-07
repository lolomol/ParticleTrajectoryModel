function p = updateParticlesVertical(p,dz,settings)

% updateParticlesVertical
% -------------
%
% update particle position
% check for surface/bathymetry boundary
% returns p structure

z_new = p.z + dz;

% Constrain to bathymetry
% gets bathymetry depth using same method as getStokes

% finds i,j indexes for individual particles in bathymetry grid
id = getIndex(p.lon,settings.bathymetry.lon);
jd = getIndex(p.lat,settings.bathymetry.lat);

% find bathymetry depth for individual particles
z_bottom  = zeros(1,p.np);
for k=1:p.np
    z_bottom(k) = - settings.bathymetry.d(id(k),jd(k)); % depth positive down
end

% constrain to ocean floor
z_new(z_new > z_bottom) = z_bottom(z_new > z_bottom);


% Constrain to ocean surface
z_new(z_new < 0) = 0;

% Check for release dates- dont update unreleased particles
if settings.TimeAdvectDir==1
    z_new(p.releaseDate > settings.date) = p.z(p.releaseDate > settings.date);
else
    z_new(p.releaseDate < settings.date) = p.z(p.releaseDate < settings.date);
end

% returns
p.z = z_new;