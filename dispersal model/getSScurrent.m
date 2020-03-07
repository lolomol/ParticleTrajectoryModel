function [u,v]=getSScurrent (p, settings)

% getSScurrent
% -------------
%
% reads in nc file of current from p.lon, p.lat and settings.date
% returns u,v vectors of length np of sea surface current

dateVec = datevec(settings.date);
y = dateVec(1);
m = dateVec(2);

ufile = [settings.SScurrentPath 'u_' num2str(y) '_' num2str(m) '_3d.nc'];
vfile = [settings.SScurrentPath 'v_' num2str(y) '_' num2str(m) '_3d.nc'];

% reads in u,v file extent: lat, lon and time
ncidu = netcdf.open(ufile,'NOWRITE') ;
    time = netcdf.getVar(ncidu,0);
    time = settings.SScurrentTimeOrigin + time; % hycom time convention
    lon  = netcdf.getVar(ncidu,1);
    lat  = netcdf.getVar(ncidu,2);
    depth = netcdf.getVar(ncidu,3);
netcdf.close(ncidu)

% particles coordinates
pLon = p.lon;
pLat = p.lat;
pZ = p.z;

% special case if longitude is referenced -180 to 180
if min(lon)<0
    pLon(pLon>=180) = pLon(pLon>=180) - 360;
end

% finds i,j,t indexes for individual particles in current files
i = getIndex(pLon,lon);
j = getIndex(pLat,lat);
z_idx = getIndex(pZ, depth);
t = getIndex(settings.date,time) -1; % netcdf index starts at 0

% look for neighbor cells to compute gradients
is  =mod(i-1-1,length(lon))+1;
ie  =mod(i+1-1,length(lon))+1;
js  =mod(j-1-1,length(lat))+1;
je  =mod(j+1-1,length(lat))+1;
tdt =min(t+1,length(time) -1); % netcdf index starts at 0
if tdt==t; tdt = t-1; end % backward scheme for last time step

% init arrays
uij=zeros(1,p.np);
vij=zeros(1,p.np);
uis=zeros(1,p.np);
vis=zeros(1,p.np);
uie=zeros(1,p.np);
vie=zeros(1,p.np);
ujs=zeros(1,p.np);
vjs=zeros(1,p.np);
uje=zeros(1,p.np);
vje=zeros(1,p.np);
udt=zeros(1,p.np);
vdt=zeros(1,p.np);
dx=zeros(1,p.np);
dy=zeros(1,p.np);

% extract U and V layers from current files at time = t and time = t+dt
ncidu = netcdf.open(ufile,'NOWRITE') ;
ncidv = netcdf.open(vfile,'NOWRITE') ;
U   = netcdf.getVar( ncidu , 4 , [0,0,0,t] , [length(lon),length(lat),length(depth),1] );
V   = netcdf.getVar( ncidv , 4 , [0,0,0,t] , [length(lon),length(lat),length(depth),1] );
Udt = netcdf.getVar( ncidu , 4 , [0,0,0,tdt] , [length(lon),length(lat),length(depth),1] );
Vdt = netcdf.getVar( ncidv , 4 , [0,0,0,tdt] , [length(lon),length(lat),length(depth),1] );
netcdf.close(ncidu)
netcdf.close(ncidv)

% current scaling factor in Hycom files
U = double(U) /1000;
V = double(V) /1000;
Udt = double(Udt) /1000;
Vdt = double(Vdt) /1000;

% eliminate no data values
U ( U==-30 ) = 0;
V ( V==-30 ) = 0;
Udt ( Udt==-30 ) = 0;
Vdt ( Vdt==-30 ) = 0;

% find u,v data for individual particles

for k=1:p.np
    % i,j,t
    uij(k) = U( i(k)  ,j(k) ,z_idx(k));
    vij(k) = V( i(k)  ,j(k) ,z_idx(k));
    % i-1,j,t
    uis(k) = U( is(k) ,j(k) ,z_idx(k));
    vis(k) = V( is(k) ,j(k) ,z_idx(k));
    % i+1,j,t
    uie(k) = U( ie(k) ,j(k) ,z_idx(k));
    vie(k) = V( ie(k) ,j(k) ,z_idx(k));
    % i,j-1,t
    ujs(k) = U( i(k)  ,js(k) ,z_idx(k));
    vjs(k) = V( i(k)  ,js(k) ,z_idx(k));
    % i,j+1,t
    uje(k) = U( i(k)  ,je(k) ,z_idx(k));
    vje(k) = V( i(k)  ,je(k) ,z_idx(k));
    % i,j t+1
    udt(k) = Udt( i(k)  ,j(k) ,z_idx(k));
    vdt(k) = Vdt( i(k)  ,j(k) ,z_idx(k));
    % dx,dy
    dx (k) = settings.grid.dx( i(k)  ,j(k)); % assumes dx and dy are same
    dy (k) = settings.grid.dy( i(k)  ,j(k)); % at every depth level

end


% calculate gradients
ux = (uie - uis) / (2*dx);
uy = (uje - ujs) / (2*dy);
vx = (vie - vis) / (2*dx);
vy = (vje - vjs) / (2*dy);
dt = abs(time(tdt+1)-time(t+1)) * 24 *3600;
ut = (udt - uij) / dt;
vt = (vdt - vij) / dt;

% second order accurate advection scheme
u_ = uij + (dt*ut)/2;
v_ = vij + (dt*vt)/2;

u = ( u_ + ( uy.*v_ - vy.*u_ )*dt/2 ) ./ ( (1-ux*dt/2).*(1-vy*dt/2) - (uy.*vx*dt^2)/4 ) ;
v = ( v_ + ( vx.*u_ - ux.*v_ )*dt/2 ) ./ ( (1-uy*dt/2).*(1-vx*dt/2) - (ux.*vy*dt^2)/4 ) ;

% display warning in case of very high velocities
if max(sqrt(u.^2+v.^2))>10 
    disp('velocities > 10m/s')
end


