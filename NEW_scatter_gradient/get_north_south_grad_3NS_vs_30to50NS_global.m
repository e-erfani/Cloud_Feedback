function [grad_SST,tropical_SST,extratropical_SST]=get_north_south_grad(infile)
%
% Adapted from popdiag_rel_20110902/idl_lib/sst_eq_pac_seasonal_cycle_diff.run
% 
% Calculates the difference between the area weighted average of 
%
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

      mask=zeros(size(TEMP));

     % set tropcial to 1
       J = find (lat>-3 & lat<3);
      mask(J)=1; clear J
      % set extratropical to 2 
      J = find (lat<-30 & lat>-50);
      mask(J)=2; clear J
      J = find (lat>30 & lat<50);
      mask(J)=2; clear J


      % get tropical albedo
      B = find (mask==1);
      tropical_SST=nansum(TEMP(B).*area(B))./nansum(area(B));
      clear B

      % get extratropical albedo
      B = find (mask==2);
      extratropical_SST=nansum(TEMP(B).*area(B))./nansum(area(B));
      clear B

      grad_SST = tropical_SST - extratropical_SST;






