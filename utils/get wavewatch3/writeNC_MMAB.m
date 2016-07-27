
for year=2015:2015
    for month=1:12
        try
            disp([ sprintf('%d',year) ' ' sprintf('%02d',month) ])
            
            hfile=['C:\Users\lolo\Documents\TheOceanCleanup\data\wavewatch3\MMAB\multi_1.glo_30m.hs.' sprintf('%d',year) sprintf('%02d',month)  '.grb2.gz'];
            pfile=['C:\Users\lolo\Documents\TheOceanCleanup\data\wavewatch3\MMAB\multi_1.glo_30m.tp.' sprintf('%d',year) sprintf('%02d',month)  '.grb2.gz'];
            dfile=['C:\Users\lolo\Documents\TheOceanCleanup\data\wavewatch3\MMAB\multi_1.glo_30m.dp.' sprintf('%d',year) sprintf('%02d',month)  '.grb2.gz'];
            
            nch=ncgeodataset(hfile);
            ncp=ncgeodataset(pfile);
            ncd=ncgeodataset(dfile);
            
            h=nch.geovariable('Significant_height_of_combined_wind_waves_and_swell_surface');
            p=ncp.geovariable('Primary_wave_mean_period_surface');
            d=ncd.geovariable('Primary_wave_direction_surface');
            
            g=h.grid_interop(:,:,:);
            
            hdata=zeros(length(g.lon),length(g.lat),length(g.time));
            pdata=zeros(length(g.lon),length(g.lat),length(g.time));
            ddata=zeros(length(g.lon),length(g.lat),length(g.time));
            data=zeros(length(g.lat),length(g.lon),length(g.time));
            for t=1:length(g.time)
                data(:,:,t)=h.data(t,:,:);
                hdata(:,:,t)=data(:,:,t)';
                data(:,:,t)=p.data(t,:,:);
                pdata(:,:,t)=data(:,:,t)';
                data(:,:,t)=d.data(t,:,:);
                ddata(:,:,t)=data(:,:,t)';
            end
            
            hNCfile=['C:\Users\lolo\Documents\TheOceanCleanup\data\wavewatch3\MMAB/hs_' num2str(year) '_' num2str(month) '.nc'];
            pNCfile=['C:\Users\lolo\Documents\TheOceanCleanup\data\wavewatch3\MMAB/tp_' num2str(year) '_' num2str(month) '.nc'];
            dNCfile=['C:\Users\lolo\Documents\TheOceanCleanup\data\wavewatch3\MMAB/dp_' num2str(year) '_' num2str(month) '.nc'];
            
            ncid = netcdf.create(hNCfile,'CLOBBER');
            time_dimID = netcdf.defDim(ncid,'time',length(g.time));
            lat_dimID = netcdf.defDim(ncid,'y',length(g.lat));
            lon_dimID = netcdf.defDim(ncid,'x',length(g.lon));
            netcdf.defVar(ncid,'time','NC_FLOAT',time_dimID);
            netcdf.defVar(ncid,'lon','NC_FLOAT',lon_dimID);
            netcdf.defVar(ncid,'lat','NC_FLOAT',lat_dimID);
            netcdf.defVar(ncid,'hs','NC_SHORT',[lon_dimID,lat_dimID,time_dimID]);
            netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'grid_type','curvilinear');
            netcdf.putAtt(ncid,0,'units','days since 2000-12-31 00:00:00')
            netcdf.putAtt(ncid,3,'scalingFactor','0.001')
            netcdf.endDef(ncid)
            netcdf.putVar(ncid,0,g.time-datenum(2000,12,31,0,0,0))
            netcdf.putVar(ncid,1,g.lon)
            netcdf.putVar(ncid,2,g.lat)
            netcdf.putVar(ncid,3,int16(hdata*100))
            netcdf.close(ncid)
            
            ncid = netcdf.create(pNCfile,'CLOBBER');
            time_dimID = netcdf.defDim(ncid,'time',length(g.time));
            lat_dimID = netcdf.defDim(ncid,'y',length(g.lat));
            lon_dimID = netcdf.defDim(ncid,'x',length(g.lon));
            netcdf.defVar(ncid,'time','NC_FLOAT',time_dimID);
            netcdf.defVar(ncid,'lon','NC_FLOAT',lon_dimID);
            netcdf.defVar(ncid,'lat','NC_FLOAT',lat_dimID);
            netcdf.defVar(ncid,'tp','NC_SHORT',[lon_dimID,lat_dimID,time_dimID]);
            netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'grid_type','curvilinear');
            netcdf.putAtt(ncid,0,'units','days since 2000-12-31 00:00:00')
            netcdf.putAtt(ncid,3,'scalingFactor','0.001')
            netcdf.endDef(ncid)
            netcdf.putVar(ncid,0,g.time-datenum(2000,12,31,0,0,0))
            netcdf.putVar(ncid,1,g.lon)
            netcdf.putVar(ncid,2,g.lat)
            netcdf.putVar(ncid,3,int16(pdata*100))
            netcdf.close(ncid)

            ncid = netcdf.create(dNCfile,'CLOBBER');
            time_dimID = netcdf.defDim(ncid,'time',length(g.time));
            lat_dimID = netcdf.defDim(ncid,'y',length(g.lat));
            lon_dimID = netcdf.defDim(ncid,'x',length(g.lon));
            netcdf.defVar(ncid,'time','NC_FLOAT',time_dimID);
            netcdf.defVar(ncid,'lon','NC_FLOAT',lon_dimID);
            netcdf.defVar(ncid,'lat','NC_FLOAT',lat_dimID);
            netcdf.defVar(ncid,'dp','NC_SHORT',[lon_dimID,lat_dimID,time_dimID]);
            netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'grid_type','curvilinear');
            netcdf.putAtt(ncid,0,'units','days since 2000-12-31 00:00:00')
            netcdf.putAtt(ncid,3,'scalingFactor','0.001')
            netcdf.endDef(ncid)
            netcdf.putVar(ncid,0,g.time-datenum(2000,12,31,0,0,0))
            netcdf.putVar(ncid,1,g.lon)
            netcdf.putVar(ncid,2,g.lat)
            netcdf.putVar(ncid,3,int16(ddata*100))
            netcdf.close(ncid)
            
            
        catch
            disp(['error at ' sprintf('%d',year) ' ' sprintf('%02d',month) ])
        end
    end
end
