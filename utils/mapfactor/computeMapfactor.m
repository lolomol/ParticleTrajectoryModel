% build dx, dy from lon and lat

dx = zeros( length(lon),length(lat) );
dy = zeros( length(lon),length(lat) );

for i=1:length(lon)-1
    for j=1:length(lat)-1
        [dx1km dx2km]=lldistkm([ lat(j) lon(i) ]',[ lat(j) lon(i+1) ]'); 
        [dy1km dy2km]=lldistkm([ lat(j) lon(i) ]',[ lat(j+1) lon(i) ]'); 
        dx(i,j) = dx1km * 1000;
        dy(i,j) = dy1km * 1000;
    end
end
dx( end ,:) = dx( end-1 ,:);
dy( end ,:) = dy( end-1 ,:);
dx( :, end ) = dx( :, end-1 );
dy( :, end ) = dy( :, end-1 );