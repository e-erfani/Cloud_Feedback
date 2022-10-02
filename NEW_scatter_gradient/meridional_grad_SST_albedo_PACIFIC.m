clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient
  aa=dir('*_tavg.*.nc');
  aa2=dir('sst_CO_sl*'); load('lat_msh_CAM.mat'); load('lon_msh_CAM.mat');

 fname_fcm = {'chey_co2_2_rhminl_PreInd_T31_gx3v7.cam.h0.1001-1100._ANN_climo.nc',...
   'neg_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0991-1090._ANN_climo.nc',...
  'neg_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0991-1090._ANN_climo.nc',...
   'neg_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0991-1090._ANN_climo.nc',...
  'neg_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0991-1090._ANN_climo.nc',...
      'lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.1001-1100._ANN_climo.nc',...
       'lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.1001-1100._ANN_climo.nc',...
      'lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.1001-1100._ANN_climo.nc',...
      '2lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.1001-1100._ANN_climo.nc'};

        fname_som = {'co2_Slab_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
 'neg_Slab_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
'neg_Slab_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
 'neg_Slab_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
'neg_Slab_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
    'Slab_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
     'Slab_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
    'Slab_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
     'Slab_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc'};
  
%%%% meridional SST
    fname = aa(1,1).name;
for i = 1:10
    fname = aa(i,1).name;
    [SST_ZM,lat_ZM] = get_meridional_SST(fname);
    lat_ZM = lat_ZM' ;
    SST_struct=abs((nansum(SST_ZM(30:74)-mean(SST_ZM(75:85)))./length(lat_ZM(30:74))...
        +nansum(SST_ZM(86:130)-mean(SST_ZM(75:85)))./length(lat_ZM(86:130)))./2);
 
 Pac_meri_grad_UO_fcm_temp(i) = SST_struct;  
end
    
Pac_meri_grad_UO_fcm_temp(2) = [];
Pac_meri_grad_UO_fcm = Pac_meri_grad_UO_fcm_temp ;
nn = 2;
for i = 5:-1:2
  Pac_meri_grad_UO_fcm(nn) = Pac_meri_grad_UO_fcm_temp(i) ;
  nn = nn + 1 ;
end

%%%% meridional albedo
for i = 1:9
    grad_albedo = get_grad_albedo(char(fname_fcm(:,i)));
    grad_albedo_fcm(i) = grad_albedo ;
end

%%%%

   lat_msh_CAM = lat_msh_CAM'; 
   lon_msh_CAM = lon_msh_CAM'; 
    
for tt = 1:length(aa2) ;
if     (tt==1); load(aa2(tt,1).name); sst = sst_CO_sl_CO2_2; 
elseif (tt==2); load(aa2(tt,1).name); sst = sst_CO_sl_ctrl; 
elseif (tt==3); load(aa2(tt,1).name); sst = sst_CO_sl_ng_0_05; 
elseif (tt==4); load(aa2(tt,1).name); sst = sst_CO_sl_ng_0_1; 
elseif (tt==5); load(aa2(tt,1).name); sst = sst_CO_sl_ng_0_15; 
elseif (tt==6); load(aa2(tt,1).name); sst = sst_CO_sl_ng_0_2; 
elseif (tt==7); load(aa2(tt,1).name); sst = sst_CO_sl_ps_0_05; 
elseif (tt==8); load(aa2(tt,1).name); sst = sst_CO_sl_ps_0_1; 
elseif (tt==9); load(aa2(tt,1).name); sst = sst_CO_sl_ps_0_15; 
elseif (tt==10);load(aa2(tt,1).name); sst = sst_CO_sl_ps_0_2; end

 sst = double(sst');
 [SST_ZM_SOM,lat_ZM_SOM]=get_meridional_SST_SOM(sst,lat_msh_CAM,lon_msh_CAM);
     lat_ZM_SOM = lat_ZM_SOM' ;
    SST_struct_SOM=abs((nansum(SST_ZM_SOM(30:74)-mean(SST_ZM_SOM(75:85)))./length(lat_ZM_SOM(30:74))...
        +nansum(SST_ZM_SOM(86:130)-mean(SST_ZM_SOM(75:85)))./length(lat_ZM_SOM(86:130)))./2);

 dSST_m_temp(tt) = SST_struct_SOM;
end     

dSST_m_temp(2) = [];
nn = 2 ;
dSST_m = dSST_m_temp ;
for i = 5:-1:2
  dSST_m(nn) = dSST_m_temp(i) ;
  nn = nn + 1 ;
end

%%% graident albedo
for i = 1:9
    grad_albedo2 = get_grad_albedo(char(fname_som(:,i)));
    grad_albedo_som(i) = grad_albedo2 ;
end

%%%%%%%
       fig_name = strcat('ZM_meridional_grad_SST_vs_albedo');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
      
    h1=plot(grad_albedo_fcm,Pac_meri_grad_UO_fcm,'o','markers',9); hold on
    set(h1,'MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',4)

    h2=plot(grad_albedo_som,dSST_m,'o','markers',9); hold on
    set(h2,'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',4)

    xlabel('\Deltaalbedo_m_e_r_i_d_i_o_n_a_l','fontsize',23,'fontweight','bold');
    ylabel('\DeltaT_m_e_r_i_d_i_o_n_a_l (\circC)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2],'FCM','SOM');
    set(gca,'Fontsize',20,'linewidth',1.5)
    set(hleg1,'Fontsize',16,'linewidth',1.5)

set(gca,'Fontsize',25,'linewidth',2)
box on
%xlim([17 26])
%ylim([5.7 7.6])
%set(gca,'XTick',[17 18 19 20 21 22 23 24 25 26])
%set(gca,'YTick',24:2:40)
cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient
  eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  