function p = storeOutput ( p, settings)

% storeOutput
% -------------
%

t = getIndex(settings.date, settings.outputDateList);

p.LON(t,:) = p.lon;
p.LAT(t,:) = p.lat;


 