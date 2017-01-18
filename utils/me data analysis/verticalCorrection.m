%% vertCorr routine
%
% use Kukulka & rising speed 
% computes correction 
% creates new shapefile "filename"_vertCorr.shp
%
% adapt pathname below

shpname='C:\Users\laure\Desktop\MEdata\TrawlDataset_2_2';

%
%
%
%
%% no edit below



S=shaperead(shpname);

K=loadKukulka;

for i=1:length(S)
   S(i).cd1_h_s = S(i).cd1_h_s / K(1).k( S(i).seaState+1 , 1); 
   S(i).cd1_l_n = S(i).cd1_l_n / K(2).k( S(i).seaState+1 , 1); 
   S(i).cd1_pel = S(i).cd1_pel / K(3).k( S(i).seaState+1 , 1); 
   S(i).cd1_foa = S(i).cd1_foa / K(4).k( S(i).seaState+1 , 1); 
   S(i).wd1_h_s = S(i).wd1_h_s / K(1).k( S(i).seaState+1 , 1); 
   S(i).wd1_l_n = S(i).wd1_l_n / K(2).k( S(i).seaState+1 , 1); 
   S(i).wd1_pel = S(i).wd1_pel / K(3).k( S(i).seaState+1 , 1); 
   S(i).wd1_foa = S(i).wd1_foa / K(4).k( S(i).seaState+1 , 1); 
   S(i).cd1_all = S(i).cd1_h_s + S(i).cd1_l_n  + S(i).cd1_pel + S(i).cd1_foa;
   S(i).wd1_all = S(i).wd1_h_s + S(i).wd1_l_n  + S(i).wd1_pel + S(i).wd1_foa;
   
   S(i).cd2_h_s = S(i).cd2_h_s / K(1).k( S(i).seaState+1 , 2); 
   S(i).cd2_l_n = S(i).cd2_l_n / K(2).k( S(i).seaState+1 , 2); 
   S(i).cd2_pel = S(i).cd2_pel / K(3).k( S(i).seaState+1 , 2); 
   S(i).cd2_foa = S(i).cd2_foa / K(4).k( S(i).seaState+1 , 2); 
   S(i).wd2_h_s = S(i).wd2_h_s / K(1).k( S(i).seaState+1 , 2); 
   S(i).wd2_l_n = S(i).wd2_l_n / K(2).k( S(i).seaState+1 , 2); 
   S(i).wd2_pel = S(i).wd2_pel / K(3).k( S(i).seaState+1 , 2); 
   S(i).wd2_foa = S(i).wd2_foa / K(4).k( S(i).seaState+1 , 2); 
   S(i).cd2_all = S(i).cd2_h_s + S(i).cd2_l_n  + S(i).cd2_pel + S(i).cd2_foa;
   S(i).wd2_all = S(i).wd2_h_s + S(i).wd2_l_n  + S(i).wd2_pel + S(i).wd2_foa;
   
   S(i).cd_all= S(i).cd1_all + S(i).cd2_all;
   S(i).wd_all= S(i).wd1_all + S(i).wd2_all;
end


shapewrite(S,[shpname '_vertCorr']);