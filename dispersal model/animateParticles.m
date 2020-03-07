file = '../output/parts_2015_2015_3d_1000m.nc';
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
time = datenum(2015, 01, 01):datenum(0, 0, 1):datenum(2015, 01, 07);
for i=1:length(time)
    released = releaseDate < time(i);
    plot(X(i, released), Y(i, released), '.k', 'markersize', 1);
    m_coast();
    m_grid();
    pause(.1);
end

