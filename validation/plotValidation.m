
% clear all
% load('drogue_comparison.mat')

%% Plot regression

% filename= 'ModelledVSMeasured_DrogueON_current.png';
% [theta,vel] = cart2pol(u,v);
% filename= 'ModelledVSMeasured_DrogueOFF_currentstokes.png';
% [theta,vel] = cart2pol(u+us,v+vs);
% filename= 'ModelledVSMeasured_DrogueOFF_currentstokeswind0.1.png';
% [theta,vel] = cart2pol(u+us+0.1*uw,v+vs+0.1*vw);
filename= 'ModelledVSMeasured_DrogueOFF_currentstokeswind0.6.png';
[theta,vel] = cart2pol(u+us+0.6*uw,v+vs+0.6*vw);
% filename= 'ModelledVSMeasured_DrogueOFF_currentstokeswind1.png';
% [theta,vel] = cart2pol(u+us+1*uw,v+vs+1*vw);
% filename= 'ModelledVSMeasured_DrogueOFF_currentstokeswind2.png';
% [theta,vel] = cart2pol(u+us+2*uw,v+vs+2*vw);
% filename= 'ModelledVSMeasured_DrogueOFF_currentstokeswind3.png';
% [theta,vel] = cart2pol(u+us+3*uw,v+vs+3*vw);
% filename= 'ModelledVSMeasured_DrogueOFF_currentstokeswind10.png';
% [theta,vel] = cart2pol(u+us+10*uw,v+vs+10*vw);


[theta_,vel_] = cart2pol(u_,v_);

theta=mod(theta*180/pi,360);
theta_=mod(theta_*180/pi,360);

[Rmod,Rmes]=meshgrid(0:0.01:3,0:0.01:3);
Rcount=zeros(size(Rmod));

for k=1:Nstations
    i=round(vel_(k)*100)+1;
    j=round(vel(k)*100)+1;
    if i<301 && j<301
        Rcount(i,j)=Rcount(i,j)+1;
    end
end

[thetamod,thetames]=meshgrid(0:1:360,0:1:360);
thetacount=zeros(size(thetamod));
for k=1:Nstations
    i=round(theta_(k))+1;
    j=round(theta(k))+1;
    thetacount(i,j)=thetacount(i,j)+1;
end

[p,bint,r,rint,stats]=LinRegress(vel_, vel);
close gcf

thetacount(thetacount==0)=NaN;
Rcount(Rcount==0)=NaN;

figure

% subplot(1,2,1)
pcolor(0:0.01:3,0:0.01:3,log10(Rcount));
shading flat
hold on
plot([0 2],[0 2],'w','linewidth',2)
plot([0 2],[0 2]*(vel\vel_),'k','linewidth',2)
axis xy
axis image
xlim([0 2]), ylim([0 2])
caxis([0 3])
title('Velocity (m/s)')
ylabel('measured')
xlabel('modelled')
set(gca,'xtick',0:2)
set(gca,'ytick',0:2)
% colormap(gray)

% subplot(1,2,2)
% pcolor(0:360,0:360,log10(thetacount))
% shading flat
% hold on
% plot([0 360],[0 360],'w','linewidth',2)
% axis xy
% axis image
% caxis([0 3])
% title('Direction (degree)')
% ylabel('measured')
% xlabel('modelled')
% set(gca,'xtick',0:90:360)
% set(gca,'ytick',0:90:360)
% colormap(gray)

set(gcf,'position',[389   558   420   420],'color','w')

disp(['Modelled = ' num2str(p(1)) ' x Measured + ' num2str(p(2))])
disp(['Velocity R2= ' num2str(stats(1))])

export_fig(filename)

% [p,bint,r,rint,stats]=LinRegress(vel_, vel);
% contour(mod,mes,log10(count),[0:0.5:3]);figure(gcf);
% xlim([0 3]), ylim([0 3])



%% Plot R2 vs Windage Coefficient

r2s=zeros(51,1);
k=0;
for windage=0:0.1:5
    k=k+1;
    [theta,vel] = cart2pol(u+us+windage*uw,v+vs+windage*vw);
    [theta_,vel_] = cart2pol(u_,v_);
    
    [p,bint,r,rint,stats]=LinRegress(vel_, vel);
    close gcf
    r2s(k)=stats(1);
end

r2=zeros(51,1);
k=0;
for windage=0:0.1:5
    k=k+1;
    [theta,vel] = cart2pol(u+windage*uw,v+windage*vw);
    [theta_,vel_] = cart2pol(u_,v_);
    
    [p,bint,r,rint,stats]=LinRegress(vel_, vel);
    close gcf
    r2(k)=stats(1);
end


%% Map Error


dx=1;
[LON,LAT] = meshgrid(0:dx:360,-90:dx:90);
E  = NaN(size(LON));
DV = NaN(size(LON));
C  = zeros(size(LON));

[theta,vel]   = cart2pol(u,v);
% [theta,vel]   = cart2pol(u+us+0.6*uw,v+vs+0.6*vw);
[theta_,vel_] = cart2pol(u_,v_);

for k=1:Nstations

    i = round(lat(k)/dx) + 90/dx + 1;
    j = round(lon(k)/dx) + 1;
    
    if isnan(E(i,j))
        E(i,j)=0;
        DV(i,j)=0;
    end
    
    E(i,j) = E(i,j)+(vel(k)-vel_(k))/vel_(k);
    DV(i,j) = DV(i,j)+(vel(k)-vel_(k));
    C(i,j) = C(i,j) + 1;
    
end

E=E./C*100;
DV=DV./C;

figure;

subplot(3,1,1)
pcolor(LON,LAT,E)
ylim([-80 80])
shading flat
caxis([-100 100])
title('Average error (%)')
colorbar


subplot(3,1,2)
pcolor(LON,LAT,DV)
ylim([-80 80])
shading flat
caxis([-0.5 0.5])
title('Average dV (m/s)')
colorbar



subplot(3,1,3)
pcolor(LON,LAT,log10(C))
ylim([-80 80])
shading flat
caxis([0 3])
title('Drifter visits (log10)')
colorbar




set(gcf,'position',[680    49   494   948],'color','w')

export_fig('ErrorMaps_drogue.png')

