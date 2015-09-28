function [us,vs]=getStokes (p, settings)

% getStokes
% -------------
%
% reads in nc file of wave hs, tp and dp from p.lon, p.lat and settings.date
% calculates stokes drift
% returns us,vs vectors of length np of stokes drift component

dateVec = datevec(settings.date);
y = dateVec(1);
m = dateVec(2);

hsfile = [settings.StokesPath 'hs_' num2str(y) '_' num2str(m) '.nc'];
tpfile = [settings.StokesPath 'tp_' num2str(y) '_' num2str(m) '.nc'];
dpfile = [settings.StokesPath 'dp_' num2str(y) '_' num2str(m) '.nc'];

% reads in h,t,d file extent: lat, lon and time
ncidhs = netcdf.open(hsfile,'NOWRITE') ;
    time = netcdf.getVar(ncidhs,0);
    time = settings.StokesTimeOrigin + time; % WW3 time convention
    lon  = netcdf.getVar(ncidhs,1);
    lat  = netcdf.getVar(ncidhs,2);
netcdf.close(ncidhs)

% particles coordinates
pLon = p.lon;
pLat = p.lat;

% special case if longitude is referenced -180 to 180
if min(lon)<0 
    pLon(pLon>=180) = pLon(pLon>=180) - 360;
end

% finds i,j,t indexes for individual particles in wave files
i = getIndex(pLon,lon);
j = getIndex(pLat,lat);
t = getIndex(settings.date,time)-1; % netcdf index starts at 0

% finds i,j indexes for individual particles in bathymetry grid
id = getIndex(pLon,settings.bathymetry.lon);
jd = getIndex(pLat,settings.bathymetry.lat);

% init arrays
hs = zeros(1,p.np);
tp = zeros(1,p.np);
dp = zeros(1,p.np);
z  = zeros(1,p.np);

% extract H,T,P layer from wave files at time =t
ncidhs = netcdf.open(hsfile,'NOWRITE') ;
ncidtp = netcdf.open(tpfile,'NOWRITE') ;
nciddp = netcdf.open(dpfile,'NOWRITE') ;
HS   = netcdf.getVar( ncidhs , 3 , [0,0,t] , [length(lon),length(lat),1] );
TP   = netcdf.getVar( ncidtp , 3 , [0,0,t] , [length(lon),length(lat),1] );
DP   = netcdf.getVar( nciddp , 3 , [0,0,t] , [length(lon),length(lat),1] );
netcdf.close(ncidhs)
netcdf.close(ncidtp)
netcdf.close(nciddp)

% scaling factor in Wavedata files
HS=double(HS)/100;
TP=double(TP)/100;
DP=double(DP)/100;

% finds h,t,p,z for individual particles
for k=1:p.np
    hs(k) = HS(i(k),j(k));
    tp(k) = TP(i(k),j(k));
    dp(k) = DP(i(k),j(k));
    z(k) = - settings.bathymetry.d(id(k),jd(k)); % depth positive down
end

% computes Stokes drift
g = 9.81; % gravity

Lo = g * tp.^2 / (2*pi); % deepwater wave length

alpha = 4*pi^2 * z./ (g * tp.^2 );

alpha(alpha<=0) = NaN; % treat only water cells

L = Lo.* ( tanh( alpha.^(3/4) ) ).^(2/3); % wave length

VelS = 0.5*pi^2 * ((hs.^2)./ ( L.*tp )); % stokes drift velocity

VelS(tp==0)=0; % no stokes without wave period

VelS( isnan(VelS) ) = 0; % stokes drift = 0 on land

% project us,vs component from stokes drift amplitude and wave direction
us = - VelS.* sin( dp *pi/180);
vs = - VelS.* cos( dp *pi/180);

