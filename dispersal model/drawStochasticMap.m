
for year=2015:5:2115
    drawMap(100, year);
end

function drawMap (depth, year)

    filePrefix=[num2str(depth) 'm'];
    lon=[];lat=[];
    filename = [filePrefix '_parts_' num2str(year) '_2015.nc'];
    file = ['../output/' filename];
    lon = vertcat(lon, ncread(file, 'lon'));
    lat = vertcat(lat, ncread(file, 'lat'));
    lon(lon > 180) = lon(lon > 180) - 360;

    % flatten data
    s = size(lon);
    lon = reshape(lon, [1, s(1)*s(2)]);
    lat = reshape(lat, [1, s(1)*s(2)]);

    % grids for stochastic maps
    resolution_degrees = 1;
    lat_grid = linspace(-90, 90, 180/resolution_degrees);
    lon_grid = linspace(-180, 180, 360/resolution_degrees);

    [N, xedges, yedges] = histcounts2(lon, lat, lon_grid, lat_grid);
    [LAT, LON] = meshgrid(lat_grid(2:end)-resolution_degrees/2, lon_grid(2:end)-resolution_degrees/2);  % centers of bins

    f = figure(1); hold on; clf;
    m_proj('miller');
    [proj_LON, proj_LAT] = m_ll2xy(LON, LAT);
    [proj_lon, proj_lat] = m_ll2xy(lon, lat);
    [~, h] = contourf(proj_LON, proj_LAT, log(N));
    %scatter(proj_lon, proj_lat, 1);
    colormap(f, flipud(colormap('hot')));
    set(h,'LineColor','none');
    colorbar();
    m_coast();
    m_grid();
    title(['log particles per ' num2str(resolution_degrees) ' square degrees']);
    sgtitle(year);
end