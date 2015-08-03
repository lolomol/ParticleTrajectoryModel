function [uw,vw]=getWindage (p, settings)

% getWindage
% -------------
%
% reads in nc file of wind from p.lon, p.lat and settings.date
% returns uw,vw vectors of length np of wind-induced circulation

dateVec = datevec(settings.date);
y = dateVec(1);
m = dateVec(2);

ufile = [settings.WindagePath 'uwnd.sig995.' num2str(y) '.nc'];
vfile = [settings.WindagePath 'vwnd.sig995.' num2str(y) '.nc'];

ncidu = netcdf.open(ufile,'NOWRITE') ;
    time = netcdf.getVar(ncidu,2);
    time = datenum(1800,01,01,0,0,0) + time/24; % hycom time convention
    lon  = netcdf.getVar(ncidu,1);
    lat  = netcdf.getVar(ncidu,0);
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
uw = settings.WindageCoeff * u;
vw = settings.WindageCoeff * v;

