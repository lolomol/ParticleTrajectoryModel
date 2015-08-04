

settings.SScurrentPath  = 'E:\hycom\';
settings.StokesPath     = 'E:\wavewatch3\CFSR\';
settings.WindagePath    = 'E:\gfs\';
settings.BathyFilename  = 'E:\etopo2\ETOPO2_0.5.nc';
settings.LandFilename   = 'E:\landmass\HYCOM_landmass.nc';

settings.SourceFilename = 'E:\model\sources_nc\parts_source_2000_156.nc';

settings.OutputFilename = 'E:\particles\try\China_2000.nc';

settings.initDate       = datenum(2000,01,01,0,0,0);
settings.finalDate      = datenum(2001,01,01,0,0,0);
settings.modelTimestep  = datenum(0,0,0,6,0,0)  *24 *3600 ; %in sec
settings.outputTimestep = datenum(0,0,0,12,0,0);

settings.WindageCoeff   = 0.03; % windage = 3%

settings.EddyDiffusivity= 0.1; % m2/s

%%

ncid=netcdf.open(settings.BathyFilename,'NOWRITE');
    settings.bathymetry.lon = netcdf.getVar(ncid,0);
    settings.bathymetry.lat = netcdf.getVar(ncid,1);
    settings.bathymetry.d   = netcdf.getVar(ncid,2);
netcdf.close(ncid)

ncid=netcdf.open(settings.LandFilename,'NOWRITE');
    settings.landmass.lon = netcdf.getVar(ncid,0);
    settings.landmass.lat = netcdf.getVar(ncid,1);
    settings.landmass.data= netcdf.getVar(ncid,2);
netcdf.close(ncid)

settings.date = settings.initDate;
settings.outputDate = settings.initDate;


