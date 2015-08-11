function createOutputFile ( p, settings)

% createOutputFile
% -------------
%

filename = [settings.OutputFilename settings.UNSD '.nc'];

ncid = netcdf.create(filename,'CLOBBER');

p_dimID = netcdf.defDim(ncid,'x',p.np);

time = settings.initDate : settings.TimeAdvectDir* settings.outputTimestep : settings.finalDate;

time_dimID = netcdf.defDim(ncid,'time',length(time));

netcdf.defVar(ncid,'time','NC_FLOAT', time_dimID );
netcdf.defVar(ncid,'lon','NC_FLOAT', [time_dimID, p_dimID] );
netcdf.defVar(ncid,'lat','NC_FLOAT', [time_dimID, p_dimID] );

netcdf.defVar(ncid,'id','NC_SHORT', p_dimID );
netcdf.defVar(ncid,'releaseDate','NC_FLOAT', p_dimID );

netcdf.endDef(ncid)

netcdf.close(ncid)