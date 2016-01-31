
id=2578;
validationSettings
p = loadParticles( settings );
main(p,settings)

plotWorld
plot(traj(1).X,traj(1).Y,'.k')

ncid=netcdf.open('parts_drifter_2578_1.nc','NOWRITE');
time = netcdf.getVar(ncid,0);
lat  = netcdf.getVar(ncid,2);
lon  = netcdf.getVar(ncid,1);
netcdf.close(ncid)

for k=1:80
plot(lon(:,k),lat(:,k),'r')
end