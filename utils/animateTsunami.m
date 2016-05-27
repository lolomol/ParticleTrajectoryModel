data_path='G:\particles';
img_path='C:\Users\lolo\Documents\TheOceanCleanup\work\animation\tsunami\';
windage={'0','0.1','0.5','1','2','3','5'};
cmap=jet(50);
cmap_ind=[1,2,5,10,20,30,50];

for year=2011:2014
    if year==2011
        initMonth=3;
    else
        initMonth=1;
    end
    
    for month=initMonth:12
    plotWorld
    axis image
    ylim([0 65])
    xlim([100 260])
    set(gcf,'position',[54 447 1186 531],'color','w','colormap',flipud(bone))
    caxis([-1 1])
    hold on
    
        for scenario=7:-1:1
            ncid=netcdf.open([data_path '\tsunami windage ' windage{scenario} '\parts_' num2str(year) '_2011.nc'],'NOWRITE');
            time=double(netcdf.getVar(ncid,0));
            t=find(double(time)==datenum(year,month,12,0,0,0));
            lon=double(netcdf.getVar(ncid,1,[t-1,0],[1,100000]));
            lat=double(netcdf.getVar(ncid,2,[t-1,0],[1,100000]));
            netcdf.close(ncid)
            plot(lon,lat,'.','markerSize',1,'color',cmap(cmap_ind(scenario),:))
            
        end
        title(datestr(datenum(year,month,1,0,0,0),'mmm yyyy'))
        drawnow
        export_fig([img_path 'tsunami_' num2str(year) '_' num2str(month) '.png'])
        close all
    end
    
end
        

