ncid = netcdf.open('G:\grid\HYCOM_grid.nc','NOWRITE');
land_x = netcdf.getVar(ncid,0);
land_y = netcdf.getVar(ncid,1);
land   = netcdf.getVar(ncid,2);
netcdf.close(ncid)

figure
contour(land_x,land_y,land',[1 1],'k')
axis xy
grid on
drawnow
hold on