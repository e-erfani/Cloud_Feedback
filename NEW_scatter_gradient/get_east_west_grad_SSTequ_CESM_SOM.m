function [grad_SST,west_SST,east_SST]=get_north_south_grad_SOM(sst,lat,lon,GW)
%
% Adapted from popdiag_rel_20110902/idl_lib/sst_eq_pac_seasonal_cycle_diff.run
% 
% Calculates the difference between the area weighted average of 
%
%
II = find(isnan(sst)==1);
GW(II) = NaN;
% set tropical Pacific to 2

mask1=zeros(size(sst));
J = find (lat>-3 & lat<3);
mask1(J)=1;

mask2=zeros(size(sst));
I = find (lon>140 & lon<160);
mask2(I)=1;

mask3=zeros(size(sst));
II = find (lon>260 & lon<280);
mask3(II)=1;

mask4=zeros(size(sst));
J = find (lat>-3 & lat<3);
mask4(J)=1;

mask=mask1+mask2;
B = find (mask==2);
%west_SST = nansum(sst(B).*GW(B))./nansum(GW(B));
west_SST = max(sst(B));
clear mask B

mask=mask3+mask4;
B = find (mask==2);
%east_SST = nansum(sst(B).*GW(B))./nansum(GW(B));
east_SST = min(sst(B));
clear mask B

grad_SST = west_SST-east_SST;