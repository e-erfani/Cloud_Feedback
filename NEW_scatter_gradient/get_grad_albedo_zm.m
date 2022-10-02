function grad_albedo=get_grad_albedo(infile)
%
% Adapted from amwg_diag5.2/code/functions_surfaces.ncl
% gets TOA albedo = (SOLIN-FSNTOA)/SOLIN, units = dimensionless, 
%
      ncid = netcdf.open(infile,'NOWRITE');
      
      varid = netcdf.inqVarID(ncid,'FSNTOA'); % Net solar flux at top of atmosphere
      fsntoa = netcdf.getVar(ncid,varid,'double'); clear  varid 
      
      varid = netcdf.inqVarID(ncid,'SOLIN'); % Solar insolation
      solin = netcdf.getVar(ncid,varid,'double'); clear  varid       
      
      albedo = solin;
      albedo = (solin-fsntoa)./solin;
 
      lon=ncread(infile,'lon');
      lat=ncread(infile,'lat');

      gw=ncread(infile,'gw');
      I=length(lon);
      GW=repmat(gw,[1 I])';

      [lat_rho,lon_rho]=meshgrid(lat,lon); clear lon lat


      mask=zeros(size(albedo));
      % set tropics as 1
      J = find (lat_rho>-8 & lat_rho<8);
      mask(J)=1; clear J
      % set extra-tropics as 2
      J = find (lat_rho<-8 & lat_rho>-65);
      mask(J)=2; clear J
      J = find (lat_rho>8 & lat_rho<65);
      mask(J)=2; clear J

      % get tropical albedo
      B = find (mask==1);
      albedo_tropics=nansum(albedo(B).*GW(B))./nansum(GW(B));
      clear B

      % get extra tropical albedo
      B = find (mask==2);
      albedo_extratropics=nansum(albedo(B).*GW(B))./nansum(GW(B));
      clear B

      grad_albedo=albedo_extratropics-albedo_tropics;


      
    netcdf.close(ncid);
