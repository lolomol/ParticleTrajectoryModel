compartment_file='C:\Users\lolo\Documents\TheOceanCleanup\github\trashtracker\post processing\IW-EEZ\IW-EEZ.shp';
output_file='C:\Users\lolo\Documents\TheOceanCleanup\github\trashtracker\post processing\IW-EEZ\IW-EEZ-Area.shp';

modelgrid_file='C:\Users\lolo\Documents\TheOceanCleanup\data\grid\HYCOM_grid_expt19.nc';

S=shaperead(compartment_file);

%get model grid
ncid=netcdf.open(modelgrid_file,'NOWRITE');
lonG=netcdf.getVar(ncid,0);
latG=netcdf.getVar(ncid,1);
land=netcdf.getVar(ncid,2);
dxkm=netcdf.getVar(ncid,3);
dykm=netcdf.getVar(ncid,4);
netcdf.close(ncid)

%compute area
lonG=double(lonG*ones(1,length(latG)));      
latG=double(ones(size(lonG,1),1)*latG');
lonG=lonG(:);
latG=latG(:);
land=land(:);
area=double(dxkm(:).*dykm(:));
lonG(lonG>180)=lonG(lonG>180)-360;
lonG(land==1)=[];
latG(land==1)=[];
area(land==1)=[];
for k=1:length(S)
       in=inpolygon(lonG,latG,S(k).X,S(k).Y);
       S(k).Area=sum(area(in)*1e-6);
       if strcmp(S(k).Country,'')
           disp([S(k).Region ': ' num2str(sum(area(in)*1e-6)) ' km2'])
       else
           disp([S(k).Country ': ' num2str(sum(area(in)*1e-6)) ' km2'])
       end
       lonG(in)=[];
       latG(in)=[];
       area(in)=[];
end

shapewrite(S,output_file)