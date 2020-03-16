%% Vertical Transport Mechanism
% available transport mechanisms: "biofouling", "fixed_depth", "oscillating"
settings.verticalTransport = "biofouling";

if settings.verticalTransport == "biofouling"
    settings.r_pl = .001;  % m (radius of plastic)
    settings.rho_pl = 920;  % kg m^-3 (density of plastic)
    % specify paths for temp, salinity, chlorophyll
    %% Temperature/Salinity
    if currentYear==2015
    settings.TempSaltPath        = '/Users/dklink/data_science/trashtracker/forcing_data/TS_2015_01_2015_12.nc';
    else
    error('Temperature/Salinity forcing undefined for %d', currentYear);
    end

    %% Surface Chlorophyll-A
    if currentYear==2015
    settings.ChlSurfPath        = '/Users/dklink/data_science/trashtracker/forcing_data/CHL_2015_01_2015_12.nc';
            % download in utils/aqua_chlor/, from NASA aqua-modis
    else
    error('Surface Chlorophyll-A forcing undefined for %d', currentYear);
    end
end

%% Sea Surface Current
if currentYear<=2005
settings.SScurrentPath        = 'G:\hycom\';
else
%settings.SScurrentPath           = 'G:\hycom\';
settings.SScurrentPath           = '../utils/get hycom/nc/';
end
settings.SScurrentTimeOrigin = datenum(2000,12,31,0,0,0);

%% Sea Surface wind
% unused
%{
if currentYear<=2005
settings.WindagePath          = 'G:\gfs\';
else
settings.WindagePath           = 'G:\gfs\';
end
settings.WindageTimeOrigin = datenum(1800,01,01,0,0,0);
%}

%% Stokes drift
% unused except bathymetry

%{
if currentYear<=2007
settings.StokesPath           = 'G:\wavewatch3\CFSR\';
else
settings.StokesPath           = 'G:\wavewatch3\MMAB\';
end
%}
    
%settings.StokesBathyFilename  = 'G:\etopo2\ETOPO2_0.5.nc';
settings.StokesBathyFilename  = '../forcing_data/ETOPO2_0.5.nc';

%{
%settings.StokesTimeOrigin = datenum(2000,12,31,0,0,0);
%}

%% Grid file
if currentYear>2012 % different hycom grid file depending on experiments
    %settings.GridFilename         = 'G:\grid\HYCOM_grid.nc';
    settings.GridFilename         = '../forcing_data/HYCOM_grid.nc';
else
    settings.GridFilename         = 'G:\grid\HYCOM_grid_expt19.nc';
end

%% Particle source file
 
if currentYear == initYear % source file
   %settings.SourceFilename       = ['C:\Users\lolo\Documents\TheOceanCleanup\sources\Aquaculture\sources_nc\parts_source_' num2str(initYear) '.nc'];
   settings.SourceFilename       = ['../forcing_data/parts_source_' num2str(initYear) '_uniform.nc'];
else % hot start
   settings.SourceFilename       = ['G:\particles\parts_' num2str(currentYear-1) '_' num2str(initYear) '.nc'];
end

%% Output File
%settings.OutputFilename       = ['G:\particles\parts_' num2str(currentYear) '_' num2str(initYear) '.nc'];
settings.OutputFilename       = ['../output/parts_' num2str(currentYear) '_' num2str(initYear) '.nc'];
%% Time parameters
settings.initDate       = datenum(currentYear  ,01,01,0,0,0);
%settings.finalDate      = datenum(currentYear+1,01,01,0,0,0);
settings.finalDate      = datenum(currentYear,12,31,0,0,0);
settings.modelTimestep  = datenum(0,0,1,0,0,0)  *24 *3600 ; %in sec, 1 day, coarse
if settings.verticalTransport == "biofouling"
    settings.nestedVerticalTimesteps = 24;  % how many vertical timesteps per modelTimestep
    settings.outputTimestep = datenum(0,0,0,2,0,0);  % save enough resolution to see daily activity
else
    settings.nestedVerticalTimesteps = 1;
    settings.outputTimestep = datenum(0,0,1,0,0,0);
end

%% Forcing constituents paramaters
settings.ForcingCurrent   = true;
settings.ForcingWind      = false;
settings.ForcingWaves     = false;
settings.ForcingDiffusion = true;

%% Model parameters
settings.WindageCoeff     = 0.005; % windage
settings.EddyDiffusivity  = 0.1 ; % m2/s
settings.TimeAdvectDir    = 1   ; % =1 normal, -1 reverse dispersal
if settings.verticalTransport == "fixed_depth"
    settings.fixedDepth = 0;  % controls the depth particles are set to
end

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






