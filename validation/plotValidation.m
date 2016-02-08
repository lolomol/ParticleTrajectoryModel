
% clear all
% load('drogue_comparison.mat')

% filename= 'ModelledVSMeasured_DrogueON_current.png';
% [theta,vel] = cart2pol(u,v);
% filename= 'ModelledVSMeasured_DrogueON_currentstokes.png';
% [theta,vel] = cart2pol(u+us,v+vs);
filename= 'ModelledVSMeasured_DrogueON_currentstokeswind0.1.png';
[theta,vel] = cart2pol(u+us+0.1*uw,v+vs+0.1*vw);
% filename= 'ModelledVSMeasured_DrogueON_currentstokeswind0.5.png';
% [theta,vel] = cart2pol(u+us+0.5*uw,v+vs+0.5*vw);
% filename= 'ModelledVSMeasured_DrogueON_currentstokeswind1.png';
% [theta,vel] = cart2pol(u+us+1*uw,v+vs+1*vw);
% filename= 'ModelledVSMeasured_DrogueON_currentstokeswind2.png';
% [theta,vel] = cart2pol(u+us+2*uw,v+vs+2*vw);
% filename= 'ModelledVSMeasured_DrogueON_currentstokeswind3.png';
% [theta,vel] = cart2pol(u+us+3*uw,v+vs+3*vw);
% filename= 'ModelledVSMeasured_DrogueON_currentstokeswind10.png';
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

figure

subplot(1,2,1)
imagesc(0:3,0:3,log10(Rcount))
hold on
plot([0 2],[0 2],'w','linewidth',2)
axis xy
axis image
xlim([0 2]), ylim([0 2])
caxis([0 3])
title('Velocity (m/s)')
ylabel('measured')
xlabel('modelled')
set(gca,'xtick',0:2)
set(gca,'ytick',0:2)

subplot(1,2,2)
imagesc(0:360,0:360,log10(thetacount))
hold on
plot([0 360],[0 360],'w','linewidth',2)
axis xy
axis image
caxis([0 3])
title('Direction (degree)')
ylabel('measured')
xlabel('modelled')
set(gca,'xtick',0:90:360)
set(gca,'ytick',0:90:360)

set(gcf,'position',[389   558   851   420],'color','w')

disp(['Modelled = ' num2str(p(1)) ' x Measured + ' num2str(p(2))])
disp(['Velocity R2= ' num2str(stats(1))])

export_fig(filename)

% [p,bint,r,rint,stats]=LinRegress(vel_, vel);
% contour(mod,mes,log10(count),[0:0.5:3]);figure(gcf);
% xlim([0 3]), ylim([0 3])


 
 