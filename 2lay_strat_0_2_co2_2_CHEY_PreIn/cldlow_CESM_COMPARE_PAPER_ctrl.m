clc 
clear
path(path,'/homes/eerfani/Bias/m_map')  
path(path,'/homes/eerfani/DrosteEffect-BrewerMap-04533de') 
path(path,'/homes/eerfani/tight_subplot') 

cd /shared/SWFluxCorr/CESM/2lay_strat_0_2_co2_2_CHEY_PreIn

    aa1=dir('lay*cam.h0.*.anmn.nc');
    tt1=1; % ncdisp(aa(tt,1).name)
    filename1=aa1(tt1,1).name;
  gw=ncread(filename1,'gw'); % surface net Shortwave Radiation (W/m2)
    latitude =ncread(filename1,'lat');
    longitude =ncread(filename1,'lon');
[lat_msh,lon_msh] = meshgrid(latitude,longitude);
      I=length(longitude);
      TAREA=repmat(gw,[1 I])';

for i = 4:23
    filename1=aa1(i,1).name;
    var_all(:,:,i) = ncread(filename1,'CLDLOW') .* 100;	
end

var_mean = nanmean(var_all,3);

cd ../chey_co2_2_rhminl_PreIn
    aa2=dir('*cam.h0.*.anmn.nc');
for i = 4:23
    filename2=aa2(i,1).name;
    var_all2(:,:,i) = ncread(filename2,'CLDLOW') .* 100;
end

var_mean_2_co2 = nanmean(var_all2,3);

diff = var_mean - var_mean_2_co2;
TAREA2 = TAREA;
TAREA2(isnan(var_mean) == 1) = NaN;

diff_glb = nansum(nansum(diff .* TAREA2)) ./ nansum(nansum(TAREA))

