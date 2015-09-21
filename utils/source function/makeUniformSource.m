ncid = netcdf.open('HYCOM_grid_expt19.nc','NOWRITE');
lon = netcdf.getVar(ncid,0);
lat = netcdf.getVar(ncid,1);
land = netcdf.getVar(ncid,2);
netcdf.close(ncid)

imagesc(lon,lat,land')
axis xy

pLon = [];
pLat = [];
inc=8;
kk=0; 
for i=1:inc:4500
    for j=1:inc:2001
        if land(i,j)==0
            kk=kk+1;
            pLon(kk) = lon(i);
            pLat(kk) = lat(j);
        end
    end
end

plot(pLon,pLat,'.','markersize',1)

np = length(pLon);

ncfile='UniformSource.nc';
ncid = netcdf.create(ncfile,'CLOBBER');
p_dimID = netcdf.defDim(ncid,'x',np);
netcdf.defVar(ncid,'id','NC_SHORT', p_dimID );
netcdf.defVar(ncid,'lon','NC_FLOAT', p_dimID );
netcdf.defVar(ncid,'lat','NC_FLOAT', p_dimID );
netcdf.defVar(ncid,'releaseDate','NC_FLOAT', p_dimID );
netcdf.defVar(ncid,'UNSD','NC_FLOAT', p_dimID );
netcdf.endDef(ncid)

netcdf.putVar(ncid, 0, int16(1:np))
netcdf.putVar(ncid, 1, pLon)
netcdf.putVar(ncid, 2, pLat)
netcdf.putVar(ncid, 3, pLon*0)
netcdf.putVar(ncid, 4, pLon*0)

netcdf.close(ncid)
