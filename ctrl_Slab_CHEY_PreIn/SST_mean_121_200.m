    clc
    clear
path(path,'/homes/eerfani/Bias/m_map') 

cd /shared/SWFluxCorr/CESM/ctrl_Slab_CHEY_PreIn

%    aa1=dir('ctrl_Slab_CHEY_PreInd_T31_gx3v7_ANN_climo.nc');
    aa1=dir('ctrl_Slab_CHEY_PreInd_T31_gx3v7.cam.h0.*.anmn.nc');
    tt1=1; % ncdisp(aa(tt,1).name)
    filename1=aa1(tt1,1).name;
  gw=ncread(filename1,'gw'); % surface net Shortwave Radiation (W/m2)
    latitude =ncread(filename1,'lat');
    longitude =ncread(filename1,'lon');
[lon_msh,lat_msh] = meshgrid(longitude,latitude);

      I=length(longitude);
      GW=repmat(gw,[1 I])';
nn = 0;
for tt1 = 21:100
   nn = nn + 1 ;
   filename1=aa1(tt1,1).name;
   SST=ncread(filename1,'SST'); % Downwelling solar flux at surface (W/m2)
   SST(SST > 1E4) = NaN;
   SST(SST < 1E2) = NaN;
   SST_all(:,:,nn) = SST ;
end
SST_mn = nanmean(SST_all,3) ;
    II=find(isnan(SST_mn)==1);
    GW2 = GW ;
    GW2(II)=nan;
 SW_glb_mean = nansum(nansum(GW2 .* SST_mn,1),2) ./ nansum(nansum(GW2,1),2)   
