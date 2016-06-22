clear

data_path='F:\CPD-Macroscale\Lebreton_phase_2\4th_run_scenarios\coastal_releases\current_stokes_wind_3';
output_path='C:\Users\lolo\Documents\TheOceanCleanup\work\beaching\current-stokes-wind3\time_threshold_28days';
gridFilename   = 'C:\Users\lolo\Documents\TheOceanCleanup\data\grid\HYCOM_grid.nc';

time_treshold=28;

init_year=1993;
end_year=2012;

% load grid data
ncid=netcdf.open(gridFilename,'NOWRITE');
LAND_lon = netcdf.getVar(ncid,0);
LAND_lat = netcdf.getVar(ncid,1);
LAND= netcdf.getVar(ncid,2);
netcdf.close(ncid)

for y0=init_year:end_year
    
    for y1=y0:end_year
        
        ncid=netcdf.open([data_path '\parts_' num2str(y1) '_' num2str(y0) '.nc'],'NOWRITE');
        time=netcdf.getVar(ncid,0);
        lon=netcdf.getVar(ncid,1);
        lat=netcdf.getVar(ncid,2);
        rdate  = netcdf.getVar(ncid,4);
        netcdf.close(ncid)
        
        if y1==y0
            bdate=zeros(size(rdate));
            blon=zeros(size(rdate));
            blat=zeros(size(rdate));
            daysCoastal=zeros(size(rdate));
        end
            
        disp(['Release ' num2str(y0) ' - Treating ' num2str(y1)])
        disp([num2str(round(100*sum(bdate~=0)/length(bdate))) ' % Beached'])
        
        for t=1:length(time)
            released=(rdate<time(t));
            for k=1:length(rdate)
                if released(k) && bdate(k)==0;
                    ilon=getIndex(lon(t,k),LAND_lon);
                    ilat=getIndex(lat(t,k),LAND_lat);
                    
                    islon=max(ilon-1,1);
                    islat=max(ilat-1,1);
                    ielon=min(ilon+1,length(LAND_lon));
                    ielat=min(ilat+1,length(LAND_lat));
                    
                    isLAND=LAND(islon:ielon,islat:ielat);
                    isLAND=max(isLAND(:));
                    
                    if isLAND
                        daysCoastal(k)=daysCoastal(k)+1;
                    else
                        daysCoastal(k)=0;
                    end
                    
                    if daysCoastal(k)>time_treshold
                        bdate(k)=time(t);
                        blon(k)=lon(t,k);
                        blat(k)=lat(t,k);
                    end
                end
            end
        end
        
    end  
    
    ncfile=[output_path '\bdate_' num2str(y0) '.nc'];
    ncid = netcdf.create(ncfile,'CLOBBER');
    p_dimID = netcdf.defDim(ncid,'x',length(bdate));
    netcdf.defVar(ncid,'beachingDate','NC_FLOAT', p_dimID );
    netcdf.defVar(ncid,'beachingLon','NC_FLOAT', p_dimID );
    netcdf.defVar(ncid,'beachingLat','NC_FLOAT', p_dimID );
    netcdf.endDef(ncid)    
    netcdf.putVar(ncid, 0, bdate)
    netcdf.putVar(ncid, 1, blon)
    netcdf.putVar(ncid, 2, blat)
    netcdf.close(ncid)
    
end

