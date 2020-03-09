% create particles lat lon, linear whole-world grid
% uses the hycom grid to only put particles on land
initYear=2015;
currentYear=2015;
loadSettings();
horiz_stride = 40;
lat = settings.grid.lat(1:horiz_stride:end);
lon = settings.grid.lon(1:horiz_stride:end);
[LAT, LON] = meshgrid(lat, lon);
land = settings.grid.land(1:horiz_stride:end,1:horiz_stride:end);


part_lat = LAT(land==0)';
part_lon = LON(land==0)';
np = length(part_lat);

% create other particle properties
part_id = 1:1:np;
part_date = datenum(2015, 01, 01)*ones([1, np]);  % all released start of 2015
unsd = zeros(1, np);
depth = zeros(1, np);


ncfile='../forcing_data/parts_source_2015_uniform.nc';

ncid = netcdf.create(ncfile,'CLOBBER');
p_dimID = netcdf.defDim(ncid,'x',np);
netcdf.defVar(ncid,'id','NC_SHORT', p_dimID );
netcdf.defVar(ncid,'lon','NC_FLOAT', p_dimID );
netcdf.defVar(ncid,'lat','NC_FLOAT', p_dimID );
netcdf.defVar(ncid,'releaseDate','NC_FLOAT', p_dimID );
netcdf.defVar(ncid,'unsd','NC_SHORT', p_dimID );
netcdf.defVar(ncid,'depth','NC_FLOAT', p_dimID );
netcdf.endDef(ncid)

netcdf.putVar(ncid, 0, int16(part_id))
netcdf.putVar(ncid, 1, part_lon)
netcdf.putVar(ncid, 2, part_lat)
netcdf.putVar(ncid, 3, part_date)
netcdf.putVar(ncid, 4, unsd);
netcdf.putVar(ncid, 5, depth);

netcdf.close(ncid)