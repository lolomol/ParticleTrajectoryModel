clear all
close all

load('Eriksen_SEA_coastal_current.mat')
load('Eriksen_SEA_coastal_current_stokes_wind_1.mat')


stationSearchArea=getStationSearchArea;

load('Merged_Eriksen_SEA.mat')

date = data(:,1);
lat  = data(:,2);
lon  = data(:,3);

%% Plot modelled stations density series
figure
plot(log10(density_1./stationSearchArea(:,1)))
hold on
plot(log10(density_2./stationSearchArea(:,2)),'r')
plot(log10(density_3./stationSearchArea(:,3)),'k')


%% Map modelled station density

load('Eriksen_SEA_coastal_current_stokes.mat')

drawWorld
title('Coastal - Sea surface current + stokes')

sizeClass=find(data(:,8)>0); % macro
density  = density_2./stationSearchArea(:,2); %in parts/km2, 0.5 degree search

scatter(lon(sizeClass),lat(sizeClass),10,log10(density(sizeClass)),'filled')
axis image
set(gca,'color',[0.5 0.5 0.5],'xlim',[120 264],'ylim',[0 63])




%% Map measured station density

drawWorld
title('Measured microplastic density')

% sizeClass=find(data(:,8)>0); % macro
% density  = data(:,8); %macro
sizeClass=find(data(:,5)>0); % macro
density  = data(:,5); %macro

scatter(lon(sizeClass),lat(sizeClass),10,log10(density(sizeClass)),'filled')
axis image
set(gca,'color',[0.5 0.5 0.5],'xlim',[120 264],'ylim',[0 63])

