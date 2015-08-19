for y=1992:2007
    for m=1:12
        try
            url=['http://polar.ncep.noaa.gov/waves/nopp-phase1/' sprintf('%d',y) sprintf('%02d',m) '/grib/multi_reanal.glo_30m.hs.' sprintf('%d',y) sprintf('%02d',m) '.grb2.gz'];
            filename=['./CFSR/multi_reanal.glo_30m.hs.' sprintf('%d',y) sprintf('%02d',m) '.grb2.gz'];
            urlwrite(url,filename);
            
            url=['http://polar.ncep.noaa.gov/waves/nopp-phase1/' sprintf('%d',y) sprintf('%02d',m) '/grib/multi_reanal.glo_30m.dp.' sprintf('%d',y) sprintf('%02d',m) '.grb2.gz'];
            filename=['./CFSR/multi_reanal.glo_30m.dp.' sprintf('%d',y) sprintf('%02d',m) '.grb2.gz'];
            urlwrite(url,filename);
            
            url=['http://polar.ncep.noaa.gov/waves/nopp-phase1/' sprintf('%d',y) sprintf('%02d',m) '/grib/multi_reanal.glo_30m.tp.' sprintf('%d',y) sprintf('%02d',m) '.grb2.gz'];
            filename=['./CFSR/multi_reanal.glo_30m.tp.' sprintf('%d',y) sprintf('%02d',m) '.grb2.gz'];
            urlwrite(url,filename);
        catch
            disp(['error at ' sprintf('%d',y) sprintf('%02d',m)])
        end
    end
end