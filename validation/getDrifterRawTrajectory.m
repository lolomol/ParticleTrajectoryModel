% id = 53354;

path = 'C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\';

basinList=['arc';'atl';'ind';'pac'];

date=[]; lat=[]; lon=[];

for k=1:4
    basin = basinList(k,:);
    
    for year=1993:2012
        
        try
            load([path  num2str(year) '_r_' basin '.mat'])
            disp([num2str(year) '_r_' basin '.mat loaded'])
        catch
            disp(['No data for ' basin ' in ' num2str(year)])
        end
        
        id_=data(:,1);
        lat_  = data(id_==id,5);
        lon_  = data(id_==id,6);
        date_ = data(id_==id,4);
        
        lat  = [lat;lat_];
        lon  = [lon;lon_];
        date = [date;date_];
        
    end
    
end

date=datenum(num2str(date),'yyyymmddHHMM');

[date,ind] = sort(date);
lat=lat(ind);
lon=lon(ind);

lon(lon>0)=360-lon(lon>0);
lon(lon<0)=-lon(lon<0);

