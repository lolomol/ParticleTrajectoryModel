function checkValidation(settings,traj,drogue)

ncid=netcdf.open(settings.OutputFilename,'NOWRITE');
time=netcdf.getVar(ncid,0);
lon=netcdf.getVar(ncid,1);
lat=netcdf.getVar(ncid,2);
rdate  = netcdf.getVar(ncid,4);
netcdf.close(ncid)

plotWorld

% for k=1:size(lon,2)
%    plot(lon(:,k),lat(:,k),'k') 
% end

for k=1:length(traj)
    if traj(k).drogue==drogue
        plot(traj(k).X,traj(k).Y,'.r')
    end
end




dist = NaN(size(lon));
age  = NaN(size(lon));

for k=1:length(traj)
    if traj(k).drogue==drogue
        for i=1:length(traj(k).X)
            t=find(floor(time)==floor(traj(k).startDate+(i-1)));
            for p=1:size(lon,2)
                [d1km d2km]=lldistkm([traj(k).Y(i) traj(k).X(i)],[lat(t,p) lon(t,p)]);
                dist(t,p)= d1km;
                age(t,p) = traj(k).startDate+(i-1) - rdate(p);
            end 
        end
    end
end


age=floor(age);
age_=unique(sort(round(age(:))));
age_(age_<0)=[];
dist_25=zeros(size(age_));
dist_50=zeros(size(age_));
dist_75=zeros(size(age_));

for d=1:length(age_)
    dist_25(d)=quantile(dist(age==age_(d)),0.25);
    dist_50(d)=quantile(dist(age==age_(d)),0.50);
    dist_75(d)=quantile(dist(age==age_(d)),0.75);
end

figure;
plot(age(:),dist(:),'.k','markersize',1)

hold on
plot(age_,dist_25,'r')
plot(age_,dist_50,'r','linewidth',2)
plot(age_,dist_75,'r')

xlim([0 max(age_)])
xlabel('time (days)')
ylabel('distance (km)')