clear

% data_path='C:\Users\lolo\Documents\TheOceanCleanup\data\particles\windage 0.5';
data_path='F:\CPD-Macroscale\Lebreton_phase_2\4th_run_scenarios\coastal_releases\current';

mat_file='C:\Users\lolo\Documents\TheOceanCleanup\work\oceanloads\coastal_nostokes.mat';
csv_file='C:\Users\lolo\Documents\TheOceanCleanup\work\oceanloads\basins_total_coastalnostokes.csv';
basins_file='C:\Users\lolo\Documents\TheOceanCleanup\github\trashtracker\utils\basin contours\basins.shp';

S=shaperead(basins_file);

init_year=1993;
end_year=2012;

release_year=init_year:end_year;
date = datenum(init_year,1,1,0,0,0):datenum(end_year,12,31,0,0,0);
% date = datenum(init_year,1,1,0,0,0):1:datenum(end_year,12,31,0,0,0);
Npart=zeros(13, length(release_year)*12 , length(release_year));

for y0=init_year:end_year
    
    disp(y0)
    r_year = find(release_year==y0);
    
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
            it=12*(y1-init_year)+month;
            
            %looks into individual basin and count particles
            for basin=1:12
                part_in_360 = inpolygon(lon(t,released),lat(t,released),S(basin).X+360,S(basin).Y);
                part_in = inpolygon(lon(t,released),lat(t,released),S(basin).X,S(basin).Y);
                Npart(basin,it,r_year) = sum(part_in) + sum(part_in_360);
                
            end
            %special case for Arctic
            part_in=lat(t,released)>70;
            Npart(13,it,r_year) = sum(part_in);
        end

    end
    
end


Npart_Total=sum(Npart,3);

save(mat_file,'Npart')

dlmwrite(csv_file,Npart_Total)