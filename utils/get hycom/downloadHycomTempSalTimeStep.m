if ~exist('./nc', 'dir')
   mkdir('./nc');
end


dateStart=datetime(2015,01,01);
dateEnd=datetime(2016,12,01);

for date=dateStart:calmonths:dateEnd
    hour=0;
    filename=['./nc/TS_' datestr((date+hour/24),'yyyy_mm') '.nc'];
    if exist(filename, 'file')~=2
        try
            if date<=datetime(1995,07,31,0,0,0) 
                error('not implemented');
                url=['http://ncss.hycom.org/thredds/ncss/grid/GLBu0.08/expt_19.0/' datestr(date,'yyyy') '/3hrly?var=water_u&var=water_v&north=80&west=-180&east=179.92&south=-80&horizStride=1&time=' datestr(date,'yyyy-mm-dd') 'T' sprintf('%02d',hour) '%3A00%3A00Z&vertCoord=0&accept=netcdf'];
            elseif date<=datetime(2012,12,31,21,0,0)
                error('not implemented');
                url=['http://ncss.hycom.org/thredds/ncss/grid/GLBu0.08/expt_19.1/' datestr(date,'yyyy') '/3hrly?var=water_u&var=water_v&north=80&west=-180&east=179.92&south=-80&horizStride=1&time=' datestr(date,'yyyy-mm-dd') 'T' sprintf('%02d',hour) '%3A00%3A00Z&vertCoord=0&accept=netcdf'];
            elseif date<=datetime(2013,08,20,18,0,0)
                error('not implemented');
                url=['http://ncss.hycom.org/thredds/ncss/grid/GLBu0.08/expt_90.9?var=water_u&var=water_v&north=80&west=0&east=359.92&south=-80&horizStride=1&time=' datestr(date,'yyyy-mm-dd') 'T' sprintf('%02d',hour) '%3A00%3A00Z&vertCoord=0&accept=netcdf'];
            elseif date<=datetime(2014,04,08,18,0,0)
                error('not implemented');
                url=['http://ncss.hycom.org/thredds/ncss/grid/GLBu0.08/expt_91.0?var=water_u&var=water_v&north=80&west=0&east=359.92&south=-80&horizStride=1&time=' datestr(date,'yyyy-mm-dd') 'T' sprintf('%02d',hour) '%3A00%3A00Z&vertCoord=0&accept=netcdf'];
            else
                url=['http://tds.hycom.org/thredds/ncss/grid/GLBu0.08/expt_91.1/ts3z?var=water_temp&var=salinity&north=80&west=0&east=359.92&south=-80&horizStride=6&time=' datestr(date,'yyyy-mm-dd') 'T' sprintf('%02d',hour) '%3A00%3A00Z&accept=netcdf'];  
            end
            disp(['downloading ' filename ' from url ' url]);
            urlwrite(url,filename);
        catch
            disp(['error downloading: ' datestr((date+hour/24),'yyyy_mm_dd_HH')])
            disp(['url: ' url])
            disp(['filename: ' filename])
            fid=fopen('errorlog.txt','a');
            fprintf(fid,'%f\n',(date+hour/24));
            fclose(fid);
        end
     end
end
 