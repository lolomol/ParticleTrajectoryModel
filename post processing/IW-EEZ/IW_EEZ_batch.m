clear

init_year=1993;
end_year=2012;

deltaD=30; %search frequency in days

output_path='F:\CPD-Macroscale\Lebreton_phase_2\4th_run_scenarios\coastal_releases\current_stokes_wind_1';
source_path='C:\Users\lolo\Documents\TheOceanCleanup\sources\Coastal\sources_nc';
% lowbeaching_path='C:\Users\lolo\Documents\TheOceanCleanup\work\beaching\coastal\current\time_threshold_2days';
% highbeaching_path='C:\Users\lolo\Documents\TheOceanCleanup\work\beaching\coastal\current\time_threshold_28days';

modelgrid_file='C:\Users\lolo\Documents\TheOceanCleanup\data\grid\HYCOM_grid_expt19.nc';
compartment_file='C:\Users\lolo\Documents\TheOceanCleanup\github\trashtracker\post processing\IW-EEZ\IW-EEZ.shp';

S=shaperead(compartment_file);

ncid=netcdf.open(modelgrid_file,'NOWRITE');
lonG=netcdf.getVar(ncid,0);
latG=netcdf.getVar(ncid,1);
land=netcdf.getVar(ncid,2);
dxkm=netcdf.getVar(ncid,3);
dykm=netcdf.getVar(ncid,4);
netcdf.close(ncid)

%compute area
lonG=double(lonG*ones(1,length(latG)));      
latG=double(ones(size(lonG,1),1)*latG');
lonG=lonG(:);
latG=latG(:);
land=land(:);
area=double(dxkm(:).*dykm(:));
lonG(lonG>180)=lonG(lonG>180)-360;
lonG(land==1)=[];
latG(land==1)=[];
area(land==1)=[];
for k=1:length(S)
       in=inpolygon(lonG,latG,S(k).X,S(k).Y);
       S(k).Area=sum(area(in)*1e-6);
       if strcmp(S(k).Country,'')
           disp([S(k).Region ': ' num2str(sum(area(in)*1e-6)) ' km2'])
       else
           disp([S(k).Country ': ' num2str(sum(area(in)*1e-6)) ' km2'])
       end
       lonG(in)=[];
       latG(in)=[];
       area(in)=[];
end

%init
for k=1:length(S)
       S(k).totalparts=0;
       S(k).selfparts=0;
       S(k).regionparts=0;
end


for y0=end_year:-1:init_year
        
        age=end_year-y0;
        disp(' ')
        disp(['Computing age ' num2str(age)])
        disp(' ')
        
        %source file
        ncid=netcdf.open([source_path '\parts_source_' num2str(y0) '.nc'],'NOWRITE');
        lonS=netcdf.getVar(ncid,1);
        latS=netcdf.getVar(ncid,2);
        netcdf.close(ncid)
        source=zeros(size(lonS));
        
        %particle output files
        ncid=netcdf.open([output_path '\parts_2012_' num2str(y0) '.nc'],'NOWRITE');
        time=netcdf.getVar(ncid,0);
        lon=netcdf.getVar(ncid,1);
        lat=netcdf.getVar(ncid,2);
        rdate  = netcdf.getVar(ncid,4);
        netcdf.close(ncid)
        
        %search in longitude between -180 & 180
        lonS(lonS>180)=lonS(lonS>180)-360;
        lon(lon>180)=lon(lon>180)-360;
        
        %attribute sources
        for k=1:length(S)
               in=inpolygon(lonS,latS,S(k).X,S(k).Y);
               source(in)=k;
        end

        %filter search dates
        time=time(1:deltaD:end);
        lon=lon(1:deltaD:end,:);
        lat=lat(1:deltaD:end,:); 
        nD=length(time);
        source=double(ones(nD,1)*source');
        
        %get released particles
        time=double(time*ones(1,length(rdate)));      
        rdate=double(ones(nD,1)*rdate');
        released=(time-rdate>0);
        
        %flatten
        lon=lon(:);
        lat=lat(:);
        rdate=rdate(:);
        released=released(:);
        source=source(:);
        
        %remove never released
        lon(rdate==0)=[];
        lat(rdate==0)=[];
        source(rdate==0)=[];
        released(rdate==0)=[];
        rdate(rdate==0)=[];
        
        %remove not released
        lon(~released)=[];
        lat(~released)=[];
        source(~released)=[];
        rdate(~released)=[];
        released(~released)=[];
        
        
        
        % go through polygons
        for k=1:length(S)
               in=inpolygon(lon,lat,S(k).X,S(k).Y);

               S(k).totalparts=S(k).totalparts+sum(in)/nD;
               S(k).selfparts =S(k).selfparts+sum(in & source==k)/nD;
               
               tmp=0;
               for n=1:length(S)
                   if strcmp(S(n).Region,S(k).Region)
                    S(k).regionparts=S(k).regionparts+sum(in & source==n)/nD;
                    tmp=tmp+sum(in & source==n)/nD;
                   end
               end
               
               eval(['S(k).age' num2str(age) '_totalparts=sum(in)/nD;'])
               eval(['S(k).age' num2str(age) '_selfparts=sum(in & source==k)/nD;'])
               eval(['S(k).age' num2str(age) '_regionparts=tmp;'])
               
               
               if strcmp(S(k).Country,'')
                disp([S(k).Region ': ' num2str(round(sum(in)/nD)) '  (self: ' num2str(round(sum(in & source==k)/nD)) ') particles'])
               else
                disp([S(k).Country ': ' num2str(round(sum(in)/nD)) ' (self: ' num2str(round(sum(in & source==k)/nD)) ') particles'])   
               end
               
               lon(in)=[];
               lat(in)=[];
               source(in)=[];
        end

    
end
