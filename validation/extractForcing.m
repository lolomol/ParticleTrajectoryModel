
settings.SScurrentPath  = 'C:\Users\lolo\Documents\TheOceanCleanup\data\hycom\';
settings.SScurrentTimeOrigin = datenum(2000,12,31,0,0,0);
settings.WindagePath           = 'C:\Users\lolo\Documents\TheOceanCleanup\data\gfs\';
settings.WindageTimeOrigin = datenum(1800,01,01,0,0,0);
settings.WindageCoeff     = 0.01; % windage = 1%
settings.StokesPath           = 'C:\Users\lolo\Documents\TheOceanCleanup\data\wavewatch3\';
settings.StokesBathyFilename  = 'C:\Users\lolo\Documents\TheOceanCleanup\data\bathymetry\ETOPO2_0.5.nc';
settings.StokesTimeOrigin = datenum(2000,12,31,0,0,0);


settings.GridFilename         = 'C:\Users\lolo\Documents\TheOceanCleanup\data\grid\HYCOM_grid_expt19.nc';
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

cd('C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\shp\')
files=dir('*.shp');

drogue=0;
Nstations=0;

for f=1:length(files)
    traj= shaperead([files(f).name]);
    
    for k=1:length(traj)
        if traj(k).drogue==drogue
            Nstations=Nstations+length(traj(k).X);
        end
    end
    
end


% init arrays
date=zeros(Nstations,1);
id=zeros(Nstations,1);
ktraj=zeros(Nstations,1);
lat=zeros(Nstations,1);
lon=zeros(Nstations,1);

% populate arrays
ind=0;

for f=1:length(files)
    traj= shaperead([files(f).name]);
    
    for k=1:length(traj)
        if traj(k).drogue==drogue
            for i=1:length(traj(k).X)
                ind=ind+1;
                date(ind) = traj(k).startDate+(i-1);
                lat(ind)  = traj(k).Y(i);
                lon(ind)  = traj(k).X(i);
                id(ind)   = str2num(files(f).name(1:end-4));
                ktraj(ind)= k;
            end
        end
    end
    
end

cd('C:\Users\lolo\Documents\TheOceanCleanup\github\trashtracker\validation\')

% remove everything before 1993
lat(date<datenum(1993,1,1,0,0,0))=[];
lon(date<datenum(1993,1,1,0,0,0))=[];
id(date<datenum(1993,1,1,0,0,0))=[];
ktraj(date<datenum(1993,1,1,0,0,0))=[];
date(date<datenum(1993,1,1,0,0,0))=[];

date_=round(date);

Nstations=length(date);

% retrieve UV model
u = zeros(Nstations,1);
v = zeros(Nstations,1);
uw = zeros(Nstations,1);
vw = zeros(Nstations,1);
us = zeros(Nstations,1);
vs = zeros(Nstations,1);
date_unique=unique(date_);

for t=1:length(date_unique)
    disp(t/length(date_unique))
    ind=find(date_==date_unique(t));
    settings.date=date_unique(t);
    p.np=length(ind);
    p.lon=lon(ind)';
    p.lat=lat(ind)';
    [u(ind),v(ind)]=getSScurrent (p, settings);
    try
        [uw(ind),vw(ind)] = getWindage( p, settings );
    catch
        disp(['no wind data for ' datestr(date_unique(t))])
    end
    try
        [us(ind),vs(ind)] = getStokes( p, settings );
    catch
        disp(['no wave data for ' datestr(date_unique(t))])
    end
end


% retrieve U&V drifter
u_ = zeros(Nstations,1);
v_ = zeros(Nstations,1);

for k=1:Nstations-1
    if id(k)==id(k+1) && ktraj(k) == ktraj(k+1)
        [d1km d2km]=lldistkm([lat(k) lon(k)],[lat(k) lon(k+1)]);
        u_(k)= sign(lon(k+1)-lon(k)) * d1km *1000/(24*3600); % m/s
        [d1km d2km]=lldistkm([lat(k) lon(k)],[lat(k+1) lon(k)]);
        v_(k)= sign(lat(k+1)-lat(k)) * d1km *1000/(24*3600); % m/s
    elseif id(k)== id(k-1) && ktraj(k) == ktraj(k-1)
        [d1km d2km]=lldistkm([lat(k) lon(k)],[lat(k) lon(k-1)]);
        u_(k)= sign(lon(k-1)-lon(k)) * d1km *1000/(24*3600); % m/s
        [d1km d2km]=lldistkm([lat(k) lon(k)],[lat(k-1) lon(k)]);
        v_(k)= sign(lat(k-1)-lat(k)) * d1km *1000/(24*3600); % m/s
    end
end



% [mod,mes]=meshgrid(-5:0.01:5,-5:0.01:5);
% count=zeros(size(mod));
% 
% for k=1:Nstations
%     i=round(u_(k)*100)+500+1;
%     j=round(u(k)*100)+500+1;
%     count(i,j)=count(i,j)+1;
% end





