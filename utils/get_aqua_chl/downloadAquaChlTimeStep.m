% This method probably only works on unix, requires wget.  make sure to run
% matlab from the command line so that it has access to your path, so it
% can find echo, chmod, wget, and all that good stuff.

if ~exist('./nc', 'dir')
   mkdir('./nc');
end


dateStart=datetime(2016,01,01);
dateEnd=datetime(2019,12,01);

% set up authentication cookies for download
system('echo "machine urs.earthdata.nasa.gov login dklink password Raglan3225" > ~/.netrc ; > ~/.urs_cookies', '-echo');
system('chmod  0600 ~/.netrc', '-echo');

for date=dateStart:calmonths(1):dateEnd
    filename=['./nc/CHL_' datestr(date,'yyyy_mm') '.nc'];
    if exist(filename, 'file')~=2
        try
            base_url = 'https://oceandata.sci.gsfc.nasa.gov/ob/getfile/';
            startDateStr = sprintf('%04d%03d', year(date), day(date, 'dayofyear'));
            endDateStr = sprintf('%04d%03d', year(date+calmonths(1)-days(1)), day(date+calmonths(1)-days(1), 'dayofyear'));
            dataset = sprintf('A%s%s.L3m_MO_CHL_chlor_a_9km.nc', startDateStr, endDateStr);
            url=[base_url dataset];  
            
            disp(['downloading: ' filename]);
            options = weboptions('Username','dklink','Password','Raglan3225');
            wget_base_command = 'wget --load-cookies ~/.urs_cookies --save-cookies ~/.urs_cookies --auth-no-challenge=on --keep-session-cookies --content-disposition'; 
            system([wget_base_command ' -O ' filename ' ' url], '-echo');
        catch
            disp(['error downloading: ' url])
            disp(['filename: ' filename])
            fid=fopen('errorlog.txt','a');
            fprintf(fid,'%f\n',(datenum(date)/24));
            fclose(fid);
        end
    end
end 