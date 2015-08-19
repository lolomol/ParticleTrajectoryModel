dateStart=datenum(2015,01,01,0,0,0);
% dateStart=datenum(1994,02,18,0,0,0);
dateEnd=datenum(2015,08,01,0,0,0);


for date=dateStart:dateEnd
     for hour=0%:6:21
         filename=['./nc/global_' datestr((date+hour/24),'yyyy_mm_dd_HH') '.nc'];
         if exist(filename, 'file')~=2
             
            try
               if date<=datenum(1995,07,31,0,0,0) 
                   url=['http://ncss.hycom.org/thredds/ncss/grid/GLBu0.08/expt_19.0/' datestr(date,'yyyy') '/3hrly?var=water_u&var=water_v&north=80&west=-180&east=179.92&south=-80&horizStride=1&time=' datestr(date,'yyyy-mm-dd') 'T' sprintf('%02d',hour) '%3A00%3A00Z&vertCoord=0&accept=netcdf'];
               elseif date<=datenum(2012,12,31,21,0,0)
                   url=['http://ncss.hycom.org/thredds/ncss/grid/GLBu0.08/expt_19.1/' datestr(date,'yyyy') '/3hrly?var=water_u&var=water_v&north=80&west=-180&east=179.92&south=-80&horizStride=1&time=' datestr(date,'yyyy-mm-dd') 'T' sprintf('%02d',hour) '%3A00%3A00Z&vertCoord=0&accept=netcdf'];
               elseif date<=datenum(2013,08,20,18,0,0)
                   url=['http://ncss.hycom.org/thredds/ncss/grid/GLBu0.08/expt_90.9?var=water_u&var=water_v&north=80&west=0&east=359.92&south=-80&horizStride=1&time=' datestr(date,'yyyy-mm-dd') 'T' sprintf('%02d',hour) '%3A00%3A00Z&vertCoord=0&accept=netcdf'];
               elseif date<=datenum(2014,04,08,18,0,0)
                   url=['http://ncss.hycom.org/thredds/ncss/grid/GLBu0.08/expt_91.0?var=water_u&var=water_v&north=80&west=0&east=359.92&south=-80&horizStride=1&time=' datestr(date,'yyyy-mm-dd') 'T' sprintf('%02d',hour) '%3A00%3A00Z&vertCoord=0&accept=netcdf'];
               else
                   url=['http://ncss.hycom.org/thredds/ncss/grid/GLBu0.08/expt_91.1/uv3z?var=water_u&var=water_v&north=80&west=0&east=359.92&south=-80&horizStride=1&time=' datestr(date,'yyyy-mm-dd') 'T' sprintf('%02d',hour) '%3A00%3A00Z&vertCoord=0&accept=netcdf'];             
               end
                urlwrite(url,filename);
            catch
                disp(['error downloading: ' datestr((date+hour/24),'yyyy_mm_dd_HH')])
                fid=fopen('errorlog.txt','a');
                fprintf(fid,'%f\n',(date+hour/24));
                fclose(fid);
            end
         end
     end
end

