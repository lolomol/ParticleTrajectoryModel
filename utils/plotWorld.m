ncid = netcdf.open('C:\Users\lolo\Documents\TheOceanCleanup\data\grid\HYCOM_grid.nc','NOWRITE');
land_x = netcdf.getVar(ncid,0);
land_y = netcdf.getVar(ncid,1);
land   = netcdf.getVar(ncid,2);
netcdf.close(ncid)
imagesc(land_x,land_y,land')
caxis([0 5])
colormap(flipud(bone))
axis xy
grid on
drawnow
hold on