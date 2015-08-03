function [u,v]=getSScurrent (p, settings)

% getSScurrent
% -------------
%
% reads in nc file of current from p.lon, p.lat and settings.date
% returns u,v vectors of length np of sea surface current

dateVec = datevec(settings.date);
y = dateVec(1);
m = dateVec(2);

ufile = [settings.SScurrentPath 'u_' num2str(y) '_' num2str(m) '.nc'];
vfile = [settings.SScurrentPath 'v_' num2str(y) '_' num2str(m) '.nc'];

ncidu = netcdf.open(ufile,'NOWRITE') ;
    time = netcdf.getVar(ncidu,0);
    time = datenum(2000,12,31,0,0,0) + time; % hycom time convention
    lon  = netcdf.getVar(ncidu,1);
    lat  = netcdf.getVar(ncidu,2);
netcdf.close(ncidu)

pLon = p.lon;
pLat = p.lat;


if min(lon)<0 % special case if longitude is referenced -180 to 180
    pLon(pLon>=180) = pLon(pLon>=180) - 360;
end

i = getIndex(pLon,lon);
j = getIndex(pLat,lat);
t = getIndex(settings.date,time);

u=zeros(1,p.np);
v=zeros(1,p.np);

ncidu = netcdf.open(ufile,'NOWRITE') ;
ncidv = netcdf.open(vfile,'NOWRITE') ;

for k=1:p.np
    u(k) = netcdf.getVar( ncidu , 3 , [i(k),j(k),t] , [1,1,1] );
    v(k) = netcdf.getVar( ncidv , 3 , [i(k),j(k),t] , [1,1,1] );
end

netcdf.close(ncidu)
netcdf.close(ncidv)

% current scaling factor in Hycom files
u = u/1000;
v = v/1000;

u ( u==-30 ) = 0;
v ( v==-30 ) = 0;

