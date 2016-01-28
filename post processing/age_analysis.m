%% Age analysis Routine
%
% outputs .mat files contianing arrays for selected regions of 
% A average age of particles in years per model cell
% B minimum recorded age of particles per model cell
% C total particle count


inputPath  = 'G:\particles\windage 0.1\';
outputPath = 'G:\work\age_analysis\';
outputName = 'regional_age_windage0.1';



%% No edit past this point

regionName={
            'World'
            'NorthAmerica'
            'CentralAmerica'
            'SouthAmerica'
            'SouthernEurope'
            'NorthernEurope'
            'NorthernAfrica'
            'WestAfrica'
            'EastAfrica'
            'ArabicPeninsula'
            'IndianSubcontinent'
            'SoutheastAsia'
            'ChinaRussiaKoreasJapan'
            'AustraliaPacific'
            };
region={
        [] % World
        [124,840] % NorthAmerica
        [316,630,484,84,222,320,340,558,188,591,44,52,192,214,312,332,388,474,780] % CentralAmerica
        [32,76,152,170,218,328,530,604,740,858,862] % SouthAmerica
        [250,724,620,380,705,191,70,8,300,100,642,804] % SouthernEurope
        [826,372,56,528,276,208,578,752,246,233,428,440,616] % NorthernEurope     
        [504,12,788,434,818,376,422,760,792,268] % NorthernAfrica
        [24,120,132,178,180,204,226,266,270,288,324,384,430,478,516,566,624,686,694,768] % WestAfrica
        [262,706,404,834,508,710,450,638,736,232] % EastAfrica
        [364,368,414,512,634,682,784,887] % ArabicPeninsula
        [50,144,356,462,586] % IndiaSubcontinent
        [96,104,360,458,608,626,702,764,116,704] % SoutheastAsia
        [156,408,643,392,410] % ChinaRussiaKoreasJapan
        [36,554,90,242,258,540,548, 598, 882] % AustraliaPacific
        };

dx=0.1;
[LON,LAT] = meshgrid(0:dx:360,-90:dx:90);

regionAnalysis=[];

for k=1:length(regionName)
    C=zeros(size(LON));
    A=zeros(size(LON));
    B=zeros(size(LON))+10e9;

    for initYear = 1993:2014
        disp([regionName{k} ' : ' num2str(initYear)])
        for currentYear = initYear:2014
            
            filename = [ inputPath 'parts_' num2str(currentYear) '_' num2str(initYear) '.nc'];
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
                    if k==1 || (sum(unsd(p)==region{k})>0 && rdate(p)<time(t) && rdate(p)>0)
                        i = round(lat(t,p)/dx) + 90/dx + 1;
                        j = round(lon(t,p)/dx) + 1;
                        C(i,j) = C(i,j) + 1;
                        A(i,j) = A(i,j) + (time(t)-rdate(p));
                        B(i,j) = min(B(i,j) , (time(t)-rdate(p)));
                    end
                end
            end

        end
    end
    
    regionAnalysis(k).Name = regionName{k};
    regionAnalysis(k).A    = A./C;
    regionAnalysis(k).B    = B;
    regionAnalysis(k).C    = C;
    
end



save([outputPath outputName '.mat'],'regionAnalysis')
