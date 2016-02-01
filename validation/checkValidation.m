function checkValidation(settings,traj,drogue)

ncid=netcdf.open(settings.OutputFilename,'NOWRITE');
time=netcdf.getVar(ncid,0);
lon=netcdf.getVar(ncid,1);
lat=netcdf.getVar(ncid,2);
rdate  = netcdf.getVar(ncid,4);
netcdf.close(ncid)

plotWorld

for k=1:size(lon,2)
   plot(lon(:,k),lat(:,k),'k') 
end

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

figure;
plot(age(:),dist(:),'.')



