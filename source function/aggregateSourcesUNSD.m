UNSDlist=[8;12;24;32;36;44;48;50;52;56;70;76;84;90;96;100;104;116;120;124;132;144;152;156;170;174;178;180;188;191;192;196;204;208;214;218;222;226;232;233;242;246;250;258;262;266;268;270;276;288;300;312;316;320;324;328;332;340;344;352;356;360;364;368;372;376;380;384;388;392;400;404;408;410;414;422;428;430;434;440;446;450;458;462;470;474;478;480;484;504;508;512;516;528;530;540;548;554;558;566;578;586;591;598;604;608;616;620;624;626;630;634;638;642;643;682;686;694;702;704;705;706;710;724;736;740;752;760;764;768;780;784;788;792;804;818;826;834;840;858;862;882;887;];



for y=1990:2015
    
    LON=[];LAT=[];RdATE=[];UNSD=[]; 
    k=0;
    
    for c=1:length(UNSDlist)
        country = UNSDlist(c);
        try
            ncid = netcdf.open(['../../sources_nc/parts_source_' num2str(y) '_' num2str(country) '.nc'],'NOWRITE');
            lon=netcdf.getVar(ncid,1);
            lat=netcdf.getVar(ncid,2);
            releaseDate=netcdf.getVar(ncid,3);

            netcdf.close(ncid)
        catch
            disp(['error for UNSD ' num2str(country)])
            continue
        end
        
        
        
        LON(k+1:k+length(lon))=lon;
        LAT(k+1:k+length(lon))=lat;
        RdATE(k+1:k+length(lon))=releaseDate;
        UNSD(k+1:k+length(lon))=ones(length(lon),1)*country;
        
        k=k+length(lon);
    end
    
    np=length(LON);
    
    ID=1:np;
    
    % write NETCDF source file
       ncfile=['../../sources_nc/parts_source_' num2str(y) '.nc'];
       ncid = netcdf.create(ncfile,'CLOBBER');
       p_dimID = netcdf.defDim(ncid,'x',np);
       netcdf.defVar(ncid,'id','NC_SHORT', p_dimID );
       netcdf.defVar(ncid,'lon','NC_FLOAT', p_dimID );
       netcdf.defVar(ncid,'lat','NC_FLOAT', p_dimID );
       netcdf.defVar(ncid,'releaseDate','NC_FLOAT', p_dimID );
       netcdf.defVar(ncid,'unsd','NC_SHORT', p_dimID );
       netcdf.endDef(ncid)
       
       netcdf.putVar(ncid, 0, int16(ID))
       netcdf.putVar(ncid, 1, LON)
       netcdf.putVar(ncid, 2, LAT)
       netcdf.putVar(ncid, 3, RdATE)
       netcdf.putVar(ncid, 4, UNSD)
       
       netcdf.close(ncid)
end