
for id=[3275,3276,4440,4639]
%     for id=[2578,2611,2613,2623,2931,3274,3275,3276,4440,4639]

tic
% id=27442;
drogue=1;

% Drifter Trajectory file
traj= shaperead(['C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\shp\' num2str(id) '.shp']);

validationSettings
p = loadParticles( settings );
main(p,settings)
% checkValidation(settings,traj,drogue)

toc

end

% plotWorld
% plot(traj(1).X,traj(1).Y,'.k')
% 
% ncid=netcdf.open('parts_drifter_2578_1.nc','NOWRITE');
% time = netcdf.getVar(ncid,0);
% lat  = netcdf.getVar(ncid,2);
% lon  = netcdf.getVar(ncid,1);
% netcdf.close(ncid)
% 
% for k=1:80
% plot(lon(:,k),lat(:,k),'r')
% end