function [T1,T1_area]=get_SST1_Tuo_SOM(sst,lat,lon,GW)
%

I=find(isnan(sst)==1);
GW(I)=NaN;
clear I 

mask1=zeros(size(sst));
J = find (lat>-8 & lat<8);
mask1(J)=1;

mask2=zeros(size(sst));
I = find (lon>130 & lon<205);
mask2(I)=1;

mask=mask1+mask2;
B = find (mask==2);
T1 = nansum(sst(B).*GW(B))./nansum(GW(B));
T1_area=nansum(GW(B));
clear mask B
