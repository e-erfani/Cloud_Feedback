function [grad_SST,tropical_SST,extratropical_SST]=get_north_south_grad_SOM(sst,lat,lon,GW)
%
% Adapted from popdiag_rel_20110902/idl_lib/sst_eq_pac_seasonal_cycle_diff.run
% 
% Calculates the difference between the area weighted average of 
%
%
II = find(isnan(sst)==1);
GW(II) = NaN;

      mask=zeros(size(sst));

     % set tropcial to 1
       J = find (lat>-8 & lat<8);
      mask(J)=1; clear J
      % set extratropical to 2 
      J = find (lat<-30 & lat>-50);
      mask(J)=2; clear J
      J = find (lat>30 & lat<50);
      mask(J)=2; clear J


      % get tropical albedo
      B = find (mask==1);
      tropical_SST=nansum(sst(B).*GW(B))./nansum(GW(B));
      clear B

      % get extratropical albedo
      B = find (mask==2);
      extratropical_SST=nansum(sst(B).*GW(B))./nansum(GW(B));
      clear B

      grad_SST = tropical_SST - extratropical_SST;






