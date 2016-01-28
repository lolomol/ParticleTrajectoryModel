
path = 'C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\';

basinList=['arc';'atl';'ind';'pac'];
idList=[];

for k=1:4
    basin = basinList(k,:);
    
    
    for year=1993:2012
        
        filename = [ num2str(year) '_r_' basin '.csv'];
        
        fid = fopen([path filename]);
        
        if fid==-1
            disp(['No data for ' basin ' in ' num2str(year)])
            continue
        else
            disp(['Reading ' filename])
        end
        
        Nrows = numel(textread([path filename],'%1c%*[^\n]'));
        
        
        tline='';Nhead=0;
        while isempty(strfind(tline, 'DATA'))
            tline = fgetl(fid);
            Nhead=Nhead+1;
        end
        
        id = zeros(Nrows-Nhead,1);
        
        for i=1:Nrows-Nhead
            tline = fgetl(fid);
            tline = strrep(tline, ' ', '');
            tline = strrep(tline, '/', '');
            tline = strrep(tline, ':', '');
            data = sscanf(tline, '%f,%f,%f,%f,%f,%f');
            id(i)=data(1);
        end
        
        fclose(fid);
        
        idList(end+1:end+length(id))=id;
        idList=unique(idList);
    end
    
end