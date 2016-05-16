function writeAsciiRaster(filename,LAT,LON,X)
% LAT=LAT;
% LON=LON;
% X=AveDailyVisits;
% filename='C:\Users\lolo\Documents\TheOceanCleanup\work\oceanloads\coastal_0_1p_AveDailyVisits_1993-2012.ascii';


fid=fopen(filename,'w');
fprintf(fid,'ncols         %.f\r\n', length(LON));
fprintf(fid,'nrows         %.f\r\n', length(LAT));
fprintf(fid,'xllcorner     %.3f\r\n',min(LON));
fprintf(fid,'yllcorner     %.3f\r\n',min(LAT));
fprintf(fid,'cellsize      %.3f\r\n',abs(LAT(1)-LAT(2)));
fprintf(fid,'NODATA_value  -9999\r\n');

for i=1:size(X,1)
    fprintf(fid,'%g ',X(i,:));
    fprintf(fid,'\r\n');
end
fclose(fid);