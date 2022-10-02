function [T2,T2_area,T2_dx]=get_SST2_Tuo(infile)
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
netcdf.close(ncid);
clear ncid varid missing_value I 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Read BASIN MASK
ncid = netcdf.open(infile,'nowrite');
varid = netcdf.inqVarID(ncid,'REGION_MASK');
missing_value = netcdf.getAtt(ncid,varid,'missing_value','double');
REGION_MASK=netcdf.getVar(ncid,varid,'double');
netcdf.close(ncid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[I J K]=size(TEMP1);
BASIN_MASK=repmat(REGION_MASK,[1 1 K]);

I=find(BASIN_MASK~=2);
TEMP1(I)=NaN;
clear I 

TEMP=squeeze(TEMP1(:,:,1));

I=find(isnan(TEMP)==1);
area(I)=NaN;
dx(I)=NaN;
clear ncid varid missing_value I 

mask1=zeros(size(TEMP));
J = find (lat>-8 & lat<8);
mask1(J)=1;

mask3=zeros(size(TEMP));
II = find (lon>205 & lon<280);
mask3(II)=1;

mask=mask1+mask3;
B = find (mask==2);
T2 = nansum(TEMP(B).*area(B))./nansum(area(B));
T2_area =nansum(area(B));
clear mask B II

%%%%%%
% dx along the Equator
%[I,J]=size(dx);
%for i=1:I
% j(i) = find (lat(i,:)>0 & lat(i,:)<0.4); 
%end

% j=50 
lon_eq=lon(:,50);
II = find (lon_eq>205 & lon_eq<280);
T2_dx=nansum(dx(II,50));




