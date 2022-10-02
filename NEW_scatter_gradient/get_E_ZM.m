function [PE_field_ZM,lat]=get_PmE_field(infile)

%
% Reads in the average precip field
% 
%	float PRECC(time, lat, lon) ;
%		PRECC:units = "m/s" ;
%		PRECC:long_name = "Convective precipitation rate (liq + ice)" ;
%		PRECC:cell_methods = "time: mean" ;
%	float PRECL(time, lat, lon) ;
%		PRECL:units = "m/s" ;
%		PRECL:long_name = "Large-scale (stable) precipitation rate (liq + ice)" ;
%		PRECL:cell_methods = "time: mean" ;
%	float QFLX(time, lat, lon) ;
%		QFLX:units = "kg/m2/s" ;
%		QFLX:long_name = "Surface water flux" ;
%		QFLX:cell_methods = "time: mean" ;
%


      ncid = netcdf.open(infile,'NOWRITE');
      
      varid = netcdf.inqVarID(ncid,'PRECC'); 
      precc = netcdf.getVar(ncid,varid,'double'); clear  varid 
      
      varid = netcdf.inqVarID(ncid,'PRECL'); 
      precl = netcdf.getVar(ncid,varid,'double'); clear  varid       
      
      precip_field =  precc + precl;
      
      varid = netcdf.inqVarID(ncid,'QFLX'); 
      evap = netcdf.getVar(ncid,varid,'double'); clear  varid     
      
      lat=ncread(infile,'lat');


% From amwg_diag5.2 > functions_surfaces.ncl
%      ep@long_name = "evap-precip"
%      ep@units = "mm/day"
%      ep@derive_op = "EP=QFLX*8.64e4-(PRECC+PRECL)*8.64e7"

% convert from m/s to mm/day
precip_field = precip_field.*1000.*60.*60.*24;

% convert from kg/m2/s to mm/day
evap_field = evap.*(1000.*60.*60.*24)./1000;

PE_field = evap_field;

PE_field_ZM=squeeze(mean(PE_field,1));

