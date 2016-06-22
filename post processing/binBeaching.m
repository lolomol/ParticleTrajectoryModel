function binBeaching(path,sourcepath,LAT,LON,shapefilepath)

% 
% path='C:\Users\lolo\Documents\TheOceanCleanup\work\beaching\current\time_threshold_2days';
% sourcepath='C:\Users\lolo\Documents\TheOceanCleanup\sources\Coastal\sources_nc';
% LAT=-90:1:90;
% LON=0:1:360;
% shapefilepath='C:\Users\lolo\Documents\TheOceanCleanup\work\beaching\shp\IO_coastal_current_2days';

x=[];
y=[];
n=[];
xs=[];
ys=[];
ns=[];
 
for year=1993:2012
     ncid=netcdf.open([path '\bdate_' num2str(year) '.nc'],'NOWRITE');
     bdate = netcdf.getVar(ncid,0)';
     lon = netcdf.getVar(ncid,1)';
     lat = netcdf.getVar(ncid,2)';
     netcdf.close(ncid);
     lon(bdate==0)=[];
     lat(bdate==0)=[];
     np = length(lon);
     
     x(end+1:end+np)=lon;
     y(end+1:end+np)=lat;
     n(end+1)=np;
     
     ncid=netcdf.open([sourcepath '\parts_source_' num2str(year) '.nc'],'NOWRITE');
     lon = netcdf.getVar(ncid,1)';
     lat = netcdf.getVar(ncid,2)';
     rdate = netcdf.getVar(ncid,3)';
     netcdf.close(ncid);
     lon(rdate==0)=[];
     lat(rdate==0)=[];
     np = length(lon);
     
     xs(end+1:end+np)=lon;
     ys(end+1:end+np)=lat;
     ns(end+1)=np;
     
end

C=zeros(length(LAT),length(LON));
Cs=zeros(length(LAT),length(LON));

for k=1:length(x)
    j=getIndex(x(k),LON');
    i=getIndex(y(k),LAT');
    C(i,j)=C(i,j)+1; 
%     C(i,j)=C(i,j)+pol(k);  %rivers 
end

for k=1:length(xs)
    j=getIndex(xs(k),LON');
    i=getIndex(ys(k),LAT');
    Cs(i,j)=Cs(i,j)+1; 
%     C(i,j)=C(i,j)+pol(k);  %rivers 
end

k=0;
S=[];

for i=1:length(LAT)
    for j=1:length(LON)
        if C(i,j)~=0
            k=k+1;
            S(k).Y=LAT(i);
            S(k).X=LON(j);
            S(k).C=C(i,j)/(Cs(i,j)+1);
            S(k).Geometry='Point';
        end
    end
end
shapewrite(S,shapefilepath)

