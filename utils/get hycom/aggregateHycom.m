% missing: 12-1994
for year=2015%2013:2014;
    for month=1:2

        % time step in hycom database
        dt=datenum(0,0,1,0,0,0);  % 1 day because coarse files
        dateStart = datenum(year,month,01,0,0,0);
        dateEnd   = datenum(year,month+1,1,0,0,0) - dt;
        nt=length(dateStart:dt:dateEnd);

        % load depth & lat & lon
        filename=['./nc/global_3d_coarse_uv_' datestr((dateStart),'yyyy_mm_dd_HH') '.nc'];
        ncid = netcdf.open(filename,'NOWRITE');
        depth = netcdf.getVar(ncid,2);
        lat = netcdf.getVar(ncid,3);
        lon = netcdf.getVar(ncid,4);
        netcdf.close(ncid)
        ndepth = length(depth) ;
        nlat = length(lat) ;
        nlon = length(lon) ;

        %% create raw aggregated U file
        aggregatedFileName=['./nc/u_' num2str(year) '_' num2str(month) '_3d.nc'];
        ncid = netcdf.create(aggregatedFileName,'NETCDF4');

        lat_dimID = netcdf.defDim(ncid,'y',nlat);
        lon_dimID = netcdf.defDim(ncid,'x',nlon);
        depth_dimID = netcdf.defDim(ncid,'z',ndepth);
        time_dimID = netcdf.defDim(ncid,'time',nt);

        netcdf.defVar(ncid,'time','NC_FLOAT',time_dimID);
        netcdf.defVar(ncid,'lon','NC_FLOAT',lon_dimID);
        netcdf.defVar(ncid,'lat','NC_FLOAT',lat_dimID);
        netcdf.defVar(ncid,'depth','NC_FLOAT',depth_dimID);
        netcdf.defVar(ncid,'water_u','NC_SHORT',[lon_dimID,lat_dimID,depth_dimID,time_dimID]);

        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'grid_type','curvilinear');
        netcdf.putAtt(ncid,0,'units','days since 2000-12-31 00:00:00')
        netcdf.putAtt(ncid,4,'scale_factor',0.001)
        netcdf.putAtt(ncid,4,'add_offset',0)
        netcdf.putAtt(ncid,4,'missing_value',-30000)
        netcdf.putAtt(ncid,4,'units','m/s')

        netcdf.endDef(ncid)
        netcdf.putVar(ncid,1,lon)
        netcdf.putVar(ncid,2,lat)
        netcdf.putVar(ncid,3,depth);
        netcdf.close(ncid)

        k=0;
        for date=dateStart:dateEnd
            disp(['u: ' datestr(date)])
            for hour=0%:6:21 coarse

                time = date + hour/24 - datenum(2000,12,31,0,0,0);
                
%                 
%                 % special case 2015, Reunion Island
%                 
%                 try
%                     filename=['./nc/global_' datestr((date+0/24),'yyyy_mm_dd_HH') '.nc'];
%                     ncid = netcdf.open(filename,'NOWRITE') ;
%                     water_u=netcdf.getVar(ncid,0);
%                     netcdf.close(ncid);
%                 catch
%                     disp(['error at ' datestr(date + 0/24) ' - Duplicating water_u'])
%                 end
                
                try
                    filename=['./nc/global_3d_coarse_uv_' datestr((date+hour/24),'yyyy_mm_dd_HH') '.nc'];
                    ncid = netcdf.open(filename,'NOWRITE') ;
                    water_u=netcdf.getVar(ncid,0);
                    netcdf.close(ncid);
                catch
                    disp(['error at ' datestr(date + hour/24) ' - Duplicating water_u'])
                end
                    

                ncid = netcdf.open(aggregatedFileName,'WRITE');
                netcdf.putVar(ncid,0, k , 1 , single(time))
                netcdf.putVar(ncid,4, [0 0 0 k] , [nlon nlat ndepth 1] ,water_u)
                netcdf.close(ncid)

                k=k+1;

            end
        end

        %% create raw aggregated V file
        aggregatedFileName=['./nc/v_' num2str(year) '_' num2str(month) '_3d.nc'];
        ncid = netcdf.create(aggregatedFileName,'NETCDF4');

        lat_dimID = netcdf.defDim(ncid,'y',nlat);
        lon_dimID = netcdf.defDim(ncid,'x',nlon);
        depth_dimID = netcdf.defDim(ncid,'z',ndepth);
        time_dimID = netcdf.defDim(ncid,'time',nt);

        netcdf.defVar(ncid,'time','NC_FLOAT',time_dimID);
        netcdf.defVar(ncid,'lon','NC_FLOAT',lon_dimID);
        netcdf.defVar(ncid,'lat','NC_FLOAT',lat_dimID);
        netcdf.defVar(ncid,'depth','NC_FLOAT',depth_dimID);
        netcdf.defVar(ncid,'water_v','NC_SHORT',[lon_dimID,lat_dimID,depth_dimID,time_dimID]);

        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'grid_type','curvilinear');
        netcdf.putAtt(ncid,0,'units','days since 2000-12-31 00:00:00')
        netcdf.putAtt(ncid,4,'scale_factor',0.001)
        netcdf.putAtt(ncid,4,'add_offset',0)
        netcdf.putAtt(ncid,4,'missing_value',-30000)
        netcdf.putAtt(ncid,4,'units','m/s')
        netcdf.endDef(ncid)
        netcdf.putVar(ncid,1,lon)
        netcdf.putVar(ncid,2,lat)
        netcdf.putVar(ncid,3,depth)
        netcdf.close(ncid)

        k=0;
        for date=dateStart:dateEnd
            disp(['v: ' datestr(date)])
            for hour=0%:6:21 coarse

                time = date + hour/24 - datenum(2000,12,31,0,0,0);
                
%                 % special case 2015, Reunion Island
%                 
%                 try
%                     filename=['./nc/global_' datestr((date+0/24),'yyyy_mm_dd_HH') '.nc'];
%                     ncid = netcdf.open(filename,'NOWRITE') ;
%                     water_v=netcdf.getVar(ncid,5);
%                     netcdf.close(ncid);
%                 catch
%                     disp(['error at ' datestr(date + 0/24) ' - Duplicating water_v'])
%                 end
                
                try
                    filename=['./nc/global_3d_coarse_uv_' datestr((date+hour/24),'yyyy_mm_dd_HH') '.nc'];
                    ncid = netcdf.open(filename,'NOWRITE') ;
                    water_v=netcdf.getVar(ncid,5);
                    netcdf.close(ncid);
                catch
                    disp(['error at ' datestr(date + hour/24) ' - Duplicating water_v'])
                end

                ncid = netcdf.open(aggregatedFileName,'WRITE');
                netcdf.putVar(ncid,0, k , 1 , single(time))
                netcdf.putVar(ncid,4, [0 0 0 k] , [nlon nlat ndepth 1] ,water_v)
                netcdf.close(ncid)

                k=k+1;

            end
        end
        
    end
end

