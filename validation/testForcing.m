
path='C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\';
drogue=1;

settings.SScurrentPath  = 'C:\Users\lolo\Documents\TheOceanCleanup\data\hycom\';
settings.SScurrentTimeOrigin = datenum(2000,12,31,0,0,0);

traj= shaperead([path 'shp\' num2str(id) '.shp']);


% get number of stations
Nstations=0;
for k=1:length(traj)
    if traj(k).drogue==drogue
        Nstations=Nstations+length(traj(k).X);
    end
end
date=zeros(Nstations,1);
lat=zeros(Nstations,1);
lon=zeros(Nstations,1);

% populate date, lat & lon array
ind=0;
for k=1:length(traj)
    if traj(k).drogue==drogue
        for i=1:length(traj(k).X)
            ind=ind+1;
            date(ind) = traj(k).startDate+(i-1);
            lat(ind)  = traj(k).Y(i);
            lon(ind)  = traj(k).X(i);
        end
    end
end

% retrieve U&V model
u = zeros(Nstations,1);
v = zeros(Nstations,1);

for ind=1:Nstations
    disp(ind)
    settings.date=date(ind);
    p.lon=lon(ind);
    p.lat=lat(ind);
    p.np =1;
    [u(ind),v(ind)]=getSScurrent (p, settings);
end

% retrieve U&V drifter
u_ = zeros(Nstations,1);
v_ = zeros(Nstations,1);

for ind=1:Nstations-1
    [d1km d2km]=lldistkm([lat(ind) lon(ind)],[lat(ind) lon(ind+1)]);                    
    u_(ind)= sign(lon(ind+1)-lon(ind)) * d1km *1000/(24*3600); % m/s
    [d1km d2km]=lldistkm([lat(ind) lon(ind)],[lat(ind+1) lon(ind)]);                    
    v_(ind)= sign(lat(ind+1)-lat(ind)) * d1km *1000/(24*3600); % m/s
end


