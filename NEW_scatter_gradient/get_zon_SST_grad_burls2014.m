function [dSST]=get_zon_SST_grad_burls2014(infile)
%
% 
% 
lon=ncread(infile,'TLONG');
lat=ncread(infile,'TLAT');
area=ncread(infile,'TAREA');
dx=ncread(infile,'DXT');
z=ncread(infile,'z_t');

ncid = netcdf.open(infile,'nowrite');
varid = netcdf.inqVarID(ncid,'TEMP');
missing_value = netcdf.getAtt(ncid,varid,'missing_value','double');
TEMP1=netcdf.getVar(ncid,varid,'double');

I=find(TEMP1==missing_value);
TEMP1(I)=NaN;
clear ncid varid missing_value I 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read BASIN MASK
ncid = netcdf.open(infile,'nowrite');
varid = netcdf.inqVarID(ncid,'REGION_MASK');
missing_value = netcdf.getAtt(ncid,varid,'missing_value','double');
REGION_MASK=netcdf.getVar(ncid,varid,'double');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[I J K]=size(TEMP1);
BASIN_MASK=repmat(REGION_MASK,[1 1 K]);

I=find(BASIN_MASK~=2);
TEMP1(I)=NaN;
clear I 

TEMP=squeeze(TEMP1(:,:,1));

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
