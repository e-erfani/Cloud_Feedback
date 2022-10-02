clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient
  aa=dir('*_tavg.*.nc');
  aa2=dir('sst_CO_sl*'); load('lat_msh_CAM.mat'); load('lon_msh_CAM.mat'); load('GW.mat');

 fname_fcm = {'chey_co2_2_rhminl_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
   'neg_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
  'neg_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
   'neg_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
  'neg_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
      'lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
       'lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
      'lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
      '2lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc'};

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
    dSST_zonal_fcm = get_zon_SST_grad_burls2014(fname);
    dSST_fcm_temp(i) = dSST_zonal_fcm;  
end
    
dSST_fcm_temp(2) = [];
dSST_fcm = dSST_fcm_temp ;
nn = 2;
for i = 5:-1:2
  dSST_fcm(nn) = dSST_fcm_temp(i) ;
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
    dSST_zonal_som = get_zon_SST_grad_SOM_burls2014(sst, lat_msh_CAM, lon_msh_CAM, GW);
    dSST_som_temp(tt) = dSST_zonal_som;  

end     

dSST_som_temp(2) = [];
nn = 2 ;
dSST_som = dSST_som_temp ;
for i = 5:-1:2
  dSST_som(nn) = dSST_som_temp(i) ;
  nn = nn + 1 ;
end

%%% graident albedo
for i = 1:9
    grad_albedo2 = get_grad_albedo(char(fname_som(:,i)));
    grad_albedo_som(i) = grad_albedo2 ;
end

%%%%%%%
       fig_name = strcat('merid_albedo_zon_SST_grad_PACIFIC_1800');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.1,0.1,11,11]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
      
    h1=plot(grad_albedo_fcm,dSST_fcm,'o','markers',13); hold on
    set(h1,'MarkerEdgeColor','k','MarkerFaceColor','b','LineWidth',1)

    h2=plot(grad_albedo_som,dSST_som,'o','markers',13); hold on
    set(h2,'MarkerEdgeColor','k','MarkerFaceColor','r','LineWidth',1)

   x = xlabel('\Delta{\alpha}_m_e_r_i_d_i_o_n_a_l','fontsize',23,'fontweight','bold');
   y = ylabel('\DeltaT_z_o_n_a_l (\circC)','fontsize',23,'fontweight','bold');
   set(x, 'Units', 'Normalized', 'Position', [0.5, -0.085, 0]);
  % set(y, 'Units', 'Normalized', 'Position', [-0.05, 0.5, 0]);
   hleg1 = legend([h1 h2],'FCM','SOM','location','northwest');
    set(gca,'Fontsize',20,'linewidth',1.5)
    set(hleg1,'Fontsize',20,'linewidth',1.5)
set(gca,'Fontsize',22,'linewidth',2)
box on
xlim([-0.05 0.04])
ylim([0.6 2.6])
%set(gca,'XTick',[17 18 19 20 21 22 23 24 25 26])
set(gca,'YTick',0.6:0.4:2.6)
cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient
%  eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  
%%%%%%
sst_fcm = [18.78    18.08   18.20   18.32   18.52   19.31   20.63   23.11   24.41...
            16.6	16.53	16.51	16.53	16.53	16.6	16.61	16.59	16.6];

sst_som = [18.5     17.74	17.86	18      18.22	20.99	22.98	24.97	25.71...
           16.38	16.37	16.37	16.38	16.38	16.42	16.48	16.64	16.81];

       fig_name = strcat('zonal_grad_vs_GSST_Burls17_1800');%,num2str(tt));
        fig_dum = figure(2);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.1,0.1,11,11]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
      
    h1=plot(sst_fcm(1:9),dSST_fcm,'o','markers',13); hold on
    set(h1,'MarkerEdgeColor','k','MarkerFaceColor','b','LineWidth',1)

    h2=plot(sst_som(1:9),dSST_som,'o','markers',13); hold on
    set(h2,'MarkerEdgeColor','k','MarkerFaceColor','r','LineWidth',1)

   x = xlabel('Global SST (\circC)','fontsize',23,'fontweight','bold');
   y = ylabel('\DeltaT_z_o_n_a_l (\circC)','fontsize',23,'fontweight','bold');
   set(x, 'Units', 'Normalized', 'Position', [0.5, -0.085, 0]);
   hleg1 = legend([h1 h2],'FCM','SOM');
    set(hleg1,'Fontsize',20,'linewidth',1.5)
set(gca,'Fontsize',22,'linewidth',2)
box on
xlim([17 26])
ylim([0.6 2.6])
%set(gca,'XTick',[17 18 19 20 21 22 23 24 25 26])
set(gca,'YTick',0.6:0.4:2.6)
%  eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
         