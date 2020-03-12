%%This script requires NCO.  See nco.sf.net
% if matlab can't find the ncecat executable,
% try starting matlab from the terminal, so it has access to your Path.
% alternatively, replace 'ncrcat' and 'ncks' with the full path to those
% executables; you can find this via commands "which ncrcat" or, on
% windows, "where ncrcat"
dateStart=datetime(2015,01,01);
dateEnd=datetime(2015,12,01);

%% Concatentaion
% this builds the concatenation command
concat_command = 'ncecat -O -u time ';
for date=dateStart:calmonths:dateEnd
    filename=['./nc/CHL_' datestr(date,'yyyy_mm') '.nc'];
    concat_command = [concat_command filename ' '];    
end
outfile = ['./nc/CHL_' datestr(dateStart, 'yyyy_mm') '_' datestr(dateEnd, 'yyyy_mm') '.nc'];

% this actually runs the concatenation
disp('concatenating...');
system([concat_command outfile]);

% add the time variable, and correct attributes
nccreate(outfile,'time','Dimensions',{'time'},'Datatype', 'double','Format','netcdf4');
time_axis = 24 * (datenum(dateStart:calmonths:dateEnd) - datenum('2000-01-01')); % hours since 2000-01-01
ncwrite(outfile, 'time', time_axis);
ncwriteatt(outfile, 'time', 'units', 'hours since 2000-01-01 00:00:00');
ncwriteatt(outfile, '/', 'time_coverage_start', datestr(dateStart, 'yyyy-mm-dd'));
ncwriteatt(outfile, '/', 'time_coverage_end', datestr(dateEnd+calmonths(1)-days(1), 'yyyy-mm-dd'));

%% Rotate Lat/Lon from (-180 180) to (0 360)
disp('rotating longitudes...');
system(['ncks -O -v chlor_a --msa -d lon,0.,180. -d lon,-180.,-1.0 ' outfile ' ' outfile]);  % rotate data
system(['ncap2 -O -s ''where(lon < 0) lon=lon+360'' ' outfile ' ' outfile]);  % correct longitude values
ncwriteatt(outfile, 'lon', 'valid_min', 0);
ncwriteatt(outfile, 'lon', 'valid_max', 360);
ncwriteatt(outfile, '/', 'westernmost_longitude', 0);
ncwriteatt(outfile, '/', 'easternmost_longitude', 360);
ncwriteatt(outfile, '/', 'geospatial_lon_min', 0);
ncwriteatt(outfile, '/', 'geospatial_lon_max', 360);
