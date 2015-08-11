function [LON,LAT] = storeOutput ( LON, LAT, p, settings)

% storeOutput
% -------------
%


t = getIndex(settings.date, settings.outputDateList');

LON(t,:) = p.lon;
LAT(t,:) = p.lat;


 