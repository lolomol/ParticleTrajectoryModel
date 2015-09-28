filename = 'F:\particles\try\UniformSource_2005.nc';

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