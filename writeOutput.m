function writeOutput ( p, settings)

% writeOutput
% -------------
%


ncid = netcdf.open(settings.OutputFilename,'WRITE');

p_dimID = netcdf.defDim(ncid,'x',p.np);
time_dimID = netcdf.defDim(ncid,'time',length(settings.outputDateList));

netcdf.defVar(ncid,'time','NC_FLOAT', time_dimID );
netcdf.defVar(ncid,'lon','NC_FLOAT', [time_dimID, p_dimID] );
netcdf.defVar(ncid,'lat','NC_FLOAT', [time_dimID, p_dimID] );

netcdf.defVar(ncid,'id','NC_SHORT', p_dimID );
netcdf.defVar(ncid,'releaseDate','NC_FLOAT', p_dimID );
netcdf.defVar(ncid,'unsd','NC_SHORT', p_dimID );

netcdf.endDef(ncid)



netcdf.putVar(ncid, 0, settings.dateOutput)
netcdf.putVar(ncid, 1, LON)
netcdf.putVar(ncid, 2, LAT)
netcdf.putVar(ncid, 3, p.id)
netcdf.putVar(ncid, 4, p.releaseDate)
netcdf.putVar(ncid, 4, p.UNSD)


netcdf.close(ncid)

