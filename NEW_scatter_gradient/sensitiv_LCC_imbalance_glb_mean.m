clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/NEW_scatter_gradient' ;
cd (address)


fname = {'chey_co2_2_rhminl_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
   'neg_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
  'neg_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
   'neg_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
  'neg_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
      'lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
       'lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
      'lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
      '2lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
               'chey_ctrl_rhminl_PreInd_T31_gx3v7.cam.h0.0471-0570._ANN_climo.nc'};
    
for i = 1:length(fname)
    infile = char(fname(:,i));
    lon=ncread(infile,'lon');
    lat=ncread(infile,'lat');
    gw=ncread(infile,'gw');
      I=length(lon);
    area = repmat(gw,[1 I])'; 
    area2 = area ; area3 = area;
    ncid = netcdf.open(infile,'nowrite');
    varid = netcdf.inqVarID(ncid,'CLDLOW');
    var=netcdf.getVar(ncid,varid,'double');
    varid2 = netcdf.inqVarID(ncid,'TS');
    var2=netcdf.getVar(ncid,varid2,'double');
    varid3 = netcdf.inqVarID(ncid,'FSNT');
    var3=netcdf.getVar(ncid,varid3,'double');
    varid4 = netcdf.inqVarID(ncid,'FLNT');
    var4=netcdf.getVar(ncid,varid4,'double');
    var5 = var3 - var4 ;
    
    clear varid varid2 varid3 varid4
    netcdf.close(ncid);

    II = find(isnan(var) == 1);
    area(II) = NaN;
    var_mean(i) = 100 .* nansum(nansum(var .* area,1),2) ./  nansum(nansum(area,1),2) ;
    JJ = find(isnan(var2) == 1);
    area2(JJ) = NaN;
    var2_mean(i) = nansum(nansum(var2 .* area2,1),2) ./  nansum(nansum(area2,1),2) - 273.15;
    KK = find(isnan(var5) == 1);
    area3(KK) = NaN;
    var5_mean(i) = nansum(nansum(var5 .* area3,1),2) ./  nansum(nansum(area3,1),2) ;
    
end
  
 sens = var2_mean - var2_mean(end) ;