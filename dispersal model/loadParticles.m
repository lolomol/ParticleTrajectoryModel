function p = loadParticles(settings)


fileInfo=ncinfo(settings.SourceFilename);

if strcmp(fileInfo.Variables(1).Name,'time') % hotstart
    ncid = netcdf.open(settings.SourceFilename,'NOWRITE');
    time = netcdf.getVar(ncid,0);
    t = getIndex(settings.date,time) - 1; % NETCDF index starts at 0
    
    p.np = fileInfo.Dimensions(1).Length;
    p.id = netcdf.getVar(ncid,3);
    p.lon = netcdf.getVar(ncid,1,[t,0], [1,p.np]);
    p.lat = netcdf.getVar(ncid,2,[t,0], [1,p.np]);
    p.z = netcdf.getVar(ncid, 6, [t,0], [1,p.np]);
    p.releaseDate = netcdf.getVar(ncid,4);
    p.UNSD = netcdf.getVar(ncid,5);
    
    netcdf.close(ncid)
    
else % source file
    ncid = netcdf.open(settings.SourceFilename,'NOWRITE');

    p.id  = netcdf.getVar(ncid,0)';
    p.lon = netcdf.getVar(ncid,1)';
    p.lat = netcdf.getVar(ncid,2)';
    p.z = netcdf.getVar(ncid, 5)';
    p.releaseDate = netcdf.getVar(ncid,3)';
    p.UNSD = netcdf.getVar(ncid,4)';

    p.np = length(p.id);

    netcdf.close(ncid)
end

p.LON=zeros( length(settings.outputDateList) ,p.np);
p.LAT=zeros( length(settings.outputDateList) ,p.np);
p.Z=zeros( length(settings.outputDateList) ,p.np);


