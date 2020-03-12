classdef Hyperslab
    %HYPERSLAB hold subset of a netcdf file with dims (lon, lat z, time)
    properties
        lon
        lat
        z
        time
        data
    end
    
    methods
        function obj = Hyperslab(lon, lat, z, time, data)
            %HYPERSLAB constructor
            obj.lon = lon;
            obj.lat = lat;
            obj.z = z;
            obj.time = time;
            obj.data = data;
        end
        
        function value = select(obj, seek_lon, seek_lat, seek_z, seek_time)
            % selects from obj.data using 'nearest' method
            % arguments can be vectors length n; then 'select' returns n
            % values, such that value(i) = obj.data(seek_lon(i), seek_lat(i), seek_z(i), seek_time(i))
            [~, lon_idx] = min(abs(obj.lon-seek_lon), [], 1);
            [~, lat_idx] = min(abs(obj.lat-seek_lat), [], 1);
            [~, z_idx] = min(abs(obj.z-seek_z), [], 1);
            [~, time_idx] = min(abs(obj.time-seek_time), [], 1);
            
            size_of_dims = [1, 1, 1, 1];
            size_of_dims(1:length(size(obj.data))) = size(obj.data);
            
            linear_idx = sub2ind(size_of_dims, lon_idx, lat_idx, z_idx, time_idx);
            value = obj.data(linear_idx);
        end
    end
end