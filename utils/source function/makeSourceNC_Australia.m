clear

% settings
dx_hycom = 0.08 ; %hycom model resolution in degrees

% load data

P = dlmread('p1990i15_coastal50km.ascii',' ',6,0);
P=flipud(P)';
P(1441,:)=[]; % no repeat at 360
Plon=0:0.25:359.75;
Plat=-58:0.25:84.75;

ID = dlmread('unsdcode.ascii',' ',6,0);
ID=flipud(ID)';
ID(1441,:)=[]; % no repeat at 360

ncid=netcdf.open('../../../grid/HYCOM_grid_expt19.nc','NOWRITE');
LON=netcdf.getVar(ncid,0);
LAT=netcdf.getVar(ncid,1);
LAND=netcdf.getVar(ncid,2);
netcdf.close(ncid)

[NUM,TXT,RAW]=xlsread('Jambeck2015.xlsx');

unsd_list=NUM(:,5);

clear NUM TXT RAW

k=101; %% Australia
country = unsd_list(k);

popDensity1990 = P;
popDensity1990(ID ~=country)=0;

[lat,lon]=meshgrid(LAT,LON);

PI = interp2(Plat,Plon,popDensity1990,lat,lon);
PI(isnan(PI))=0;

coastal=zeros(size(LAND));

for i=2:size(LAND,1)-1
    for j=2:size(LAND,2)-1
        if LAND(i,j)==0 && sum(sum(LAND(i-1:i+1,j-1:j+1)))~=0
           coastal(i,j)=1; 
        end
    end
end

[ic,jc]=find(coastal==1);

[ip,jp]=find(PI>0);

PI_coastal=zeros(size(LAND));
for k=1:length(ip)
    dist=sqrt((ic-ip(k)).^2+(jc-jp(k)).^2);
    kk=find(dist==min(dist),1,'first');
    PI_coastal(ic(kk),jc(kk))=PI_coastal(ic(kk),jc(kk))+PI(ip(k),jp(k)); 
end

Npart=round(PI_coastal/sum(PI_coastal(:))*10000);

diff=(Npart==0)-(PI_coastal==0);
[I,J]=find(diff~=0);
subdiff=zeros(length(I),1);
for k=1:length(I)
    subdiff(k)=PI_coastal(I(k),J(k));
end
[subdiff_sort,IX] = sort(subdiff,'descend');

for k=1:10000-sum(Npart(:))
    Npart(I(IX(k)),J(IX(k)))=Npart(I(IX(k)),J(IX(k)))+1;
end

part_lon=zeros(10000,1);
part_lat=zeros(10000,1);
k=0;
for i=1:size(Npart,1)
    for j=1:size(Npart,2)
        for p=1:Npart(i,j)
            k=k+1;
            part_lon(k) = LON(i) + (rand*2-1) *dx_hycom/2;
            part_lat(k) = LAT(j) + (rand*2-1) *dx_hycom/2;
        end
    end
end

np=10000;
% write NETCDF source file
       ncfile=['../../../sources_nc/Australia_source.nc'];
       ncid = netcdf.create(ncfile,'CLOBBER');
       p_dimID = netcdf.defDim(ncid,'x',np);
       netcdf.defVar(ncid,'id','NC_SHORT', p_dimID );
       netcdf.defVar(ncid,'lon','NC_FLOAT', p_dimID );
       netcdf.defVar(ncid,'lat','NC_FLOAT', p_dimID );
       netcdf.defVar(ncid,'releaseDate','NC_FLOAT', p_dimID );
       netcdf.defVar(ncid,'UNSD','NC_FLOAT', p_dimID );
       netcdf.endDef(ncid)
       
       netcdf.putVar(ncid, 0, int16(1:np))
       netcdf.putVar(ncid, 1, part_lon)
       netcdf.putVar(ncid, 2, part_lat)
       netcdf.putVar(ncid, 3, part_lon*0)
       netcdf.putVar(ncid, 4, part_lon*0+36)
       
       netcdf.close(ncid)


% 
% %--------------------------------------------------------------------------
% 
% % loop through countries
% for k=101%:length(unsd_list)
%     
%     if isnan(unsd_list(k)); continue; end
%     
%     % get unsd code
%     country = unsd_list(k);
%     
%     % get country's coastal population density grid
%     popDensity1990 = P;
%     popDensity1990(ID ~=country)=0;
%     
%     % get country's estimated generation of 
%     % mismanaged waste per person per year in kg (Jambeck 2015)
%     waste_person_year = waste_person_day(k) * 365;
%     
%     % find index of country in SRES B2 pop projection
%     pop_id = find( pop_unsd==country );
% 
%     
%     % loop trough years
%     for year=1990%:2012
%         
%         % get country's population growth rate from 1990 to current year
%         y1 = floor((year-1990)/5) +1;
%         y2 =  ceil((year-1990)/5) +1;
%         if y1==y2
%             pop = pop_proj( pop_id, y1 );
%         else
%             k1 = (pop_year(y2) - year) / ( pop_year(y2) - pop_year(y1) );
%             k2 = (year - pop_year(y1)) / ( pop_year(y2) - pop_year(y1) );
%             pop = k1 * pop_proj( pop_id, y1 ) + k2 * pop_proj( pop_id, y2 );
%         end
%         pop_growth_rate = pop / pop_proj( pop_id, 1 ) ;
%         
%         % compute country's coastal population density grid for the year
%         popDensity = popDensity1990 * pop_growth_rate ;
%         
%         % compute country's total mismanaged waste grid for the year
%         wasteDensity = popDensity * waste_person_year;
%         
%         % compute country's total number of particles for the year
%         particleDensity = (wasteDensity / m_particle);
%         
%         particleDensity=round(particleDensity/sum(particleDensity(:))*10000);
%         
%         % init particle db
%         np=sum(particleDensity(:));
%         part_lon  = zeros(np,1);
%         part_lat  = zeros(np,1); 
%         part_date = zeros(np,1);
%         part_id   = zeros(np,1);
%         k_part = 0;
%         
%         if np==0; continue; end
%         
%         % loop through coastal cells 
%         [I,J] = find (particleDensity~=0);
%         for l=1:length(I)
%             i=I(l);
%             j=J(l);
%             for part=1:particleDensity(i,j)
%                 
%                 % get surrounding water cells
%                 dlon = m2lon(r_release, Plat(j));
%                 dlat = m2lat(r_release, Plat(j));
%                 i_s=getIndex(Plon(i)-dlon,LON);
%                 i_e=getIndex(Plon(i)+dlon,LON);
%                 j_s=getIndex(Plat(j)-dlat,LAT);
%                 j_e=getIndex(Plat(j)+dlat,LAT);
%                 land_subset = LAND(i_s+1:i_e+1,j_s+1:j_e+1);
%                 [il,jl]=find(land_subset==0);
%                 
%                 if isempty(il); disp('empty il'); continue; end
%                 % choose random location in random water cell
%                 R1 = ceil(rand * length(il));
%                 tmp_lon = LON( i_s + il(R1)) + (rand*2-1) *dx_hycom/2;
%                 tmp_lat = LAT( j_s + jl(R1)) + (rand*2-1) *dx_hycom/2;
%                 
%                 % choose random release date within the year
%                 Rdate = 0;%rand * 365;
%                 
%                 % populate particles db
%                 k_part = k_part +1;
%                 part_lon  (k_part) = tmp_lon;
%                 part_lat  (k_part) = tmp_lat;
%                 part_date (k_part) = datenum(year,1,1,0,0,0) + Rdate;
%                 part_id   (k_part) = k_part;
%             end
%         end
%         
%         K=find(part_lon==0);
%         
%         for ii=1:length(K)
%             part_lon(K(ii))=part_lon(ii);
%             part_lat(K(ii))=part_lat(ii);
%         end
%         
%        % write NETCDF source file
%        ncfile=['../../../sources_nc/Australia_source.nc'];
%        ncid = netcdf.create(ncfile,'CLOBBER');
%        netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'unsd',country);
%        p_dimID = netcdf.defDim(ncid,'x',np);
%        netcdf.defVar(ncid,'id','NC_SHORT', p_dimID );
%        netcdf.defVar(ncid,'lon','NC_FLOAT', p_dimID );
%        netcdf.defVar(ncid,'lat','NC_FLOAT', p_dimID );
%        netcdf.defVar(ncid,'releaseDate','NC_FLOAT', p_dimID );
%        netcdf.defVar(ncid,'UNSD','NC_FLOAT', p_dimID );
%        netcdf.endDef(ncid)
%        
%        netcdf.putVar(ncid, 0, int16(part_id))
%        netcdf.putVar(ncid, 1, part_lon)
%        netcdf.putVar(ncid, 2, part_lat)
%        netcdf.putVar(ncid, 3, part_date)
%        netcdf.putVar(ncid, 4, part_date*0+36)
%        
%        netcdf.close(ncid)
% 
%     end
% end