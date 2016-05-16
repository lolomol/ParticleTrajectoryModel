 
% output: N particle visits per day

clear

% data_path='C:\Users\lolo\Documents\TheOceanCleanup\data\particles\windage 0.5';
data_path='F:\CPD-Macroscale\Lebreton_phase_2\4th_run_scenarios\coastal_releases\current_stokes_wind_0_1';

ascii_file='C:\Users\lolo\Documents\TheOceanCleanup\work\oceanloads\FalkorProposal\coastal_0_1p_AveDailyVisits_1993-2012.ascii';
% mat_file='C:\Users\lolo\Documents\TheOceanCleanup\work\oceanloads\coastal_0_1p_AveDailyVisits_1993-2012.mat';


init_year=1993;
end_year=2012;

release_year=init_year:end_year;
date = datenum(init_year,1,1,0,0,0):datenum(end_year,12,31,0,0,0);

LON=(0:360)';
LAT=(-90:90)';
VISIT=zeros(length(LAT),length(LON));

for y0=init_year:end_year  
    disp(y0)
    r_year = find(release_year==y0);
    
    for y1=y0:end_year
        disp(y1)
        
        ncid=netcdf.open([data_path '\parts_' num2str(y1) '_' num2str(y0) '.nc'],'NOWRITE');
        time=netcdf.getVar(ncid,0);
        lon=netcdf.getVar(ncid,1);
        lat=netcdf.getVar(ncid,2);
        rdate  = netcdf.getVar(ncid,4);
        netcdf.close(ncid)
        np=length(rdate);
        nt=length(time);
        
        for t=1:nt-1 %model outputs go to 1st of jan following year
           for k=1:np 
               if rdate(k)<time(t)
%                    i=getIndex(lat(t,k),LAT);
%                    j=getIndex(lon(t,k),LON);
                   i=round(lat(t,k))+90+1;
                   j=round(lon(t,k))+1;
                   VISIT(i,j)=VISIT(i,j)+1;
               end
           end
        end
    end
end

% Compute area
[Lon,Lat]=meshgrid(LON,LAT);
dx=1;
Area=computeArea(Lat,Lon,dx);

AveDailyVisits=VISIT/length(date); % average per days
AveDailyVisits=AveDailyVisits./Area; % average per km2

figure
imagesc(LON,LAT,log10(AveDailyVisits))
axis xy
caxis([-2 3])

% save(mat_file,'AveDailyVisits')
writeAsciiRaster(ascii_file,LAT,LON,flipud(AveDailyVisits))


