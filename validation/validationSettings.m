
if drogue
    sourceFolder='drogue_on/';
else
    sourceFolder='drogue_off/';
end

% Sea Surface Current
settings.SScurrentPath        = 'C:\Users\lolo\Documents\TheOceanCleanup\data\hycom\';
settings.SScurrentTimeOrigin = datenum(2000,12,31,0,0,0);

% Sea Surface wind
settings.WindagePath          = 'C:\Users\lolo\Documents\TheOceanCleanup\data\gfs\';
settings.WindageTimeOrigin = datenum(1800,01,01,0,0,0);

% Stokes drift
settings.StokesPath           = 'C:\Users\lolo\Documents\TheOceanCleanup\data\wavewatch3\';
settings.StokesBathyFilename  = 'C:\Users\lolo\Documents\TheOceanCleanup\data\bathymetry\ETOPO2_0.5.nc';
settings.StokesTimeOrigin = datenum(2000,12,31,0,0,0);

% Grid file
settings.GridFilename         = 'C:\Users\lolo\Documents\TheOceanCleanup\data\grid\HYCOM_grid_expt19.nc';

% Particle source file
settings.SourceFilename       = ['C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\sources_nc\' sourceFolder 'sources_drifter_' num2str(id) '.nc'];

% Output File
settings.OutputFilename       = ['C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\modelled\' sourceFolder 'stokes_windage0.1/parts_drifter_' num2str(id) '.nc'];

%% Time parameters
startDate=10e9;
endDate=0;

for k=1:length(traj)
    if traj(k).drogue==drogue;
        startDate=min(traj(k).startDate,startDate);
        endDate=max(traj(k).endDate,endDate);
    end
end

settings.initDate       = startDate;
settings.finalDate      = endDate;
settings.modelTimestep  = datenum(0,0,0,12,0,0)  *24 *3600 ; %in sec
settings.outputTimestep = datenum(0,0,1,0,0,0);

%% Forcing constituents paramaters
settings.ForcingCurrent   = true;
settings.ForcingWind      = true;
settings.ForcingWaves     = true;
settings.ForcingDiffusion = true;

%% Model parameters
settings.WindageCoeff     = 0.001; % windage = 1.5%
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






