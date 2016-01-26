function p = storeOutput ( p, settings)

% storeOutput
% -------------
%

disp(['store output at ' datestr(settings.date)])

t = getIndex(settings.date, settings.outputDateList);

p.LON(t,:) = p.lon;
p.LAT(t,:) = p.lat;


 