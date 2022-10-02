function [grad_SST,west_SST,east_SST]=get_east_west_grad(infile)
%
% Adapted from popdiag_rel_20110902/idl_lib/sst_eq_pac_seasonal_cycle_diff.run
%

lon=ncread(infile,'TLONG');
lat=ncread(infile,'TLAT');
area=ncread(infile,'TAREA');

ncid = netcdf.open(infile,'nowrite');
varid = netcdf.inqVarID(ncid,'TEMP');
missing_value = netcdf.getAtt(ncid,varid,'missing_value','double');
TEMP1=netcdf.getVar(ncid,varid,'double');

I=find(TEMP1==missing_value);
TEMP1(I)=NaN;
clear ncid varid missing_value I 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read BASIN MASK
%ncid = netcdf.open(infile,'nowrite');
%varid = netcdf.inqVarID(ncid,'REGION_MASK');
%missing_value = netcdf.getAtt(ncid,varid,'missing_value','double');
%REGION_MASK=netcdf.getVar(ncid,varid,'double');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%[I J K]=size(TEMP1);
%BASIN_MASK=repmat(REGION_MASK,[1 1 K]);

%I=find(BASIN_MASK~=2);
%TEMP1(I)=NaN;
%clear I 

%I=find(REGION_MASK~=2);
%area(I)=NaN;
%clear I

TEMP=squeeze(TEMP1(:,:,1));

I=find(isnan(TEMP)==1);
area(I)=NaN;
clear I
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mask1=zeros(size(TEMP));
J = find (lat>-3 & lat<3);
mask1(J)=1;

mask2=zeros(size(TEMP));
I = find (lon>140 & lon<160);
mask2(I)=1;

mask3=zeros(size(TEMP));
II = find (lon>260 & lon<280);
mask3(II)=1;

mask4=zeros(size(TEMP));
J = find (lat>-3 & lat<3);
mask4(J)=1;

mask=mask1+mask2;
B = find (mask==2);
%west_SST = nansum(TEMP(B).*area(B))./nansum(area(B));
west_SST = max(TEMP(B));
clear mask B

mask=mask3+mask4;
B = find (mask==2);
%east_SST = nansum(TEMP(B).*area(B))./nansum(area(B));
east_SST = min(TEMP(B));
clear mask B

grad_SST = west_SST-east_SST;