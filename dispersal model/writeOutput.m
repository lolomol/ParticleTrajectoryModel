function writeOutput ( p, settings)

% writeOutput
% -------------
%

ncid = netcdf.create(settings.OutputFilename,'CLOBBER');

p_dimID = netcdf.defDim(ncid,'x',p.np);
time_dimID = netcdf.defDim(ncid,'time',length(settings.outputDateList));

netcdf.defVar(ncid,'time','NC_FLOAT', time_dimID );
netcdf.defVar(ncid,'lon','NC_FLOAT', [time_dimID, p_dimID] );
netcdf.defVar(ncid,'lat','NC_FLOAT', [time_dimID, p_dimID] );

netcdf.defVar(ncid,'id','NC_SHORT', p_dimID );
netcdf.defVar(ncid,'releaseDate','NC_FLOAT', p_dimID );
netcdf.defVar(ncid,'unsd','NC_SHORT', p_dimID );

netcdf.defVar(ncid,'depth','NC_FLOAT', [time_dimID, p_dimID] );

netcdf.endDef(ncid)

netcdf.putVar(ncid, 0, settings.outputDateList)
netcdf.putVar(ncid, 1, p.LON)
netcdf.putVar(ncid, 2, p.LAT)
netcdf.putVar(ncid, 3, p.id)
netcdf.putVar(ncid, 4, p.releaseDate)
netcdf.putVar(ncid, 5, p.UNSD)
netcdf.putVar(ncid, 6, p.Z)

if settings.verticalTransport == "biofouling"
    netcdf.defVar(ncid,'r_pl','NC_FLOAT', [time_dimID, p_dimID] );
    netcdf.putVar(ncid, 7, p.r_pl)
    netcdf.defVar(ncid,'rho_pl','NC_FLOAT', [time_dimID, p_dimID] );
    netcdf.putVar(ncid, 8, p.rho_pl)
end

netcdf.close(ncid)

