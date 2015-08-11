function p = loadParticles(settings)


ncid = netcdf.open(settings.SourceFilename,'NOWRITE');

p.id  = netcdf.getVar(ncid,0)';
p.lon = netcdf.getVar(ncid,1)';
p.lat = netcdf.getVar(ncid,2)';
p.releaseDate = netcdf.getVar(ncid,3)';
p.UNSD = netcdf.getVar(ncid,4)';

p.np = length(p.id);

netcdf.close(ncid)


% single release
% p.id=1:2;
% p.lon=ones(1,2)*180;
% p.lat=ones(1,2)*0;
% p.releaseDate = ones(1,2)*0;
% 
% p.np=length(p.id);