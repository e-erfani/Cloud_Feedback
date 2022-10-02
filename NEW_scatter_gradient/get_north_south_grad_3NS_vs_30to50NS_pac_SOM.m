function [grad_SST,tropical_SST,extratropical_SST]=get_north_south_grad_SOM(sst,lat,lon,GW)
%
% Adapted from popdiag_rel_20110902/idl_lib/sst_eq_pac_seasonal_cycle_diff.run
% 
% Calculates the difference between the area weighted average of 
%
%
II = find(isnan(sst)==1);
GW(II) = NaN;
% set tropical Pacific to 2
      mask=zeros(size(sst));
      J = find (lat>-3 & lat<3 & lon>130 & lon<280);
      mask(J)=2; clear J

      B = find (mask==2);
      tropical_SST=nansum(sst(B).*GW(B))./nansum(GW(B));
      clear B mask


% set extratropical Pacific to 2 
      mask=zeros(size(sst));
      J = find (lat<-30 & lat>-50 & lon>150 & lon<290);
      mask(J)=2; clear J
      J = find (lat>30 & lat<50 & lon>120 & lon<280);
      mask(J)=2; clear J

      B = find (mask==2);
      extratropical_SST=nansum(sst(B).*GW(B))./nansum(GW(B));
      clear B mask

      grad_SST = tropical_SST - extratropical_SST;





