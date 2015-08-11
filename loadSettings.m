

settings.SScurrentPath  = 'E:\hycom\';
settings.StokesPath     = 'E:\wavewatch3\CFSR\';
settings.WindagePath    = 'E:\gfs\';
settings.BathyFilename  = 'E:\etopo2\ETOPO2_0.5.nc';
settings.LandFilename   = 'E:\landmass\HYCOM_landmass.nc';

settings.SourceFilename = 'E:\model\sources_nc\parts_source_1995.nc';

settings.OutputFilename = 'E:\particles\parts_1995_1995.nc';

settings.initDate       = datenum(1995,01,01,0,0,0);
settings.finalDate      = datenum(1996,01,01,0,0,0);
settings.modelTimestep  = datenum(0,0,0,6,0,0)  *24 *3600 ; %in sec
settings.outputTimestep = datenum(0,0,0,12,0,0);

settings.WindageCoeff   = 0.01; % windage = 1.5%

settings.EddyDiffusivity= 0.1; % m2/s

settings.ForcingCurrent   = true;
settings.ForcingWind      = true;
settings.ForcingWaves     = true;
settings.ForcingDiffusion = true;

settings.TimeAdvectDir    = 1; % =1 normal, -1 reverse dispersal


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

%%

settings.UNSDlist=[8;12;24;32;36;44;48;50;52;56;70;76;84;90;96;100;104;116;120;124;132;144;152;156;170;174;178;180;188;191;192;196;204;208;214;218;222;226;232;233;242;246;250;258;262;266;268;270;276;288;300;312;316;320;324;328;332;340;344;352;356;360;364;368;372;376;380;384;388;392;400;404;408;410;414;422;428;430;434;440;446;450;458;462;470;474;478;480;484;504;508;512;516;528;530;540;548;554;558;566;578;586;591;598;604;608;616;620;624;626;630;634;638;642;643;682;686;694;702;704;705;706;710;724;736;740;752;760;764;768;780;784;788;792;804;818;826;834;840;858;862;882;887;];


