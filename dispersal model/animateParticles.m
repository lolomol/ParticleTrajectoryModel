file = '../output/parts_2015_2015_3d_500m.nc';
lon = ncread(file, 'lon');
lat = ncread(file, 'lat');
releaseDate = ncread(file, 'releaseDate');
depth = ncread(file, 'depth');
s = size(lon);
ndays = s(1);
figure('Position', [100, 100, 1200, 800]);
m_proj('miller');
lon(lon > 180) = lon(lon > 180) - 360;
[X, Y] = m_ll2xy(lon, lat);
time = datenum(2015, 01, 01):datenum(0, 0, 1):datenum(2015, 01, ndays);
for i=1:length(time)
    released = releaseDate < time(i);
    scatter(X(i, released), Y(i, released), 8, depth(i, released), 'filled');
    colorbar();
    colormap('cool');
    m_coast();
    m_grid();
    pause(.01);
end

