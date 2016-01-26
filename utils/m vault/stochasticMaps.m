%region=[262,706,404,834,508,710,450,638]; % East Africa
%region=[124,316,630,840,484,84,320,340,558,188,591,44,52,192,214,312,332,388,474,780]; % Central-North America / Caribbean
%region =[36,554,90,242,258,540,548, 598, 882]; % South Pacific
%region=[96,104,360,458,608,626,702,764,116,704]; % South East Asia
%region=156; %China
region=[56,208,246,250,276,352,372,528,578,620,724,752,826]; % Western-North Europe
%region=[24,120,132,178,180,204,226,266,270,288,324,384,430,478,516,566,624,686,694,768,504]; % West Africa

%region=[32,76,152,170,218,328,530,604,740,858,862]; % Latin America

%region=[364,368,414,512,634,682,784,887,50,144,356,462,586]; %Arabic Peninsula - Pakistan -India ..
%region=[408,643,392,410]; % Japan Korea(N&S) Russia

regionName='WestNorthEurope';

dx=0.1;
[LON,LAT] = meshgrid(0:dx:360,-90:dx:90);
C=zeros(size(LON));
A=zeros(size(LON));
B=zeros(size(LON))+99999999999;

for initYear = 2004:2014
    for currentYear = initYear:2014
        disp([num2str(currentYear) '_' num2str(initYear)])
        
        filename = ['F:\particles\windage 0.5\parts_' num2str(currentYear) '_' num2str(initYear) '.nc'];
        ncid = netcdf.open(filename,'NOWRITE');
        time = netcdf.getVar(ncid,0);
        lon  = netcdf.getVar(ncid,1);
        lat  = netcdf.getVar(ncid,2);
        rdate  = netcdf.getVar(ncid,4);
        unsd  = netcdf.getVar(ncid,5);
        netcdf.close(ncid)
        
        nt = length(time);
        np = length(rdate);
        
        
        
        for t = 1 : nt
            for p = 1 : np
                if sum(unsd(p)==region)>0 && rdate(p)<time(t) && rdate(p)>0
                    i = round(lat(t,p)/dx) + 901;
                    j = round(lon(t,p)/dx) + 1;
                    C(i,j) = C(i,j) + 1;
                    A(i,j) = A(i,j) + (time(t)-rdate(p));
                    B(i,j) = min(B(i,j) , (time(t)-rdate(p)));
                end
            end
        end
        
    end
end

save([regionName '_2004_2014.mat'],'A','B','C','LAT','LON')
