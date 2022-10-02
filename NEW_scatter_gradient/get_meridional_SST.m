function [meridional_SST,lat]=get_meridional_SST(infile)
%
%
%
lon_rho=ncread(infile,'TLONG');
lat_rho=ncread(infile,'TLAT');
area=ncread(infile,'TAREA');

ncid = netcdf.open(infile,'nowrite');
varid = netcdf.inqVarID(ncid,'TEMP');
missing_value = netcdf.getAtt(ncid,varid,'missing_value','double');
TEMP1=netcdf.getVar(ncid,varid,'double');

I=find(TEMP1==missing_value);
TEMP1(I)=NaN;
clear varid missing_value I
netcdf.close(ncid);

TEMP=squeeze(TEMP1(:,:,1));

[SST_reg(:,:), SST_refvec(:,:)] = geoloc2grid(lat_rho,lon_rho,TEMP,1); 

lat=-79:1:90;
%lat=-90:1:90;
lon=0:1:359;

 [J I]=size(SST_reg);

 meridional_SST_1=squeeze(nanmean(SST_reg'));
 meridional_SST=meridional_SST_1';





