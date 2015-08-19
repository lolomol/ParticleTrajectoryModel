nc=ncgeodataset('C:\Users\lolo\Documents\TheOceanCleanup\wavewatch3\CFSR\multi_reanal.glo_30m.hs.200201.grb2.gz');
nc.variables
hsvar=nc.geovariable('Significant_height_of_combined_wind_waves_and_swell_surface');
g=hsvar.grid_interop(:,:,:);

for t=1:length(g.time)
    hs=hsvar.data(t,:,:);
    pcolorjw(g.lon,g.lat,hs);
    caxis([0 10])
    drawnow
    pause(0.1)
end
