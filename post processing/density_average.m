% Author: Bruno Sainte-Rose, the Ocean Cleanup
% Version 1.0
%
% This routine calculates the instantaneous velocities and presence and
% aggregates them to obtain statistics which are then plotted
%
tic
clear all;

path = 'G:\particles\fishing windage 0.5';
%cd /Volumes/TOC_RES_1/CPD-Macroscale/Lebreton_phase_2/4th_run_scenarios/uniform_NASA/

% Computation parameters
%month=1;        % Starting month averaged
%end_month=3;   % Ending month averaged
freq=1;         % Day skipping
xmin_patch=180; % Delimitation of the patch longitudes
xmax_patch=240;
ymin_patch=18;  % Delimitation of the patch latitudes
ymax_patch=45;
delta_xy=0.05;  % Resolution of the grid considered
initial_year=1993;
start_year=2002;
end_year=2012;

% for month=1:1
%     end_month=month+11

% Initialisation of the grid and variables
[LON,LAT] = meshgrid(0:delta_xy:360, -90:delta_xy:90);
part=zeros(size(LON));
vx=zeros(size(LON));
vy=zeros(size(LON));
vmod=zeros(size(LON));


% Initialisation of averages
Count=0;

for u=start_year:end_year
    %Count
    for y=initial_year:u
        %if (y~=1999)
        %for month=1:12
        clear lon
        clear lat
        filename = [path '/parts_' num2str(u) '_' num2str(y) '.nc'];
        %filename =['/Volumes/TOC_RES_1/CPD-Macroscale/Lebreton_phase_2/4th_run_scenarios/uniform_releases/current/UniformSource_' num2str(u) '_' num2str(month) '_' num2str(y) '.nc']
        ncid = netcdf.open(filename,'nowrite');
        lon = netcdf.getVar( ncid, 1);
        lat = netcdf.getVar( ncid, 2);
        netcdf.close(ncid);
        for t=1:freq:size(lon,1)-1%30*(month-1)+1:size(lon,1)-1%freq:end_month*30%;%time
            for p=1:size(lon,2);
                Count=Count+1;
                i=round(lat(t,p)*1/delta_xy)+90*1/delta_xy+1;
                j=round(max(0,lon(t,p))*1/delta_xy)+1;
                part(i,j)=part(i,j)+1;
                vintx=(lon(t+1,p)-lon(t,p))/(24*3600.)*60.*1852.*cos(lat(t,p)*3.1415/180.);
                vinty=(lat(t+1,p)-lat(t,p))/(24*3600.)*60.*1852.;
                vx(i,j)= vx(i,j)+ vintx;
                vy(i,j)= vy(i,j)+ vinty;
                vmod(i,j)=vmod(i,j)+sqrt(vintx*vintx+vinty*vinty);
            end
            %end
            %end
            %toc
            %end
        end
        toc
    end
end
    for i=1:size(part,1)
        for j=1:size(part,2)
            part(i,j)=part(i,j)/Count*268000000/(60*delta_xy.^2*60*1.852*1.852);
            vx(i,j)= vx(i,j)/Count*268000000/(60*delta_xy.^2*60*1.852*1.852);
            vy(i,j)= vy(i,j)/Count*268000000/(60*delta_xy.^2*60*1.852*1.852);
            vmod(i,j)= vmod(i,j)/Count*268000000/(60*delta_xy.^2*60*1.852*1.852);
        end
    end
    
    clear lat;
    clear lon;
    
    % Display of figures
    %figure
    %grid on;
    %pcolor(LON,LAT,part);axis xy; shading flat; colormap jet; caxis ([0 20]); xlim([200 240]); ylim([15 55]); colorbar;
    %title(['Current and stokes drift averages over 10 years for months:' num2str(month) 'to' num2str(end_month)]);
    %pcolor(LON,LAT,log(part)/log(10.));axis xy; shading flat; colormap jet; caxis ([0 1.2]); xlim([0 360]); ylim([-70 70]); colorbar;
    %title('Current only averaged over 10 years - uniform release - particles density');
    %figure
    %grid on;
    %pcolor(LON,LAT,100*sqrt(vx.^2+vy.^2));axis xy; colormap jet; shading flat;caxis([0 100]); xlim([200 240]); ylim([15 55]); colorbar; %xlim([217 227]); ylim([26 34]);
    %title(['Current and stokes drift averages over 10 years for months:' num2str(month) 'to' num2str(end_month)]);
    %pcolor(LON,LAT,100*sqrt(vx.^2+vy.^2));axis xy; colormap jet; shading flat;caxis([0 50]); xlim([0 360]); ylim([-70 70]); colorbar; %xlim([217 227]); ylim([26 34]);
    %title('Current only averaged over 10 years - uniform release - fluxes');
    
    
    %file2name=['/Users/brunosainte-rose_mac1/Desktop/averages_CC_2004_2014_' num2str(month) '_' num2str(end_month) '.mat']
    %save(file2name);
    
    % end
    toc
    
