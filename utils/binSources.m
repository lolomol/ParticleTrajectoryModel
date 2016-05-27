function binSources(path,LAT,LON,shapefilepath)

% 
% path='C:\Users\lolo\Documents\TheOceanCleanup\sources\Tsunami\sources_nc';
% LAT=-90:5:90;
% LON=0:5:360;
% shapefilepath='C:\Users\lolo\Documents\TheOceanCleanup\sources\Tsunami\tsunami_source_bin5deg';

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

C=zeros(length(LAT),length(LON));

for k=1:length(x)
    j=getIndex(x(k),LON');
    i=getIndex(y(k),LAT');
    C(i,j)=C(i,j)+1; 
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
            S(k).C=C(i,j);
            S(k).Geometry='Point';
        end
    end
end
shapewrite(S,shapefilepath)

