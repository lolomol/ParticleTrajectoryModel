filePrefix='1000m';
time=[];lon=[];lat=[];releaseDate=[];depth=[];
for year=2015:2019
    filename = [filePrefix '_parts_' num2str(year) '_2015.nc'];
    file = ['../output/' filename];
    time = vertcat(time, ncread(file, 'time'));
    lon = vertcat(lon, ncread(file, 'lon'));
    lat = vertcat(lat, ncread(file, 'lat'));
    depth = vertcat(depth, ncread(file, 'depth'));
end
releaseDate = ncread(file, 'releaseDate');  % same across all files


figure('Position', [100, 100, 1200, 800]);
m_proj('miller');
lon(lon > 180) = lon(lon > 180) - 360;
[X, Y] = m_ll2xy(lon, lat);

max_depth = max(depth, [], 'all');

p1 = subplot(2, 1, 1);
released = releaseDate < time(1);
s = scatter(X(1, released), Y(1, released), 12, depth(1, released), 'filled');
cbar = colorbar();
set(cbar, 'ydir', 'reverse');
ylabel(cbar, 'Particle Depth (m)');
caxis([0, 500]);
%colormap(flipud(colormap('parula')));
colormap('cool');
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
time_stride=1;
while true
    for i=2:time_stride:length(time)
        released = releaseDate < time(i);
        s.XData = X(i, released);
        s.YData = Y(i, released);
        s.CData = depth(i, released);

        l.Value = time(i);
        pause(.005);
    end
    w = waitforbuttonpress;
end

% if you want to plot particle depth tracks, run this
figure; plot(datetime(time, 'convertfrom', 'datenum'), -depth);