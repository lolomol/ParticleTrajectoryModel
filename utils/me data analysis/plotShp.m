%% plotShp routine
%
% batch plot of GIS shapefile
%
% adapt pathname below

filename='C:\Users\laure\Desktop\MEdata\TrawlDataset_2_2';
imgpath='./img/';

%
%
%
%
%% no edit below


S=shaperead(filename);

corrected=0;

typeName={'h_s'
          'l_n'
          'pel'
          'foa'};
      
typeNameFull={'hard/sheet'
            'line/net'
            'pellet'
            'foam'};
k=0;

for type=1:4
    for size=1:8
        k=k+1;
        fieldname{k}=['cd' num2str(size) '_' typeName{type}];
        fullname{k}= ['#/km^2 - size ' num2str(size) ' - ' typeNameFull{type}];
        k=k+1;
        fieldname{k}=['wd' num2str(size) '_' typeName{type}];
        fullname{k}= ['g/km^2 - size ' num2str(size) ' - ' typeNameFull{type}];
    end
    k=k+1;
    fieldname{k}=['cd_' typeName{type}];
    fullname{k}= ['#/km^2 - all sizes - ' typeNameFull{type}];
    k=k+1;
    fieldname{k}=['wd_' typeName{type}];
    fullname{k}= ['g/km^2 - all sizes - ' typeNameFull{type}];
end
for size=1:8
    k=k+1;
    fieldname{k}=['cd' num2str(size) '_all'];
    fullname{k}= ['#/km^2 - size ' num2str(size) ' - all types'];
    k=k+1;
    fieldname{k}=['wd' num2str(size) '_all'];
    fullname{k}= ['g/km^2 - size ' num2str(size) ' - all types'];
end
k=k+1;
fieldname{k}='cd_all';
fullname{k}= '#/km^2 - all sizes - all types';
k=k+1;
fieldname{k}='wd_all';
fullname{k}= 'g/km^2 - all sizes - all types';


for f=1:length(fieldname)
    lat=zeros(length(S),1);
    lon=zeros(length(S),1);
    x  =zeros(length(S),1);
    for i=1:length(S)
        lat(i)=S(i).Y;
        lon(i)=S(i).X;
        eval(['x(i)=S(i).' fieldname{f} ';']);
    end
    
    % remove -1 values
    lat(x==-1)=[];
    lon(x==-1)=[];
    x(x==-1)=[];
    
    if ~isempty(x(x~=0))
        minx=min(x(x~=0));
        p25=quantile(x(x~=0),0.25);
        p50=quantile(x(x~=0),0.50);
        p75=quantile(x(x~=0),0.75);
        maxx=max(x(x~=0));
    else
        minx=0;maxx=1;
        p25=0;p50=0;p75=0;
    end
    
    figure
    hold on
    plot([0;lon(x==0)],[0;lat(x==0)],'.','markerSize',2,'color','k')
    plot([0;lon(x>0 & x<=p25)],[0;lat(x>0 & x<=p25)],'o','markerSize',3,'Linewidth',1,'MarkerEdgeColor',[43 131 186]/255)
    plot([0;lon(x>p25 & x<=p50)],[0;lat(x>p25 & x<=p50)],'o','markerSize',6,'Linewidth',1,'MarkerEdgeColor',[116 182 173]/255)
    plot([0;lon(x>p50 & x<=p75)],[0;lat(x>p50 & x<=p75)],'o','markerSize',9,'Linewidth',1,'MarkerEdgeColor',[253 185 110]/255)
    plot([0;lon(x>p75 & x<maxx)],[0;lat(x>p75 & x<maxx)],'o','markerSize',12,'Linewidth',1,'MarkerEdgeColor',[215 25 28]/255)
    plot([0;lon(x==maxx)],[0;lat(x==maxx)],'o','markerSize',12,'Linewidth',2,'MarkerEdgeColor','k')
    
    box on
    axis image
    set(gca,'xlim',[-160 -125],'ylim',[20 45])
    legend('Null',...
        ['> Min (' sprintf('%.2g',minx) ')'],...
        ['> 25p (' sprintf('%.2g',p25) ')'],...
        ['> 50p (' sprintf('%.2g',p50) ')'],...
        ['> 75p (' sprintf('%.2g',p75) ')'],...
        ['= Max (' sprintf('%.2g',maxx) ')'],...
        'Location','NorthEastOutside')
    
    if corrected
        title([fullname{f} ' - vertically corrected'])
    else
        title([fullname{f}])
    end
    
    set(gcf,'position',[782   355   847   420],'color','w')
    
    
    if corrected
        export_fig([imgpath fieldname{f} '_corrected.png'])
    else
        export_fig([imgpath fieldname{f} '.png'])
    end
    close gcf
    
end

