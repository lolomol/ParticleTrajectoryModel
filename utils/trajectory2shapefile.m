data_path='G:\particles\';
S=[];
ind=0;
    
for y0=2000:2010
    ncid=netcdf.open([data_path '\parts_' num2str(y0) '_' num2str(y0) '.nc'],'NOWRITE');
    time=double(netcdf.getVar(ncid,0));
    lon=double(netcdf.getVar(ncid,1));
    lat=double(netcdf.getVar(ncid,2));
    netcdf.close(ncid)

    for k=1:size(lon,2)
        ind=ind+1;
        S(ind).X=lon(:,k);
        S(ind).Y=lat(:,k);
        S(ind).Geometry='Line';
    end
    
    ncid=netcdf.open([data_path '\parts_' num2str(y0-1) '_' num2str(y0) '.nc'],'NOWRITE');
    time=double(netcdf.getVar(ncid,0));
    lon=double(netcdf.getVar(ncid,1));
    lat=double(netcdf.getVar(ncid,2));
    netcdf.close(ncid)

    for k=1:size(lon,2)
        ind=ind+1;
        S(ind).X=lon(:,k);
        S(ind).Y=lat(:,k);
        S(ind).Geometry='Line';
    end
    
   
end

shapewrite(S,'KamiloBackTrack_currentstokeswind0_5.shp')
% shapewrite(S,'KamiloBackTrack_current.shp')




