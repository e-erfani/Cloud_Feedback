clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/NEW_scatter_gradient' ;
cd (address)
    aa=dir('*_tavg.*.nc');
    
for i = 1:10
    infile = aa(i,1).name;
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

    sst=squeeze(TEMP1(:,:,1));
    II = find(isnan(sst) == 1);
    area(II) = NaN;
    sst_mean(i) = nansum(nansum(sst .* area,1),2) ./  nansum(nansum(area,1),2) ;
 end
  