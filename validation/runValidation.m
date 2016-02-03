tic



for id=[13537,13544,13548,13555,13565,15903,15906,15907,17249,18809,18826,18877,18962,19366,19982,20098,21046,21124,21562,23121,24014,24097,25567,27442,27520,27533,28840,28866,28867,29585,29724,30456,30592,32431,33197,33851,34037,34077,34079,34095,34157,34305,35691,35900,36796,37395,37396,39069,39077,39082,39085,41547,41576,43524,49610,49629,52244,55120,55158,56520,56528,60344,60348,68046,72114,72177,72181,72182,72197,72212,72213,72231,72233,72234,72246,72258,72269,75285,79231,79301,79305,81803,81899,81922,81925,81926,81956,81959,81961,81993,83439,83587,84155,84156,89777,89803,89884,90197,91689,94203]

drogue=1;

% Drifter Trajectory file
traj= shaperead(['C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\shp\' num2str(id) '.shp']);

validationSettings
p = loadParticles( settings );
main(p,settings)
% checkValidation(settings,traj,drogue)



end
toc

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