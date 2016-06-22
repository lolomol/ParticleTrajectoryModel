clear

input_path='C:\Users\lolo\Documents\TheOceanCleanup\work\beaching\current-stokes-wind3\time_threshold_28days';
data_path='F:\CPD-Macroscale\Lebreton_phase_2\4th_run_scenarios\coastal_releases\current_stokes_wind_3';
csv_filename='Beaching_coastal_current_stokes_wind_3_28days.csv';

init_year=1993;
end_year=2012;

rdate=[];rlon=[];rlat=[];
bdate=[];blon=[];blat=[];

for y0=init_year:end_year
    
    ncid=netcdf.open([data_path '\parts_' num2str(y0) '_' num2str(y0) '.nc'],'NOWRITE');
    rdate_  = netcdf.getVar(ncid,4);
    lon  = netcdf.getVar(ncid,1);
    lat  = netcdf.getVar(ncid,2);
    netcdf.close(ncid)
    rlon_ = lon(1,:)';
    rlat_ = lat(1,:)';
    
    ncid=netcdf.open([input_path '\bdate_' num2str(y0) '.nc'],'NOWRITE');
    bdate_  = netcdf.getVar(ncid,0);
    blon_  = netcdf.getVar(ncid,1);
    blat_  = netcdf.getVar(ncid,2);
    netcdf.close(ncid)
    
    rdate(end+1:end+length(rdate_))=rdate_;
    rlon (end+1:end+length(rdate_))=rlon_;
    rlat (end+1:end+length(rdate_))=rlat_;
    bdate(end+1:end+length(rdate_))=bdate_;
    blon (end+1:end+length(rdate_))=blon_;
    blat (end+1:end+length(rdate_))=blat_;
    
end

bdate(rdate==0)=[];
blon(rdate==0)=[];
blat(rdate==0)=[];
rlon(rdate==0)=[];
rlat(rdate==0)=[];
rdate(rdate==0)=[];

blon(bdate==0)=NaN;
blat(bdate==0)=NaN;

travel=zeros(size(rdate));
for k=1:length(rdate)
    travel(k)=lldistkm([rlon(k) rlat(k)],[blon(k) blat(k)]);
end
age=bdate-rdate;

dkm=(0:4:40000)';
ddays=(0:1:10000)';
xkm=zeros(length(dkm),1);
xdays=zeros(length(ddays),1);

for i=1:length(dkm);
    xkm(i)=nansum(travel<=dkm(i))/length(travel);
end
xkm(1)=sum(isnan(travel))/length(travel);
for i=1:length(ddays);
    xdays(i)=nansum(age<=ddays(i) & age>0)/length(age);
end
xdays(1)=sum(age<0)/length(age);


dlmwrite([input_path '\' csv_filename],[ddays,xdays,dkm,xkm])