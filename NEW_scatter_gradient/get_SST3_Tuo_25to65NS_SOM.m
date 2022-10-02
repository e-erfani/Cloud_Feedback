function [T3,T3_area]=get_SST3_Tuo_25to65NS_SOM(sst,lat,lon,GW)
%

I=find(isnan(sst)==1);
GW(I)=NaN;
clear ncid varid missing_value I 

      mask=zeros(size(sst));

      % set extratropical Pacific to 2 
      J = find (lat<-25 & lat>-65 & lon>130 & lon<280);
      mask(J)=2; clear J
      J = find (lat>25 & lat<65 & lon>130 & lon<280);
      mask(J)=2; clear J


B = find (mask==2);
T3 = nansum(sst(B).*GW(B))./nansum(GW(B));
T3_area=nansum(GW(B));
clear mask B
