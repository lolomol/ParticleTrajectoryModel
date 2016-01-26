filename = 'F:\particles\try\UniformSource_lowstokes_1pWindage_2005.nc';

ncid = netcdf.open(filename,'NOWRITE');
time = netcdf.getVar(ncid,0);
lon  = netcdf.getVar(ncid,1);
lat  = netcdf.getVar(ncid,2);
netcdf.close(ncid)

dx=0.1;
[LON,LAT] = meshgrid(0:dx:360,-90:dx:90);

nt = length(time);figure
np = size(lat,2);

C=zeros(size(LON));

for t = 1 : nt
    for p = 1 : np
        i = round(lat(t,p)/dx) + 901;
        j = round(lon(t,p)/dx) + 1;
        C(i,j) = C(i,j) + 1;
    end
end

C=C/np/nt;

figure
pcolor(LON,LAT,log10(C)); shading flat 
caxis([-8 -4]); axis image

figure
pcolor(LON,LAT,log10(C4)-log10(C0)); shading flat 
caxis([-1 1]); axis image