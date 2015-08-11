function writeOutput ( p, settings)

% writeOutput
% -------------
%

filename = [settings.OutputFilename settings.UNSD '.nc'];

ncid = netcdf.open(filename,'WRITE');

K = round(settings.TimeAdvectDir* (settings.outputDate - settings.initDate) / settings.outputTimestep) ;

netcdf.putVar(ncid, 0,  K   ,  1        , settings.outputDate)
netcdf.putVar(ncid, 1, [K,0], [1, p.np] , p.lon)
netcdf.putVar(ncid, 2, [K,0], [1, p.np] , p.lat)

if K==0
    netcdf.putVar(ncid, 3, p.id)
    netcdf.putVar(ncid, 4, p.releaseDate)
end

netcdf.close(ncid)

