function testTrajectory(id)

path='C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\';
drogue=1;
scenario='modelled\100largest_drogue_on\';

traj= shaperead([path 'shp\' num2str(id) '.shp']);

ncid=netcdf.open([path scenario 'parts_drifter_' num2str(id) '.nc'],'NOWRITE');
time=netcdf.getVar(ncid,0);
lon=netcdf.getVar(ncid,1);
lat=netcdf.getVar(ncid,2);
rdate  = netcdf.getVar(ncid,4);
netcdf.close(ncid)

dist = NaN(size(lon));
age  = NaN(size(lon));

for k=1:length(traj)
    if traj(k).drogue==drogue
        for i=1:length(traj(k).X)
            t=find(floor(time)==floor(traj(k).startDate+(i-1)));
            if ~isempty(t)
                for p=1:size(lon,2)
                    [d1km d2km]=lldistkm([traj(k).Y(i) traj(k).X(i)],[lat(t,p) lon(t,p)]);
                    dist(t,p)= d1km;
                    age(t,p) = traj(k).startDate+(i-1) - rdate(p);
                end
            end
        end
    end 
end

dist(age<0)=NaN;
dist_=nanmean(dist);


dx=0.5;
[LON,LAT] = meshgrid(0:dx:360,-90:dx:90);
parts=zeros(size(LON));
for t=1:size(lon,1)
    for p=1:size(lon,2)
        i = round(lat(t,p)/dx) + 90/dx + 1;
        j = round(lon(t,p)/dx) + 1;
        parts(i,j) = parts(i,j) + 1;
    end
end


plotWorld
% contour(LON,LAT,log10(parts),[0 0],'k','linewidth',1)
% contour(LON,LAT,log10(parts),[1 1],'k')


for k=1:size(lon,2)/10
    
    i=find(dist_((k-1)*10+1:k*10)==min(dist_((k-1)*10+1:k*10)));
    plot(lon(:,(k-1)*10+i),lat(:,(k-1)*10+i))
    
end

for k=1:length(traj)
    if traj(k).drogue==drogue
        plot(traj(k).X,traj(k).Y,'.r')
    end
end






