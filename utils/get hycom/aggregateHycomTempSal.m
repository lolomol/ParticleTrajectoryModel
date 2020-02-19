%%This script requires NCO.  See nco.sf.net
% if matlab can't find the ncks or ncrcat executables,
% try starting matlab from the terminal, so it has access to your Path.
% alternatively, replace 'ncrcat' and 'ncks' with the full path to those
% executables; you can find this via commands "which ncrcat" or, on
% windows, "where ncrcat"
dateStart=datetime(2015,01,01);
dateEnd=datetime(2015,12,01);

concat_command = 'ncrcat ';
cleanup_command = 'rm';
for date=dateStart:calmonths:dateEnd
    filename=['./nc/TS_' datestr(date,'yyyy_mm') '.nc'];
    unl_filename=['./nc/TS_' datestr(date,'yyyy_mm') '_unl.nc'];
    
    % this thing changes time to an unlimited dimension, which allows for
    % easy concatenation across time
    system(sprintf('ncks -O --mk_rec_dmn time %s %s\n', filename, unl_filename));
    
    % this builds the concatenation command
    concat_command = [concat_command unl_filename ' '];
    
    cleanup_command = [cleanup_command ' ' unl_filename];
end
outfile = ['./nc/TS_' datestr(dateStart, 'yyyy_mm') '_' datestr(dateEnd, 'yyyy_mm') '.nc'];

% this actually runs the concatenation
system([concat_command outfile]);

% get rid of the temp files
system(cleanup_command);