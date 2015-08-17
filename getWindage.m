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
t = getIndex(settings.date,time)-1; % netcdf index starts at 0

u=zeros(1,p.np);
v=zeros(1,p.np);

ncidu = netcdf.open(ufile,'NOWRITE') ;
ncidv = netcdf.open(vfile,'NOWRITE') ;

U   = netcdf.getVar( ncidu , 3 , [0,0,t] , [length(lon),length(lat),1] );
V   = netcdf.getVar( ncidv , 3 , [0,0,t] , [length(lon),length(lat),1] );

netcdf.close(ncidu)
netcdf.close(ncidv)

for k=1:p.np
    u(k) = U(i(k),j(k));
    v(k) = V(i(k),j(k));
end

% current scaling factor in Hycom files
uw = settings.WindageCoeff * u;
vw = settings.WindageCoeff * v;

