function [dSST]=get_zon_SST_grad_burls2014(TEMP, lat, lon, area)
%
% 

I=find(isnan(TEMP)==1);
area(I)=NaN;
clear ncid varid missing_value I 

mask1=zeros(size(TEMP));
J = find (lat>-8 & lat<8);
mask1(J)=1;

mask2=zeros(size(TEMP));
I = find (lon>130 & lon<205);
mask2(I)=1;

mask=mask1+mask2;
B = find (mask==2);
T1 = nansum(TEMP(B).*area(B))./nansum(area(B));
clear mask B mask1 mask2 J I
%%%

mask1=zeros(size(TEMP));
J = find (lat>-8 & lat<8);
mask1(J)=1;

mask2=zeros(size(TEMP));
I = find (lon>205 & lon<280);
mask2(I)=1;

mask=mask1+mask2;
B = find (mask==2);
T2 = nansum(TEMP(B).*area(B))./nansum(area(B));
clear mask B mask1 mask2 J I
dSST = T1 - T2 ;



