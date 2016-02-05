function extractForcing

settings.SScurrentPath  = 'C:\Users\lolo\Documents\TheOceanCleanup\data\hycom\';
settings.SScurrentTimeOrigin = datenum(2000,12,31,0,0,0);


files=dir('C:\Users\lolo\Documents\TheOceanCleanup\data\globaldrifter\shp\*.shp');
drogue=1;
Nstations=0;

for f=1:length(files)
    traj= shaperead([files(f).name]);
    
    for k=1:length(traj)
        if traj(k).drogue==drogue
            Nstations=Nstations+length(traj(k).X);
        end
    end
    
end


% init arrays
date=zeros(Nstations,1);
id=zeros(Nstations,1);
ktraj=zeros(Nstations,1);
lat=zeros(Nstations,1);
lon=zeros(Nstations,1);

% populate arrays
ind=0;

for f=1:length(files)
    traj= shaperead([files(f).name]);
    
    for k=1:length(traj)
        if traj(k).drogue==drogue
            for i=1:length(traj(k).X)
                ind=ind+1;
                date(ind) = traj(k).startDate+(i-1);
                lat(ind)  = traj(k).Y(i);
                lon(ind)  = traj(k).X(i);
                id(ind)   = str2num(files(f).name(1:end-4));
                ktraj(ind)= k;
            end
        end
    end
    
end

% remove everything before 1993
lat(date<datenum(1993,1,1,0,0,0))=[];
lon(date<datenum(1993,1,1,0,0,0))=[];
id(date<datenum(1993,1,1,0,0,0))=[];
ktraj(date<datenum(1993,1,1,0,0,0))=[];
date(date<datenum(1993,1,1,0,0,0))=[];



% retrieve UV model
u = zeros(Nstations,1);
v = zeros(Nstations,1);
date_unique=unique(date);

for t=1:length(date_unique)
    disp(t/length(date_unique))
    ind=find(date==date_unique(t));
    settings.date=date_unique(t);
    p.np=length(ind);
    p.lon=lon(ind)';
    p.lat=lat(ind)';
    [u(ind),v(ind)]=getSScurrent (p, settings);
end