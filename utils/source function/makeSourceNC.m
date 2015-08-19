clear

% settings

m_particle = 200000 ; % 1 particle = 100 tonnes
r_release = 50000 ; % 50km release radius
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
waste_person_day=NUM(:,2);

[NUM,TXT,RAW]=xlsread('Natl_Pop_Proj_B2.xls');

pop_unsd=NUM(:,1);
pop_proj=NUM(:,5:10); % 1990-2015 every 5 years
pop_year=NUM(1,5:10);

clear NUM TXT RAW

%--------------------------------------------------------------------------

% loop through countries
for k=1:length(unsd_list)
    
    if isnan(unsd_list(k)); continue; end
    
    % get unsd code
    country = unsd_list(k);
    
    % get country's coastal population density grid
    popDensity1990 = P;
    popDensity1990(ID ~=country)=0;
    
    % get country's estimated generation of 
    % mismanaged waste per person per year in kg (Jambeck 2015)
    waste_person_year = waste_person_day(k) * 365;
    
    % find index of country in SRES B2 pop projection
    pop_id = find( pop_unsd==country );

    
    % loop trough years
    for year=1990:2012
        
        % get country's population growth rate from 1990 to current year
        y1 = floor((year-1990)/5) +1;
        y2 =  ceil((year-1990)/5) +1;
        if y1==y2
            pop = pop_proj( pop_id, y1 );
        else
            k1 = (pop_year(y2) - year) / ( pop_year(y2) - pop_year(y1) );
            k2 = (year - pop_year(y1)) / ( pop_year(y2) - pop_year(y1) );
            pop = k1 * pop_proj( pop_id, y1 ) + k2 * pop_proj( pop_id, y2 );
        end
        pop_growth_rate = pop / pop_proj( pop_id, 1 ) ;
        
        % compute country's coastal population density grid for the year
        popDensity = popDensity1990 * pop_growth_rate ;
        
        % compute country's total mismanaged waste grid for the year
        wasteDensity = popDensity * waste_person_year;
        
        % compute country's total number of particles for the year
        particleDensity = round(wasteDensity / m_particle);
        
        % init particle db
        np=sum(particleDensity(:));
        part_lon  = zeros(np,1);
        part_lat  = zeros(np,1);
        part_date = zeros(np,1);
        part_id   = zeros(np,1);
        k_part = 0;
        
        if np==0; continue; end
        
        % loop through coastal cells 
        [I,J] = find (particleDensity~=0);
        for l=1:length(I)
            i=I(l);
            j=J(l);
            for part=1:particleDensity(i,j)
                
                % get surrounding water cells
                dlon = m2lon(r_release, Plat(j));
                dlat = m2lat(r_release, Plat(j));
                i_s=getIndex(Plon(i)-dlon,LON);
                i_e=getIndex(Plon(i)+dlon,LON);
                j_s=getIndex(Plat(j)-dlat,LAT);
                j_e=getIndex(Plat(j)+dlat,LAT);
                land_subset = LAND(i_s+1:i_e+1,j_s+1:j_e+1);
                [il,jl]=find(land_subset==0);
                
                if isempty(il); continue; end
                % choose random location in random water cell
                R1 = ceil(rand * length(il));
                tmp_lon = LON( i_s + il(R1)) + (rand*2-1) *dx_hycom/2;
                tmp_lat = LAT( j_s + jl(R1)) + (rand*2-1) *dx_hycom/2;
                
                % choose random release date within the year
                Rdate = rand * 365;
                
                % populate particles db
                k_part = k_part +1;
                part_lon  (k_part) = tmp_lon;
                part_lat  (k_part) = tmp_lat;
                part_date (k_part) = datenum(year,1,1,0,0,0) + Rdate;
                part_id   (k_part) = k_part;
            end
        end
        
       % write NETCDF source file
       ncfile=['../../sources_nc/parts_source_' num2str(year) '_' num2str(country) '.nc'];
       ncid = netcdf.create(ncfile,'CLOBBER');
       netcdf.putAtt(ncid,netcdf.getConstant('NC_GLOBAL'),'unsd',country);
       p_dimID = netcdf.defDim(ncid,'x',np);
       netcdf.defVar(ncid,'id','NC_SHORT', p_dimID );
       netcdf.defVar(ncid,'lon','NC_FLOAT', p_dimID );
       netcdf.defVar(ncid,'lat','NC_FLOAT', p_dimID );
       netcdf.defVar(ncid,'releaseDate','NC_FLOAT', p_dimID );
       netcdf.endDef(ncid)
       
       netcdf.putVar(ncid, 0, int16(part_id))
       netcdf.putVar(ncid, 1, part_lon)
       netcdf.putVar(ncid, 2, part_lat)
       netcdf.putVar(ncid, 3, part_date)
       
       netcdf.close(ncid)

    end
end