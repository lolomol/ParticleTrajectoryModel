clear

data_path='F:\CPD-Macroscale\Lebreton_phase_2\4th_run_scenarios\coastal_releases\current_stokes_wind_3';
csv_file='C:\Users\lolo\Documents\TheOceanCleanup\work\arrivalTime\NPG_coastal_current_stokes_3wind.csv';
basins_file='C:\Users\lolo\Documents\TheOceanCleanup\github\trashtracker\utils\basin contours\basins.shp';

S=shaperead(basins_file);

basin=12; % NPG

init_year=1993;
end_year=2012;

arrivalTime=zeros(length(init_year:end_year),21);

for y0=init_year:end_year
    disp(y0)
    for y1=y0:end_year
        
        ncid=netcdf.open([data_path '\parts_' num2str(y1) '_' num2str(y0) '.nc'],'NOWRITE');
        time=netcdf.getVar(ncid,0);
        lon=netcdf.getVar(ncid,1);
        lat=netcdf.getVar(ncid,2);
        rdate  = netcdf.getVar(ncid,4);
        netcdf.close(ncid)
        
        if y1==y0
            reachDate=NaN(size(rdate));
        end
        
        for t=1:length(time)
            %released=(rdate<time(t));
            part_in_360 = inpolygon(lon(t,:),lat(t,:),S(basin).X+360,S(basin).Y);
            part_in     = inpolygon(lon(t,:),lat(t,:),S(basin).X,S(basin).Y);
            reachDate(part_in_360)=nanmin(time(t),reachDate(part_in_360));
            reachDate(part_in)=nanmin(time(t),reachDate(part_in));
        end
        
    end
    
    for age=1:20
       arrivalTime(y0-init_year+1,age)=sum((reachDate-rdate)/365<age & (reachDate-rdate)/365>=age-1)/length(reachDate);
    end
    arrivalTime(y0-init_year+1,21)=sum(isnan(reachDate))/length(reachDate);
    
end

dlmwrite(csv_file,arrivalTime)
