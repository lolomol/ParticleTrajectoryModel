
ncid = netcdf.open('../grid/HYCOM_grid.nc','NOWRITE');
land_x = netcdf.getVar(ncid,0);
land_y = netcdf.getVar(ncid,1);
land   = netcdf.getVar(ncid,2);
netcdf.close(ncid)
k=0;
for year = 2000:2005
    ncid = netcdf.open(['./try/UniformSource_1pWindage_' num2str(year) '.nc'],'NOWRITE');
    time = netcdf.getVar(ncid,0);
    lon = netcdf.getVar(ncid,1);
    lat = netcdf.getVar(ncid,2);
    rdate = netcdf.getVar(ncid,4);
    netcdf.close(ncid)
    for t=1:4:length(time)
        imagesc(land_x,land_y,land')
        caxis([0 5])
        colormap(bone)
        %     alpha(0.2)
        hold on
        plot(lon(t,:),lat(t,:),'.','markersize',1,'color','w')
        hold off
        set(gcf,'color','k','position',[164   168   721   398])
        set(gca,'color','k','Xcolor','w','Ycolor','w',...
            'TickLength',[0 0])
        axis image
        axis xy
        xlim([0 360])
        ylim([-80 80])
        title(['Uniform Release - Sea Surface Current + 1% Windage: ' datestr(double(time(t)),31)],'color','w')
        grid on
        drawnow
        k=k+1;
        F(k) = getframe(gcf); 
    end
    
end
movie2avi(F, 'UniformRelease_SeaSurfaceCurrent1pwindage_2000-2005.avi')
% 
% 
% time = p(1).time;
% 
% cmap=jet(6);
% for t=1:length(time)
%     imagesc(land_x,land_y,land')
%     caxis([0 5])
%     colormap(bone)
%     hold on
%     for k=1:6
%         plot(p(k).lon(t,p(k).rdate<time(t)),p(k).lat(t,p(k).rdate<time(t)),'.','markersize',1,'color',cmap(k,:))
%     end
%     hold off
%     set(gcf,'color','k','position',[1          41        1366         652])
%     set(gca,'color','k','Xcolor','w','Ycolor','w',...
%         'TickLength',[0 0])
%     axis image
%     axis xy
%     xlim([0 360])
%     ylim([-90 90])
%     
%     grid on
%     drawnow
%     F(t) = getframe(gcf);
% end