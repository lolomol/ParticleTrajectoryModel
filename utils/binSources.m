function binSources(path,LAT,LON,shapefilepath)


% path='C:\Users\lolo\Documents\TheOceanCleanup\sources\Shipping\sources_nc';
% LAT=-90:1:90;
% LON=0:1:360;
% shapefilepath='C:\Users\lolo\Documents\TheOceanCleanup\sources\Shipping\shipping_source_bin60min';

x=[];
y=[];
n=[];
 
for year=1993:2015
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

C=zeros(length(LAT),length(LON));

for k=1:length(x)
    j=getIndex(x(k),LON');
    i=getIndex(y(k),LAT');
    C(i,j)=C(i,j)+1;   
end

k=0;
S=[];

for i=1:length(LAT)
    for j=1:length(LON)
        if C(i,j)~=0
            k=k+1;
            S(k).Y=LAT(i);
            S(k).X=LON(j);
            S(k).C=C(i,j);
            S(k).Geometry='Point';
        end
    end
end
shapewrite(S,shapefilepath)

