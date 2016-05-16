function Area=computeArea(Lat,Lon,dx)


Area=zeros(size(Lat));
for i=1:size(Lat,1)
    for j=1:size(Lat,2)
        latlon1=[Lat(i,j)+dx/2 Lon(i,j)-dx/2];
        latlon2=[Lat(i,j)+dx/2 Lon(i,j)+dx/2];
        dx1km=lldistkm(latlon1,latlon2);
        latlon1=[Lat(i,j)-dx/2 Lon(i,j)-dx/2];
        latlon2=[Lat(i,j)-dx/2 Lon(i,j)+dx/2];
        dx2km=lldistkm(latlon1,latlon2);
        latlon1=[Lat(i,j)-dx/2 Lon(i,j)];
        latlon2=[Lat(i,j)+dx/2 Lon(i,j)];
        dykm=lldistkm(latlon1,latlon2);
         
        Area(i,j)=dykm*(dx1km+dx2km)/2;
    end 
end