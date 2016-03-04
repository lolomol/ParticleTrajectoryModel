clear all
close all


stationSearchArea=getStationSearchArea;

load('Merged_Eriksen_SEA.mat')

date = data(:,1);
lat  = data(:,2);
lon  = data(:,3);

measuredDensity  = data(:,9);

%% SEA PACIFIC - MICROPLASTIC

scenario={'Eriksen_SEA_coastal_current';
    'Eriksen_SEA_coastal_current_stokes';
    'Eriksen_SEA_coastal_current_stokes_wind_0.1';
    'Eriksen_SEA_coastal_current_stokes_wind_0.5';
    'Eriksen_SEA_coastal_current_stokes_wind_1';
    'Eriksen_SEA_coastal_current_stokes_wind_2'};
cmap=jet(length(scenario));
figure
for s=1:length(scenario)
    
    load([scenario{s} '.mat'])
    modelledDensity  = density_2./stationSearchArea(:,2); %in parts/km2, 0.5 degree search
    
    dataSet=find(data(:,4)==2); % SEA Pacific
    
    massSearch=100:100:10000;
    
    Rsq0=zeros(length(massSearch),1); k=0;
    
    for partMass=massSearch; %in g
        
        k=k+1;
        
        % load modelled vs measure
        X=log10(measuredDensity(dataSet)+1);
        Y=log10(modelledDensity(dataSet)*partMass+1);
        Y(isnan(X))=[];
        X(isnan(X))=[];
        
        %remove 0 values
        X0=X(X>0);
        Y0=Y(X>0);
        X0=X0(Y0>0);
        Y0=Y0(Y0>0);
        
        % linear regression
        %     a0=mean([ones(length(X0),1) X0]./Y0);
        a0=X0\Y0;
        Ycalc0=a0*X0;
        Rsq0(k) = 1-(sum((Y0 - Ycalc0).^2)/sum((Y0 - mean(Y0)).^2));
        
    end
    
    hold on
    plot(massSearch,Rsq0,'color',cmap(s,:),'linewidth',2,'DisplayName',strrep(scenario{s}(20:end),'_',' '))
    
    partMass=massSearch(find(Rsq0==max(Rsq0)));
end
ylabel('R2')
xlabel('Particle mass (g)')
set(gca,'ylim',[-0.2 0.2])
title('Best Fit / Part Mass (g) / Scenario - Microplastics - SEA Pacific data')
set(gcf,'color','w')
grid on
box on


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Best scenario for current only, R2=0.19 for mass=4400g
s=1;
partMass = 4400;
load([scenario{s} '.mat'])
modelledDensity  = density_2./stationSearchArea(:,2); %in parts/km2, 0.5 degree search

dataSet=find(data(:,4)==2); % SEA Pacific

% load modelled vs measure
stationDate=date(dataSet);
X=log10(measuredDensity(dataSet)+1);
Y=log10(modelledDensity(dataSet)*partMass+1);
stationDate(isnan(X))=[];
Y(isnan(X))=[];
X(isnan(X))=[];

%remove 0 values
stationDate=stationDate(X>0);
X0=X(X>0);
Y0=Y(X>0);
stationDate=stationDate(Y0>0);
X0=X0(Y0>0);
Y0=Y0(Y0>0);

% linear regression
%     a0=mean([ones(length(X0),1) X0]./Y0);
a0=X0\Y0;
Ycalc0=a0*X0;
Rsq0 = 1-(sum((Y0 - Ycalc0).^2)/sum((Y0 - mean(Y0)).^2));

figure
plot(X0, Y0,'.')
hold on
plot(0:10,a0*[0:10],'k')

xlabel('Measured mass density log10(g/km^2)')
ylabel('Modelled mass density log10(g/km^2)')
set(gca,'xlim',[0 6],'ylim',[0 6])
title('Current only - Coastal (Mp = 4400 g) - Microplastics - SEA Pacific data')
set(gcf,'color','w')
grid on
box on

figure
scatter(X0, Y0, 5, round((stationDate-datenum(1993,0,0,0,0,0))/365), 'filled')
hold on
plot(0:10,a0*[0:10],'k')

xlabel('Measured mass density log10(g/km^2)')
ylabel('Modelled mass density log10(g/km^2)')
set(gca,'xlim',[0 6],'ylim',[0 6])
title('Current only - Coastal (Mp = 4400 g) - Microplastics - SEA Pacific data')
set(gcf,'color','w')
grid on
box on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Now decompose per years

scenario={'Eriksen_SEA_coastal_current';
    'Eriksen_SEA_coastal_current_stokes';
    'Eriksen_SEA_coastal_current_stokes_wind_0.1';
    'Eriksen_SEA_coastal_current_stokes_wind_0.5';
    'Eriksen_SEA_coastal_current_stokes_wind_1';
    'Eriksen_SEA_coastal_current_stokes_wind_2'};
cmap=jet(length(scenario));
figure
for s=1:length(scenario)
    
    load([scenario{s} '.mat'])
    modelledDensity  = density_2./stationSearchArea(:,2); %in parts/km2, 0.5 degree search
    
    dataSet=find(data(:,4)==2); % SEA Pacific
    
    bestMass=zeros(length(1:20),1);
    bestRsq=zeros(length(1:20),1);
    nStation=zeros(length(1:20),1);
    for year=1:20
        
        massSearch=100:100:10000;
        
        Rsq0=zeros(length(massSearch),1); k=0;
        
        for partMass=massSearch; %in g
            
            k=k+1;
            
            % load modelled vs measure
            stationDate=date(dataSet);
            X=log10(measuredDensity(dataSet)+1);
            Y=log10(modelledDensity(dataSet)*partMass+1);
            Y(isnan(X))=[];
            X(isnan(X))=[];
            
            %remove 0 values
            stationDate=stationDate(X>0);
            X0=X(X>0);
            Y0=Y(X>0);
            stationDate=stationDate(Y0>0);
            X0=X0(Y0>0);
            Y0=Y0(Y0>0);
            
            %select only for the current year
            ind=find(round((stationDate-datenum(1993,0,0,0,0,0))/365)>year-1 & round((stationDate-datenum(1993,0,0,0,0,0))/365)<=year );
            X0(ind)=[];
            Y0(ind)=[];

            % linear regression
            %     a0=mean([ones(length(X0),1) X0]./Y0);
            a0=X0\Y0;
            Ycalc0=a0*X0;
            Rsq0(k) = 1-(sum((Y0 - Ycalc0).^2)/sum((Y0 - mean(Y0)).^2));
            
        end
        bestMass(year)=massSearch(Rsq0==max(Rsq0));
        bestRsq (year)=max(Rsq0);
        nStation(year)=length(X0);
    end
    
    
    subplot(1,4,1)
    hold on
    plot(1992+(1:20),bestRsq,'color',cmap(s,:),'linewidth',2,'DisplayName',strrep(scenario{s}(20:end),'_',' '))
    ylabel('R2')
%     set(gca,'ylim',[-0.2 0.2])
%     title('Best Fit / Part Mass (g) / Scenario - Microplastics - SEA Pacific data')
    grid on
    box on
    subplot(1,4,2)
    hold on
    plot(1992+(1:20),bestMass,'color',cmap(s,:),'linewidth',2,'DisplayName',strrep(scenario{s}(20:end),'_',' '))
    ylabel('Mp (g)')

%     title('Best Fit / Part Mass (g) / Scenario - Microplastics - SEA Pacific data')
    grid on
    box on
    subplot(1,4,3)
    hold on
    plot(1992+(1:20),nStation,'color',cmap(s,:),'linewidth',2,'DisplayName',strrep(scenario{s}(20:end),'_',' '))
    ylabel('Number of comparison points')

%     title('Best Fit / Part Mass (g) / Scenario - Microplastics - SEA Pacific data')
    grid on
    box on
    
end

set(gcf,'color','w')
