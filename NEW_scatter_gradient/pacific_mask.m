function pacific_mask=pacific_mask(infile);
%
% from functions_transport.ncl
% creates mask file for the pacific, atlantic and indian ocean basins
% oro: orography data array (lat,lon)
% assumes that lat and lon are attached to oro as coordinates,
% and oro has values 100% ocean = 1 land = 0
%

      ncid = netcdf.open(infile,'NOWRITE');
      
      varid = netcdf.inqVarID(ncid,'OCNFRAC'); % 
      oro_field = netcdf.getVar(ncid,varid,'double'); clear  varid 

      oro = oro_field-1;

      lon=ncread(infile,'lon');
      lat=ncread(infile,'lat');

      nlat = length(lat);
      nlon = length(lon);

 % make 2D mask array for ocean grid points
 pacific_mask = zeros(size(oro));

 % pacific_mask = "(1)pacific (2)atlantic (3)indian"

 % Pacific ocean basin
 for j = 1:nlat
   for i = 1:nlon
     if (oro(i,j)>-1) 
       if lon(i)>100.0 & lon(i)<260.0 & lat(j)<65.0 & lat(j)>15.0
          pacific_mask(i,j) = 1;  %pacific   
       elseif lon(i)>100.0 & lon(i)<275.0 & lat(j)<= 15.0 & lat(j)> 10.0 
          pacific_mask(i,j) = 1;  %pacific 
       elseif lon(i)>100.0 & lon(i)<290.0 & lat(j)<= 10.0 & lat(j)> -5.0 
          pacific_mask(i,j) = 1;  %pacific 
       elseif lon(i)>=130.0 & lon(i)<=290.0 & lat(j)<= -5.0
          pacific_mask(i,j) = 1;  %pacific 
       end 
     end 
   end
 end 

 for j = 1:nlat
     if lat(j)< -65.0
          pacific_mask(:,j) = 0;  %mask poleward of 65S 
     end
 end




