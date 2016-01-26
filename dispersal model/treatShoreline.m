function [lon,lat] = treatShoreline(p,settings,dlon,dlat,id,jd,lon,lat,land)

index = find(land==1)';

id_ = getIndex(p.lon(index),settings.grid.lon) ;
jd_ = getIndex(p.lat(index),settings.grid.lat) ;

ids = mod(id(index) - sign(dlon(index)) -1 ,length(settings.grid.lon))+1 ;
jds = mod(jd(index) - sign(dlat(index)) -1 ,length(settings.grid.lat))+1 ;


for i=1:length(index)
    
    k=index(i);
    
    land_x = settings.grid.land(id(k),jd_(i));
    land_y = settings.grid.land(id_(i),jd(k));
    land_xs = settings.grid.land(id(k),jds(i));
    land_ys = settings.grid.land(ids(i),jd(k));
    
    
    % longitude tansport dominant
    if dlon(k)>=dlat(k) && ~land_x % advect in lon only
        lat(k) = p.lat(k);
    elseif dlon(k)>=dlat(k) && ~land_y % advect in lat only
        lon(k) = p.lon(k);
        
        % latitude transport dominant
    elseif dlat(k)>dlon(k) && ~land_y % advect in lat only
        lon(k) = p.lon(k);
    elseif dlat(k)>dlon(k) && ~land_x % advect in lon only
        lat(k) = p.lat(k);
        
        % if still stuck force one cell up
    elseif dlon(k)>=dlat(k) && ~land_xs %shift lat by one cell
        lat(k) = settings.grid.lat(jds(i));
    elseif dlat(k)>dlon(k) && ~land_ys  %shift lon by one cell
        lon(k) = settings.grid.lon(ids(i));
        
        % if still stuck don't update
    else
        lon(k) = p.lon(k);
        lat(k) = p.lat(k);
    end
end
