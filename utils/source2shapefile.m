function source2shapefile(path,shapefilepath)

% path='C:\Users\lolo\Documents\TheOceanCleanup\sources\Tsunami\sources_nc';
% shapefilepath='C:\Users\lolo\Documents\TheOceanCleanup\sources\Tsunami\ssunami_source_distrib';

x=[];
y=[];
n=[];
 
for year=2011%1993:2014
     ncid=netcdf.open([path '\parts_source_' num2str(year) '.nc'],'NOWRITE');
     id  = netcdf.getVar(ncid,0)';
     lon = netcdf.getVar(ncid,1)';
     lat = netcdf.getVar(ncid,2)';
     releaseDate = netcdf.getVar(ncid,3)';
     UNSD = netcdf.getVar(ncid,4)';
     np = length(id);
     netcdf.close(ncid);
     
     x(end+1:end+np)=lon;
     y(end+1:end+np)=lat;
     n(end+1)=np;
end
x(x>180)=x(x>180)-360;
S.X=x;
S.Y=y;
S.Geometry='MultiPoint';
shapewrite(S,shapefilepath)
