load('idList.mat')
for id = 2578%idList(1:1000)

    % keeps only drifter of Cat = 1, 1.5 and 2
    % from lumpkin 2013
    % ftp://ftp.aoml.noaa.gov/phod/pub/lumpkin/droguedetect/
    
    threshold = 1; % degree
    minTrajectoryLength = 30; %days
    deltaRelease = 30; %days
    partsRelease = 10; % 10 releases every deltaRelease
    
    path = 'C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\';
    
    
    load('2013_04_16_drogueoff.mat')
    
    ik=find(ID==id);
    
    if isempty(ik)
        disp('No drogue info, not treated')
    else
        if Cat(ik)> 2
            disp('Cat > 2, not treated')
        else
            
            load([path  'drifter_' num2str(id) '.mat'])
            
            % remove duplicate time values
            [date, m, n] = unique(date);
            lat=lat(m);
            lon=lon(m);
            
            % init trajectories
            traj=[];
            
            
            % subdivide trajectory with gaps larger than threshold
            
            dist_diff=sqrt((lat(2:end)-lat(1:end-1)).^2+(lon(2:end)-lon(1:end-1)).^2);
            index=find(dist_diff>threshold);
            
            if isempty(index)
                traj.lat=lat;
                traj.lon=lon;
                traj.date=date;
            else
                traj(1).lat=lat(1:index(1));
                traj(1).lon=lon(1:index(1));
                traj(1).date=date(1:index(1));
                k=1;
                for i=1:length(index)-1
                    k=k+1;
                    traj(k).lat  = lat(index(i)+1:index(i+1));
                    traj(k).lon  = lon(index(i)+1:index(i+1));
                    traj(k).date =date(index(i)+1:index(i+1));
                end
                
                k=k+1;
                i=length(index);
                traj(k).lat  = lat(index(i)+1:end);
                traj(k).lon  = lon(index(i)+1:end);
                traj(k).date =date(index(i)+1:end);
            end
            
            % check if drogue on or off, subdivide trajectory if Cat not 2 (Drogue
            % on)
            
            Ntraj=length(traj);
            if Cat(ik)~=2
                Doff= Doff_manual(ik) + datenum(1978,12,31,0,0,0);
                for k=1:Ntraj
                    if traj(k).date(end)< Doff
                        traj(k).drogue=1;
                    elseif traj(k).date(1)> Doff
                        traj(k).drogue=0;
                    else
                        icut=find(traj(k).date<Doff,1,'last');
                        traj(Ntraj+1).date=traj(k).date(icut+1:end);
                        traj(Ntraj+1).lon=traj(k).lon(icut+1:end);
                        traj(Ntraj+1).lat=traj(k).lat(icut+1:end);
                        traj(Ntraj+1).drogue=0;
                        traj(k).date(icut+1:end)=[];
                        traj(k).lon(icut+1:end) =[];
                        traj(k).lat(icut+1:end) =[];
                        traj(k).drogue=1;
                    end
                end
            else
                for k=1:Ntraj
                    traj(k).drogue=1;
                end
            end
            
            % remove trajectories shorter than time threshold (30 days)
            Ntraj=length(traj);
            for k=Ntraj:-1:1
                if isempty(traj(k).date)
                    traj(k)=[];
                elseif (traj(k).date(end)-traj(k).date(1)) < minTrajectoryLength
                    traj(k)=[];
                end
            end
            
            
            % interpolate daily position
            Ntraj=length(traj);
            for k=1:Ntraj
                
                %     [date_, m, n] = unique(floor(traj(k).date));
                
                traj(k).idate = (traj(k).date(1):traj(k).date(end))';
                traj(k).ilat = interp1(traj(k).date,traj(k).lat,traj(k).idate);
                traj(k).ilon = interp1(traj(k).date,traj(k).lon,traj(k).idate);
                
                traj(k).rdate =  traj(k).idate(1:deltaRelease:end);
                traj(k).rlat  =  traj(k).ilat(1:deltaRelease:end);
                traj(k).rlon  =  traj(k).ilon(1:deltaRelease:end);
                
            end
            
            % check if there is still a trajectory
            Ntraj=length(traj);
            if Ntraj==0
                disp('No trajectory above minTrajectoryLength')
                continue
            end
            
            % save drifter full trajectory as shapefile
            S=[];
            for k=1:Ntraj
                S(k).X=traj(k).ilon ;
                S(k).Y=traj(k).ilat ;
                S(k).Geometry  = 'MultiPoint' ;
                S(k).drogue    = traj(k).drogue ;
                S(k).startDate = traj(k).idate(1) ;
                S(k).endDate   = traj(k).idate(end) ;
            end
            shapewrite(S,[ path 'shp/' num2str(id)])
            
            % write NETCDF source file for subdivided trajectories
            for k=1:Ntraj
                
                np = length(traj(k).rdate) * partsRelease;
                
                if traj(k).drogue
                    sourceFolder='drogue_on/';
                else
                    sourceFolder='drogue_off/';
                end
                
                ncfile=[ path '/sources_nc/' sourceFolder 'sources_drifter_' num2str(id) '_' num2str(k) '.nc'];
                ncid = netcdf.create(ncfile,'CLOBBER');
                netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'unsd',id);
                p_dimID = netcdf.defDim(ncid,'x',np);
                netcdf.defVar(ncid,'id','NC_SHORT', p_dimID );
                netcdf.defVar(ncid,'lon','NC_FLOAT', p_dimID );
                netcdf.defVar(ncid,'lat','NC_FLOAT', p_dimID );
                netcdf.defVar(ncid,'releaseDate','NC_FLOAT', p_dimID );
                netcdf.defVar(ncid,'UNSD','NC_SHORT', p_dimID );
                netcdf.endDef(ncid)
                
                part_lon  = zeros(np,1);
                part_lat  = zeros(np,1);
                part_unsd = zeros(np,1);
                part_date = zeros(np,1);
                part_id   = zeros(np,1);
                
                for s=1:length(traj(k).rdate)
                    part_lon((s-1)*partsRelease+1: s * partsRelease) = ones(partsRelease,1)*traj(k).rlon(s);
                    part_lat((s-1)*partsRelease+1: s * partsRelease) = ones(partsRelease,1)*traj(k).rlat(s);
                    part_unsd((s-1)*partsRelease+1: s * partsRelease)= ones(partsRelease,1)*s;
                    part_date((s-1)*partsRelease+1: s * partsRelease)= ones(partsRelease,1)*traj(k).rdate(s);
                    part_id((s-1)*partsRelease+1: s * partsRelease)= ((s-1)*partsRelease+1: s * partsRelease)';
                end
                
                netcdf.putVar(ncid, 0, int16(part_id))
                netcdf.putVar(ncid, 1, part_lon)
                netcdf.putVar(ncid, 2, part_lat)
                netcdf.putVar(ncid, 3, part_date)
                netcdf.putVar(ncid, 4, int16(part_unsd))
                
                netcdf.close(ncid)
            end
            
            
            %         plot(lon,lat,'.k','markersize',1)
            %         for k=1:length(traj)
            %             if traj(k).drogue
            %                 plot(traj(k).ilon,traj(k).ilat,'.b')
            %                 plot(traj(k).ilon(1),traj(k).ilat(1),'ob')
            %                 plot(traj(k).ilon(end),traj(k).ilat(end),'sb')
            %                 plot(traj(k).rlon,traj(k).rlat,'.k')
            %             else
            %                 plot(traj(k).ilon,traj(k).ilat,'.r')
            %                 plot(traj(k).ilon(1),traj(k).ilat(1),'or')
            %                 plot(traj(k).ilon(end),traj(k).ilat(end),'sr')
            %                 plot(traj(k).rlon,traj(k).rlat,'.k')
            %             end
            %         end
            
        end
    end
end



