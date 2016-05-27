clear
%data_path='F:\CPD-Macroscale\Lebreton_phase_2\4th_run_scenarios\ocean_releases\current_stokes_wind_2\';
data_path='F:\CPD-Macroscale\Lebreton_phase_2\4th_run_scenarios\coastal_releases\current';
bathy_file='C:\Users\lolo\Documents\TheOceanCleanup\data\bathymetry\ETOPO2v2c_f4.nc';
csv_file='C:\Users\lolo\Documents\TheOceanCleanup\work\shelfNOshelf\shelfnoshelf_coastal_nostokes.csv';
init_year=1993;
end_year=2012;
ncid=netcdf.open(bathy_file,'NOWRITE');
x=double(netcdf.getVar(ncid,0));
y=double(netcdf.getVar(ncid,1));
z=double(netcdf.getVar(ncid,2));
netcdf.close(ncid);
x=mod(x,360);
release_year=init_year:end_year;
SnoS=zeros(length(release_year),length(release_year)*12);

for y0=init_year:end_year
    disp(y0)
    for y1=y0:end_year
        ncid=netcdf.open([data_path '\parts_' num2str(y1) '_' num2str(y0) '.nc'],'NOWRITE');
        time=netcdf.getVar(ncid,0);
        lon=netcdf.getVar(ncid,1);
        lat=netcdf.getVar(ncid,2);
        rdate  = netcdf.getVar(ncid,4);
        netcdf.close(ncid)
        for month=1:12
            t=find(time==datenum(y1,month,1,0,0,0));
            released=(rdate<time(t));
            I=getIndex(lon(t,released),x);
            J=getIndex(lat(t,released),y);
            depth=zeros(length(I),1);
            for k=1:length(I)
                depth(k)=z(I(k),J(k));
            end
            SnoS(y0-init_year+1,(y1-init_year)*12+month)=sum(depth>-200)/length(depth);
        end
    end
end

dlmwrite(csv_file,SnoS)