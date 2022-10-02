function [meridional_SST_SOM,lat_SOM]=get_meridional_SST_SOM(sst,lat_msh_CAM,lon_msh_CAM)
%
%
%

[SST_reg(:,:), SST_refvec(:,:)] = geoloc2grid(lat_msh_CAM,lon_msh_CAM,sst,1); 

lat_SOM=-79:1:90;
%lat=-90:1:90;
lon_SOM=0:1:359;

 [J I]=size(SST_reg);

 meridional_SST_1=squeeze(nanmean(SST_reg'));
 meridional_SST_SOM=meridional_SST_1';
 for i=1:6
   meridional_SST_SOM(i) = [];
 end




