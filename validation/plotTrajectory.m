function plotTrajectory(id)

path='C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\';
drogue=0;
traj= shaperead([path 'shp\' num2str(id) '.shp']);

ncid=netcdf.open([path 'sources_nc\drogue_off\sources_drifter_' num2str(id) '.nc'],'NOWRITE');
time=netcdf.getVar(ncid,0);
lon=netcdf.getVar(ncid,1);
lat=netcdf.getVar(ncid,2);
rdate  = netcdf.getVar(ncid,4);
netcdf.close(ncid)

% plotWorld

for k=1:length(traj)
    if traj(k).drogue==drogue
        plot(traj(k).X,traj(k).Y,'.b')
    end
end

plot(lon,lat,'sk')