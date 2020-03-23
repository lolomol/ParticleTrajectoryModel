function slab = chlSurf2Hyperslab(dataset_path, lon_range, lat_range, time_range)
%LOAD_HYPERSLAB extracts a hyperslab of surface chlorophyll, given ranges of lon, lat, and time
%               since chlSurf has singleton depth dimension, places z=0 in final slab.
%       the range variables are of form [min_value, max_value]
%       The ranges will be matched to the nearest values along each dimension
%   dataset_path: absolute path to a netcdf dataset with dimensions (lon, lat, time)
%   variable_name: name of the variable to extract
%   lon_range: min/max longitude (Deg E, 0 to 360)
%   lat_range: min/max latitude (Deg N, -90 to 90)
%   time_range: min/max time (Matlab datetime object)
%   returns: a hyperslab object

    lat_range = flip(lat_range);  % chlorophyll dataset gridded 90 to -90 (why? ugh)

    time_range = hours(time_range - datetime(2000, 01, 01, 00, 00, 00));  % convert to format stored in netcdf: hours since 2000-01-01T00:00:00
    
    ncid = dataset_path;
    lon = ncread(ncid, 'lon');
    lat = ncread(ncid, 'lat');
    time = ncread(ncid, 'time');
    
    [~, lon_idx] = min(abs(lon-lon_range));
    [~, lat_idx] = min(abs(lat-lat_range));
    [~, time_idx] = min(abs(double(time)-time_range));
    
    data = ncread(ncid, 'chlor_a', ...
        [lon_idx(1),        lat_idx(1), time_idx(1)], ... % start indices
        [lon_idx(2)-lon_idx(1)+1, lat_idx(2)-lat_idx(1)+1, time_idx(2)-time_idx(1)+1]);  % end indices
    lon = lon(lon_idx(1):lon_idx(2));
    lat = lat(lat_idx(1):lat_idx(2));
    z = 0;
    time = time(time_idx(1):time_idx(2));
    time = time/24 + datenum('2000-01-01');  % convert to matlab datenum (days since year 0)
    data = reshape(data, [length(lon), length(lat), 1, length(time)]);  % add singleton z dimension
    
    slab = Hyperslab(lon, lat, z, time, data);
end