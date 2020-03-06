lon = ncread('../output/parts_2015_2015.nc', 'lon');
lat = ncread('../output/parts_2015_2015.nc', 'lat');

s = size(lon);
ndays = s(1);
figure('Position', [100, 100, 1200, 800]);
m_proj('miller');
lon(lon > 180) = lon(lon > 180) - 360;
[X, Y] = m_ll2xy(lon, lat);
for i=1:ndays
    plot(X(i, :), Y(i, :), '.k', 'markersize', 1);
    m_coast();
    m_grid();
    pause(.1);
end
