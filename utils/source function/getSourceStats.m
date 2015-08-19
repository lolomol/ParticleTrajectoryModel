UNSDlist=[8;12;24;32;36;44;48;50;52;56;70;76;84;90;96;100;104;116;120;124;132;144;152;156;170;174;178;180;188;191;192;196;204;208;214;218;222;226;232;233;242;246;250;258;262;266;268;270;276;288;300;312;316;320;324;328;332;340;344;352;356;360;364;368;372;376;380;384;388;392;400;404;408;410;414;422;428;430;434;440;446;450;458;462;470;474;478;480;484;504;508;512;516;528;530;540;548;554;558;566;578;586;591;598;604;608;616;620;624;626;630;634;638;642;643;682;686;694;702;704;705;706;710;724;736;740;752;760;764;768;780;784;788;792;804;818;826;834;840;858;862;882;887;];

UNSDstats=zeros(length(UNSDlist)+1,length(1990:2015)+1);
UNSDstats(1,2:end)=1990:2015;
UNSDstats(2:end,1)=UNSDlist;

k=1;
for y=1990:2015
    ncfile=['../../sources_nc/parts_source_' num2str(y) '.nc'];
    ncid = netcdf.open(ncfile,'NOWRITE');
    unsd=netcdf.getVar(ncid,4);
    netcdf.close(ncid)
    
    k=k+1;
    for c=1:length(UNSDlist)
        unsd_count = sum(unsd==UNSDlist(c));
        UNSDstats(c+1,k) = unsd_count;
    end
end
    
dlmwrite('ParticleCount_Country_year.txt',UNSDstats,'delimiter','\t')
    