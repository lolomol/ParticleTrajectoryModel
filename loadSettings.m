
%% Sea Surface Current
settings.SScurrentPath        = 'F:\hycom\';
settings.SScurrentTimeOrigin = datenum(2000,12,31,0,0,0);

%% Sea Surface wind
settings.WindagePath          = 'F:\gfs\';
settings.WindageTimeOrigin = datenum(1800,01,01,0,0,0);

%% Stokes drift
settings.StokesPath           = 'F:\wavewatch3\MMAB\';
settings.StokesBathyFilename  = 'F:\etopo2\ETOPO2_0.5.nc';
settings.StokesTimeOrigin = datenum(2000,12,31,0,0,0);

%% Grid file
if currentYear>2012 % different hycom grid file depending on experiments
    settings.GridFilename         = 'F:\grid\HYCOM_grid.nc';
else
    settings.GridFilename         = 'F:\grid\HYCOM_grid_expt19.nc';
end

%% Particle source file

if currentYear == initYear % source file
    settings.SourceFilename       = ['F:\sources_nc\parts_source_' num2str(initYear) '.nc'];
else % hot start
    settings.SourceFilename       = ['F:\particles\parts_' num2str(currentYear-1) '_' num2str(initYear) '.nc'];
end

%% Output File
settings.OutputFilename       = ['F:\particles\try\parts_' num2str(currentYear) '_' num2str(initYear) '.nc'];

%% Time parameters
settings.initDate       = datenum(currentYear    ,01,01,0,0,0);
settings.finalDate      = datenum(currentYear +1 ,01,01,0,0,0);
settings.modelTimestep  = datenum(0,0,0,12,0,0)  *24 *3600 ; %in sec
settings.outputTimestep = datenum(0,0,0,12,0,0);

%% Forcing constituents paramaters
settings.ForcingCurrent   = true;
settings.ForcingWind      = true;
settings.ForcingWaves     = true;
settings.ForcingDiffusion = true;

%% Model parameters
settings.WindageCoeff   = 0.02; % windage = 1.5%
settings.EddyDiffusivity= 0.1; % m2/s
settings.TimeAdvectDir    = 1; % =1 normal, -1 reverse dispersal



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






