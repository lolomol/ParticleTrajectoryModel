%% xls2shp routine
%
% translates trawl dataset into GIS shapefile
%
% adapt pathname below

filename='C:\Users\laure\Desktop\MEdata\TrawlDataset_2.2.xlsx';
shpname='C:\Users\laure\Desktop\MEdata\TrawlDataset_2_2';

%
%
%
%
%% no edit below


typeName={'h_s'
    'l_n'
    'pel'
    'foa'};

%% Import station data
[~, ~, raw] = xlsread(filename,'StationData');
raw = raw(2:end,:);
R = cellfun(@(x) ~isnumeric(x) || isnan(x),raw); % Find non-numeric cells
raw(R) = {0.0}; % Replace non-numeric cells
station = cell2mat(raw);
clearvars raw R;

%% Import samples data
[~, ~, raw] = xlsread(filename,'DebrisData');
raw = raw(2:end,1:7);
raw(cellfun(@(x) ~isempty(x) && isnumeric(x) && isnan(x),raw)) = {''};
R = cellfun(@(x) ~isnumeric(x),raw); % Find non-numeric cells
raw(R) = {NaN}; % Replace non-numeric cells
sample = cell2mat(raw);
clearvars raw R;

%% Populate station attribute
S=[];
for i=1:length(station)
    
    % GIS attribute
    S(i).Geometry='Point';
    S(i).X = (station(i,12)+station(i,14))/2;
    S(i).Y = (station(i,11)+station(i,13))/2;
    
    % station tab attribute
    S(i).stationId        = round(station(i,1));
    S(i).eventId          = round(station(i,2)*10)/10;
    S(i).methodId         = station(i,3);
    S(i).vesselId         = station(i,4);
    S(i).startDay         = station(i,5);
    S(i).startMonth       = station(i,6);
    S(i).startYear        = station(i,7);
    S(i).startTime        = station(i,8);
    S(i).endTime          = station(i,9);
    S(i).towDuration      = station(i,10);
    S(i).startLat         = station(i,11);
    S(i).startLon         = station(i,12);
    S(i).endLat           = station(i,13);
    S(i).endLon           = station(i,14);
    S(i).sampDistance     = station(i,15);
    S(i).sampWidth        = station(i,16);
    S(i).sampDepth        = station(i,17);
    S(i).windSpeed        = station(i,18);
    S(i).seaState         = station(i,19);
    
    % debris data attribute
    area=S(i).sampWidth * S(i).sampDistance;
    cd_all=0;
    wd_all=0;
    for type=1:4
        eval(['cd_' typeName{type} '= 0 ;'])
        eval(['wd_' typeName{type} '= 0 ;'])
    end
    
    
    for size=1:8
        cdi_all=0;
        wdi_all=0;
        for type=1:4
            
            ind = find( sample(:,1) == S(i).eventId & sample(:,3) == size & sample(:,5) == (1+type/10)) ;
            
            if length(ind)>1
                disp(['found duplicate at eventId ' num2str(S(i).eventId) ', size ' num2str(size) ', type ' typeName{type}])
                ind=ind(1);
            end
            
            if ~isempty(ind)
                cd=sample(ind,6) / area;
                wd=sample(ind,7) / area;
                cdi_all = cdi_all + nanmax(cd,0);
                wdi_all = wdi_all + nanmax(wd,0);
                eval(['cd_' typeName{type} '= cd_' typeName{type} '+ cd ;'])
                eval(['wd_' typeName{type} '= wd_' typeName{type} '+ wd ;'])
                eval(['S(i).cd' num2str(size) '_' typeName{type} '= cd ;'])
                eval(['S(i).wd' num2str(size) '_' typeName{type} '= wd ;'])
            else
                eval(['S(i).cd' num2str(size) '_' typeName{type} '= 0 ;'])
                eval(['S(i).wd' num2str(size) '_' typeName{type} '= 0 ;'])
            end
            
        end
        
        eval(['S(i).cd' num2str(size) '_all = cdi_all ;'])
        eval(['S(i).wd' num2str(size) '_all = wdi_all ;'])
        cd_all = cd_all + cdi_all;
        wd_all = wd_all + wdi_all;
    end
    
    S(i).cd_all=cd_all;
    S(i).wd_all=wd_all;
    for type=1:4
        eval(['S(i).cd_' typeName{type} '= cd_' typeName{type} ';'])
        eval(['S(i).wd_' typeName{type} '= wd_' typeName{type} ';'])
    end
end

%% Method exeptions
% replace by -1 when method don't cover a given size class
for i=1:length(station)
    if S(i).methodId>=2 && S(i).methodId<3 % mega trawl no sample below 1.5 cm
        for size=1:3
            for type=1:4
                eval(['S(i).cd' num2str(size) '_' typeName{type} '= -1 ;'])
                eval(['S(i).wd' num2str(size) '_' typeName{type} '= -1 ;'])
            end
            eval(['S(i).cd' num2str(size) '_all = -1 ;'])
            eval(['S(i).wd' num2str(size) '_all = -1 ;'])
        end
    end
end



%% Write output
shapewrite(S,shpname)