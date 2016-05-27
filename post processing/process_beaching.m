clear

input_path='C:\Users\lolo\Documents\TheOceanCleanup\work\beaching\time_threshold_2days';
data_path='F:\CPD-Macroscale\Lebreton_phase_2\4th_run_scenarios\coastal_releases\current';

csv_filename='Beaching_coastal_current_2days.csv';

init_year=1993;
end_year=2012;

% time_bins=[0 1 2 3 4 5 6 7 15 30 60 90 120 150 180 365 365*2 365*3 365*4 365*5 365*10 365*15 365*20]; %in days
time_bins=[0,30,60,90,120,150,180,210,240,270,300,330,360,365*2 365*4 365*6 365*8 365*10 365*12 365*14 365*16 365*18 365*20]; %in days
beachingAge=zeros(length(init_year:end_year),length(time_bins));


for y0=init_year:end_year
    
    ncid=netcdf.open([data_path '\parts_' num2str(y0) '_' num2str(y0) '.nc'],'NOWRITE');
    rdate  = netcdf.getVar(ncid,4);
    netcdf.close(ncid)
    
    ncid=netcdf.open([input_path '\bdate_' num2str(y0) '.nc'],'NOWRITE');
    bdate  = netcdf.getVar(ncid,0);
    blon  = netcdf.getVar(ncid,1);
    blat  = netcdf.getVar(ncid,2);
    netcdf.close(ncid)
    
    bdate(bdate==0)=NaN;
    rdate(rdate==0)=NaN;
    
    n=histc((bdate-rdate),time_bins);
    n=n/length(bdate);
    beachingAge(y0-init_year+1,:)=n';
    
end

dlmwrite([input_path '\' csv_filename],beachingAge)