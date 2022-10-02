function [T3,T3_area]=get_SST3_Tuo_25to65NS(infile);
%function [T3,T3_area]=get_T3(infile)
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

% Commented out because POP pac basin mask unlike CAM pac basin mask ends at 30S
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

TEMP=squeeze(TEMP1(:,:,1));

I=find(isnan(TEMP)==1);
area(I)=NaN;
clear ncid varid missing_value I 

      mask=zeros(size(TEMP));

      % set extratropical Pacific to 2 
      J = find (lat<-25 & lat>-65 & lon>130 & lon<280);
      mask(J)=2; clear J
      J = find (lat>25 & lat<65 & lon>130 & lon<280);
      mask(J)=2; clear J


B = find (mask==2);
T3 = nansum(TEMP(B).*area(B))./nansum(area(B));
T3_area=nansum(area(B));
clear mask B

%%%%%%
% dx along the Equator
%[I,J]=size(dx);
%for i=1:I
% j(i) = find (lat(i,:)>0 & lat(i,:)<0.4); 
%end

% j=50 
%lon_eq=lon(:,50);
%II = find (lon_eq>205 & lon_eq<280);
%T3_dx=nansum(dx(II,50));





