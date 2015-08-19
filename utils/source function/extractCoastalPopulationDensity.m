p = dlmread('p1990i15.ascii',' ',6,0);
p=flipud(p)';
tmp=p;
p(1:720,:)=tmp(721:1440,:);
p(721:1440,:)=tmp(1:720,:);
p(1441,:)=p(1,:);
plon=0:0.25:360;
plat=-58:0.25:84.75;

ncid=netcdf.open('HYCOM_landmass.nc','NOWRITE');
lon=netcdf.getVar(ncid,0);
lat=netcdf.getVar(ncid,1);
land=netcdf.getVar(ncid,2);
netcdf.close(ncid)

pcolor(plon,plat,p')
shading flat
caxis([0 100000])
hold on
contour(lon,lat,land',[1 1],'w')
hold off


source_distance=50000; %50 km from the coast
p_coastal=zeros(size(p));

for i=1:length(plon)
    disp(i/length(plon))
    for j=1:length(plat)
        if p(i,j)>0
            dlon = m2lon(source_distance, plat(j));
            dlat = m2lat(source_distance, plat(j));

            i_s=getIndex(plon(i)-dlon,lon);
            i_e=getIndex(plon(i)+dlon,lon);
            j_s=getIndex(plat(j)-dlat,lat);
            j_e=getIndex(plat(j)+dlat,lat);

            land_subset = land(i_s+1:i_e+1,j_s+1:j_e+1);
            if min(land_subset(:)) == 0
                p_coastal(i,j)=p(i,j);
            end
        end
    end
end

figure
pcolor(plon,plat,p_coastal')
shading flat
caxis([0 100000])

% keep only 1440 first columns to not repeat 360 degree
fid=fopen('p1990i15_coastal50km.ascii','w');
fprintf(fid,'ncols         1440\r\nnrows         572\r\nxllcorner     0\r\nyllcorner     -58.000000000011\r\ncellsize      0.250002\r\nNODATA_value  -9999\r\n');
for j=size(p,2):-1:1
    fprintf(fid,'%g ',p_coastal(1:1440,j));
    fprintf(fid,'\r\n');
end
fclose(fid);