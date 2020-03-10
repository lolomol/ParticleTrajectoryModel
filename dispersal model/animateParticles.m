filename = 'parts_2015_2015_3d_oscillating.nc';
file = ['../output/' filename];
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
max_depth = max(depth, [], 'all');
for i=1:2:length(time)
    p1 = subplot(2, 1, 1);
    released = releaseDate < time(i);
    scatter(X(i, released), Y(i, released), 8, depth(i, released), 'filled');
    cbar = colorbar();
    set(cbar, 'ydir', 'reverse');
    ylabel(cbar, 'Particle Depth (m)');
    caxis([0, max_depth]);
    colormap(flipud(colormap('parula')));
    m_coast();
    m_grid();
    
    p2 = subplot(2, 1, 2);
    xline(time(i), 'LineWidth', 5);
    xlim([time(1), time(end)]);
    datetick('x','keeplimits','keepticks')
    xlabel('Current Time');
    set(p2,'Ytick',[]);
    
    sgtitle(['Output file ' filename], 'Interpreter', 'none');

    p1.Position = p1.Position + [-.18 -.4 .4 .4];
    p2.Position = p2.Position - [0 0 0 .3];
    pause(.0001);
end

