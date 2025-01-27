settings.SScurrentPath        = 'E:\demo\';
settings.StokesPath           = 'E:\demo\';
settings.WindagePath          = 'E:\demo\';

settings.StokesBathyFilename  = 'E:\demo\ETOPO2_0.5.nc';
settings.GridFilename         = 'E:\demo\demoGrid.nc';
settings.SourceFilename       = 'E:\demo\parts_source_demo.nc';
settings.OutputFilename       = 'E:\demo\outputDemo.nc';

settings.initDate       = datenum(2000,01,01,0,0,0);
settings.finalDate      = datenum(2000,01,31,0,0,0);
settings.modelTimestep  = datenum(0,0,0,6,0,0)  *24 *3600 ; %in sec
settings.outputTimestep = datenum(0,0,0,12,0,0);

settings.ForcingCurrent   = true;
settings.ForcingWind      = true;
settings.ForcingWaves     = true;
settings.ForcingDiffusion = true;

settings.WindageCoeff     = 0.01; % windage = 1%
settings.EddyDiffusivity  = 0.1 ; % m2/s
settings.TimeAdvectDir    = 1   ; % =1 normal, -1 reverse dispersal



%% NO EDIT PAST THIS POINT --------------------------------------------------------------------------------------------------------------------

% create time variables
settings.date = settings.initDate;
settings.outputDate = settings.initDate;
settings.outputDateList = (settings.initDate : settings.TimeAdvectDir* settings.outputTimestep : settings.finalDate)' ;

% load grid data
ncid=netcdf.open(settings.GridFilename,'NOWRITE');
    settings.grid.lon = netcdf.getVar(ncid,0);
    settings.grid.lat = netcdf.getVar(ncid,1);
    settings.grid.land= netcdf.getVar(ncid,2);
    settings.grid.dx  = netcdf.getVar(ncid,3);
    settings.grid.dy  = netcdf.getVar(ncid,4);
netcdf.close(ncid)

% get bathymetry for stokes drift calculation (needs to be the same size
% as wave data)
ncid=netcdf.open(settings.StokesBathyFilename,'NOWRITE');
    settings.bathymetry.lon = netcdf.getVar(ncid,0);
    settings.bathymetry.lat = netcdf.getVar(ncid,1);
    settings.bathymetry.d   = netcdf.getVar(ncid,2);
netcdf.close(ncid)






