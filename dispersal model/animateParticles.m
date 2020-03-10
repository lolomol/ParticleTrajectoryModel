filename = 'parts_2015_2015_3d_1000m.nc';
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

p1 = subplot(2, 1, 1);
released = releaseDate < time(1);
s = scatter(X(1, released), Y(1, released), 8, depth(1, released), 'filled');
cbar = colorbar();
set(cbar, 'ydir', 'reverse');
ylabel(cbar, 'Particle Depth (m)');
caxis([0, max_depth]);
colormap(flipud(colormap('parula')));
m_coast();
m_grid();

p2 = subplot(2, 1, 2);
l = xline(time(1), 'LineWidth', 5);
xlim([time(1), time(end)]);
datetick('x','keeplimits','keepticks')
xlabel('Current Time');
set(p2,'Ytick',[]);

sgtitle(['Output file ' filename], 'Interpreter', 'none');

p1.Position = p1.Position + [-.18 -.4 .4 .4];
p2.Position = p2.Position - [0 0 0 .3];
for i=2:1:length(time)
    released = releaseDate < time(i);
    s.XData = X(i, released);
    s.YData = Y(i, released);
    s.CData = depth(i, released);
    
    l.Value = time(i);
    pause(.01);
end


