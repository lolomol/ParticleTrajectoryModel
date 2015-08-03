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

ncidhs = netcdf.open(hsfile,'NOWRITE') ;
    time = netcdf.getVar(ncidhs,0);
    time = datenum(2000,12,31,0,0,0) + time; % hycom time convention
    lon  = netcdf.getVar(ncidhs,1);
    lat  = netcdf.getVar(ncidhs,2);
netcdf.close(ncidhs)

pLon = p.lon;
pLat = p.lat;


if min(lon)<0 % special case if longitude is referenced -180 to 180
    pLon(pLon>=180) = pLon(pLon>=180) - 360;
end

i = getIndex(pLon,lon);
j = getIndex(pLat,lat);
t = getIndex(settings.date,time);

id = getIndex(pLon,settings.bathymetry.lon);
jd = getIndex(pLat,settings.bathymetry.lat);

hs = zeros(1,p.np);
tp = zeros(1,p.np);
dp = zeros(1,p.np);
z  = zeros(1,p.np);

ncidhs = netcdf.open(hsfile,'NOWRITE') ;
ncidtp = netcdf.open(tpfile,'NOWRITE') ;
nciddp = netcdf.open(dpfile,'NOWRITE') ;

for k=1:p.np
    hs(k) = netcdf.getVar( ncidhs , 3 , [i(k),j(k),t] , [1,1,1] );
    tp(k) = netcdf.getVar( ncidtp , 3 , [i(k),j(k),t] , [1,1,1] );
    dp(k) = netcdf.getVar( nciddp , 3 , [i(k),j(k),t] , [1,1,1] );
    z(k) = - settings.bathymetry.d(id(k)+1,jd(k)+1); % depth positive down
end

netcdf.close(ncidhs)
netcdf.close(ncidtp)
netcdf.close(nciddp)

% current scaling factor in Hycom files
hs = hs/1000;
tp = tp/1000;
dp = dp/1000;

% computes Stokes drift
g = 9.81;

Lo = g * tp.^2 / (2*pi); % deepwater wave length

alpha = 4*pi^2 * z./ (g * tp.^2 );

alpha(alpha<0) = NaN; % treat only water cells

L = Lo.* ( tanh( alpha.^(3/4) ) ).^(2/3); % wave length

VelS = 4*pi^2 * ((hs.^2)./ ( L.*tp )); % stokes drift velocity

VelS( isnan(VelS) ) = 0; % stokes drift = 0 on land

us = - VelS.* sin( dp *pi/180);
vs = - VelS.* cos( dp *pi/180);



