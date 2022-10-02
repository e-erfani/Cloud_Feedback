function [u,v,p,lat,lon]=get_850winds(infile);

% ncl code template used
% Read in u and v fields
% 
%      v: Three-dimensional (lev,lat,lon) array of meridional wind 
%         values in which THE PRESSURE LEVEL DIMENSION MUST BE ORDERED
%        TOP TO BOTTOM. Units must be m s^-1. Type float.
%     READ
%	float V(time, lev, lat, lon) ;
%		V:mdims = 1 ;
%		V:units = "m/s" ;
%		V:long_name = "Meridional wind" ;
%		V:cell_methods = "time: mean" ;

%      u: Three-dimensional (lev,lat,lon) array of meridional wind 
%         values in which THE PRESSURE LEVEL DIMENSION MUST BE ORDERED
%        TOP TO BOTTOM. Units must be m s^-1. Type float.
%     READ
%	float U(time, lev, lat, lon) ;
%		U:mdims = 1 ;
%		U:units = "m/s" ;
%		U:long_name = "Zonal wind" ;
%		U:cell_methods = "time: mean" ;

%
%      p: One-dimensional array of pressure level values of vertical
%          dimension ORDERED TOP TO BOTTOM. Units must be Pa. Type float.
%          The first value must be greater than 500 Pa (5mb), and the
%          last value must be less than 100500 Pa (1005mb).
%
%       lat: One-dimensional array of latitude values of latitude dimension
%            in degrees. Type float.
%       READ
%	     double lat(lat) ;
%	     lat:long_name = "latitude" ;
%            lat:units = "degrees_north" ;
%
%       lon: One-dimensional array of latitude values of latitude dimension
%            in degrees. Type float.
%       READ
%	     double lon(lon) ;
%	     lat:long_name = "longitude" ;
%            lat:units = "degrees_east" ;
%
%       ps: Two-dimensional (lat,lon) array of surface pressures. Units
%           must be Pa. Type float.
%       READ
%	    float PS(time, lat, lon) ;
%		PS:units = "Pa" ;
%		PS:long_name = "Surface pressure" ;
%		PS:cell_methods = "time: mean" ;
% 	    double hyam(lev) ;
%		hyam:long_name = "hybrid A coefficient at layer midpoints" ;
%	    double hybm(lev) ;
%		hybm:long_name = "hybrid B coefficient at layer midpoints"

      ncid = netcdf.open(infile,'NOWRITE');

      varid = netcdf.inqVarID(ncid,'PS'); 
      PS = netcdf.getVar(ncid,varid,'double'); clear  varid 
      ps=permute(PS,[2 1]);

      lat1=ncread(infile,'lat');   
      lon1=ncread(infile,'lon');
      [lat,lon]=meshgrid(lat1,lon1); clear lon1 lat1
      
      A=ncread(infile,'hyam');
      B=ncread(infile,'hybm');

      P0 = 100000 ; % reference pressure in PA

      varid = netcdf.inqVarID(ncid,'V'); 
      V = netcdf.getVar(ncid,varid,'double'); clear  varid 
      v1=permute(V,[3 2 1]);
      
      varid = netcdf.inqVarID(ncid,'U'); 
      U = netcdf.getVar(ncid,varid,'double'); clear  varid 
      u1=permute(U,[3 2 1]);

      [K J I]=size(v1);
      for k=1:K
       for j=1:J
        for i=1:I 
           p1(k,j,i)=A(k).*P0+B(k).*ps(j,i);
        end
       end  
      end

      p2=[3000,5000,7000,10000,15000,20000,25000,30000,35000,40000,50000,55000,60000,...
       65000,70000,75000,80000,85000,87500,92500,95000,97500,100000];

       p=p2'; clear p2


       for j=1:J
        for i=1:I 
           %v2(:,j,i) = interp1(squeeze(p1(:,j,i)),squeeze(v1(:,j,i)),p);
           v2(:,j,i) = interp1(squeeze(p1(:,j,i)),squeeze(v1(:,j,i)),p,'linear','extrap');
           %u2(:,j,i) = interp1(squeeze(p1(:,j,i)),squeeze(u1(:,j,i)),p);
           u2(:,j,i) = interp1(squeeze(p1(:,j,i)),squeeze(u1(:,j,i)),p,'linear','extrap');
        end
       end  
  
      v=permute(v2,[3 2 1]);
      u=permute(u2,[3 2 1]);
      
  netcdf.close(ncid);
    


