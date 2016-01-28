
path = 'C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\';

basinList=['arc';'atl';'ind';'pac'];


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
        
        data = zeros(Nrows-Nhead,6);
        
        for i=1:Nrows-Nhead
            tline = fgetl(fid);
            tline = strrep(tline, ' ', '');
            tline = strrep(tline, '/', '');
            tline = strrep(tline, ':', '');
            data_ = sscanf(tline, '%f,%f,%f,%f,%f,%f');
            data(i,:)=data_;
        end
        
        fclose(fid);
        
        save([path  num2str(year) '_r_' basin '.mat'],'data')

    end
    
end