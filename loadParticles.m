function p = loadParticles(settings)


ncid = netcdf.open(settings.SourceFilename,'NOWRITE');

p.id  = netcdf.getVar(ncid,0)';
p.lon = netcdf.getVar(ncid,1)';
p.lat = netcdf.getVar(ncid,2)';
p.releaseDate = netcdf.getVar(ncid,3)';
p.UNSD = netcdf.getVar(ncid,4)';

p.np = length(p.id);

netcdf.close(ncid)

p.LON=zeros( length(settings.outputDateList) ,p.np);
p.LAT=zeros( length(settings.outputDateList) ,p.np);
