function [T2,T2_area]=get_SST1_Tuo_SOM(sst,lat,lon,GW)
%

I=find(isnan(sst)==1);
GW(I)=NaN;
clear ncid varid missing_value I 

mask1=zeros(size(sst));
J = find (lat>-8 & lat<8);
mask1(J)=1;

mask3=zeros(size(sst));
II = find (lon>205 & lon<280);
mask3(II)=1;

mask=mask1+mask3;
B = find (mask==2);
T2 = nansum(sst(B).*GW(B))./nansum(GW(B));
T2_area =nansum(GW(B));
clear mask B II
