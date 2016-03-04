% SEAatl, SEApac, Eriksen come from import data of 
% Standardized debris density Atlantic.csv,
% Standardized debris density Pacific.csv,
% All Gyres Datasheet_160414.csv
% NaN for no numeric values


dateSEAatl=datenum(SEAatl(:,3),SEAatl(:,4),SEAatl(:,5),0,0,0);
dateSEApac=datenum(SEApac(:,3),SEApac(:,4),SEApac(:,5),0,0,0);

Nstations=length(Eriksen)+length(SEApac)+length(SEAatl);

data=zeros(Nstations,12);

% column 1 -date
% column 2- latitude
% column 3-longitude (0 - 360 degree)
% column 4- source (1=Eriksen, 2=SEA Pacific, 3=SEA Atlantic so we can retrieve additional metadata such as sea state or wind speed for further corrections)
% column 5 to 8 - particle density (four columns corresponding to the four size classes covered by Eriksen 2014, only first column (5) used when data is from SEA)
% column 9 to 12- weigtht density (four columns corresponding to the four size classes covered by Eriksen 2014, only first column (9) used when data is from SEA)

for k=1:Nstations  
    if k<=length(Eriksen)
       data(k,1)=Eriksen(k,1);
       data(k,2)=Eriksen(k,2);
       data(k,3)=Eriksen(k,3); 
       data(k,4)=1; 
       data(k,5)=Eriksen(k,4); % particles/km2
       data(k,6)=Eriksen(k,5); 
       data(k,7)=Eriksen(k,6); 
       data(k,8)=Eriksen(k,7);  
       data(k,9) =Eriksen(k,8); % g/km2
       data(k,10)=Eriksen(k,9); 
       data(k,11)=Eriksen(k,10); 
       data(k,12)=Eriksen(k,11); 
       
    elseif k<=length(Eriksen)+length(SEApac)
       kk=k-length(Eriksen);
       data(k,1)=dateSEApac(kk);
       data(k,2)=SEApac(kk,6);
       data(k,3)=SEApac(kk,7); 
       data(k,4)=2; 
       data(k,5)=SEApac(kk,8) * 1000000; % from particles/m2 to particles/km2
       data(k,6)=NaN; 
       data(k,7)=NaN; 
       data(k,8)=NaN;  
       data(k,9) =SEApac(kk,9) * 1000; % from mg/m2 to g/km2
       data(k,10)=NaN; 
       data(k,11)=NaN; 
       data(k,12)=NaN; 
    else
       kk=k-length(Eriksen)-length(SEApac);
       data(k,1)=dateSEAatl(kk);
       data(k,2)=SEAatl(kk,6);
       data(k,3)=SEAatl(kk,7); 
       data(k,4)=2; 
       data(k,5)=SEAatl(kk,8) * 1000000; % from particles/m2 to particles/km2
       data(k,6)=NaN; 
       data(k,7)=NaN; 
       data(k,8)=NaN;  
       data(k,9) =SEAatl(kk,9) * 1000; % from mg/m2 to g/km2
       data(k,10)=NaN; 
       data(k,11)=NaN; 
       data(k,12)=NaN; 
    end
end
        

% correct lon>0
data(data(:,3)<0,3)=data(data(:,3)<0,3)+360;

% remove pre 1993
data(data(:,1)<datenum(1993,1,1,0,0,0),:)=[];

% clean data
data(isnan(data(:,1)),:)=[];