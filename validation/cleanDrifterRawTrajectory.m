%id = 19887;
id = 5931;
threshold = 1; % degree
minTrajectoryLength = 30; %days
deltaRelease = 30; %days

path = 'C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\';

load([path  'drifter_' num2str(id) '.mat'])

traj=[];

% remove duplicate time values
[date, m, n] = unique(date); 
lat=lat(m);
lon=lon(m);


% subdivide trajectory with gaps larger than threshold

dist_diff=sqrt((lat(2:end)-lat(1:end-1)).^2+(lon(2:end)-lon(1:end-1)).^2);
index=find(dist_diff>threshold);

if isempty(index)
    traj.lat=lat;
    traj.lon=lon;
    traj.date=date;
else
    traj(1).lat=lat(1:index(1));
    traj(1).lon=lon(1:index(1));
    traj(1).date=date(1:index(1));
    k=1;
    for i=1:length(index)-1
        k=k+1;
        traj(k).lat  = lat(index(i)+1:index(i+1));
        traj(k).lon  = lon(index(i)+1:index(i+1));
        traj(k).date =date(index(i)+1:index(i+1));
    end

    k=k+1;
    i=length(index);
    traj(k).lat  = lat(index(i)+1:end);
    traj(k).lon  = lon(index(i)+1:end);
    traj(k).date =date(index(i)+1:end);
end


% remove trajectories shorter than time threshold (30 days)

for k=length(traj):-1:1
    if (traj(k).date(end)-traj(k).date(1)) < minTrajectoryLength
        traj(k)=[];
    end
end


% interpolate daily position

for k=1:length(traj)
    
%     [date_, m, n] = unique(floor(traj(k).date)); 
    
   traj(k).date_ = traj(k).date(1):traj(k).date(end);
   traj(k).lat_ = interp1(traj(k).date,traj(k).lat,traj(k).date_);
   traj(k).lon_ = interp1(traj(k).date,traj(k).lon,traj(k).date_); 
   
   traj(k).dateRelease =  traj(k).date_(1:deltaRelease:end);
   traj(k).latRelease  =  traj(k).lat_(1:deltaRelease:end);
   traj(k).lonRelease  =  traj(k).lon_(1:deltaRelease:end);
   
end


plot(lon,lat,'k')
for k=1:length(traj)
    plot(traj(k).lon_,traj(k).lat_,'.b')
    plot(traj(k).lon_(1),traj(k).lat_(1),'ob')
    plot(traj(k).lon_(end),traj(k).lat_(end),'sb')
    plot(traj(k).lonRelease,traj(k).latRelease,'.r')
end



