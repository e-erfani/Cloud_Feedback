clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient

sst_fcm = [18.78    18.08   18.20   18.32   18.52   19.31   20.63   23.11   24.41...
            16.6        16.53   16.51   16.53   16.53   16.6    16.61   16.59   16.6];

sst_som = [18.5 17.74   17.86   18      18.22   20.99   22.98   24.97   25.71...
    16.38       16.37   16.37   16.38   16.38   16.42   16.48   16.64   16.81];

%%%%
    aa=dir('*_tavg.*.nc');
    fname = aa(1,1).name;

for i = 1:10
    fname = aa(i,1).name;
    grad_SST = get_north_south_grad_3NS_vs_30to50NS_global(fname);
 
 Pac_meri_grad_UO_fcm_temp(i) = grad_SST;  
end
    
Pac_meri_grad_UO_fcm_temp(2) = [];
Pac_meri_grad_UO_fcm = Pac_meri_grad_UO_fcm_temp ;
nn = 2;
for i = 5:-1:2
  Pac_meri_grad_UO_fcm(nn) = Pac_meri_grad_UO_fcm_temp(i) ;
  nn = nn + 1 ;
end
%%%%

   aa=dir('sst_CO_sl*'); load('lat_msh_CAM.mat'); load('lon_msh_CAM.mat'); load('GW.mat')
   lat_msh_CAM = lat_msh_CAM'; 
   lon_msh_CAM = lon_msh_CAM'; 
    
for tt = 1:length(aa) ;
if     (tt==1); load(aa(tt,1).name); sst = sst_CO_sl_CO2_2; 
elseif (tt==2); load(aa(tt,1).name); sst = sst_CO_sl_ctrl; 
elseif (tt==3); load(aa(tt,1).name); sst = sst_CO_sl_ng_0_05; 
elseif (tt==4); load(aa(tt,1).name); sst = sst_CO_sl_ng_0_1; 
elseif (tt==5); load(aa(tt,1).name); sst = sst_CO_sl_ng_0_15; 
elseif (tt==6); load(aa(tt,1).name); sst = sst_CO_sl_ng_0_2; 
elseif (tt==7); load(aa(tt,1).name); sst = sst_CO_sl_ps_0_05; 
elseif (tt==8); load(aa(tt,1).name); sst = sst_CO_sl_ps_0_1; 
elseif (tt==9); load(aa(tt,1).name); sst = sst_CO_sl_ps_0_15; 
elseif (tt==10);load(aa(tt,1).name); sst = sst_CO_sl_ps_0_2; end

 sst = double(sst');
     grad_SST_SOM = get_north_south_grad_3NS_vs_30to50NS_global_SOM(sst,lat_msh_CAM,lon_msh_CAM,GW);


 dSST_m_temp(tt) = grad_SST_SOM;
end     

dSST_m_temp(2) = [];
nn = 2 ;
dSST_m = dSST_m_temp ;
for i = 5:-1:2
  dSST_m(nn) = dSST_m_temp(i) ;
  nn = nn + 1 ;
end
%%%%%%%
       fig_name = strcat('merid_grad_vs_GSST_3NSvs_30to50NS_glob_1800');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
      
    h1=plot(sst_fcm(1:9),Pac_meri_grad_UO_fcm,'o','markers',9); hold on
    set(h1,'MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',4)

    h2=plot(sst_som(1:9),dSST_m,'o','markers',9); hold on
    set(h2,'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',4)

    xlabel('Global SST (\circC)','fontsize',23,'fontweight','bold');
    ylabel('\DeltaT_m_e_r_i_d_i_o_n_a_l (\circC)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2],'FCM','SOM');
    set(gca,'Fontsize',20,'linewidth',1.5)
    set(hleg1,'Fontsize',16,'linewidth',1.5)

set(gca,'Fontsize',25,'linewidth',2)
box on
xlim([17 26])
%ylim([5.7 7.6])
%set(gca,'XTick',[17 18 19 20 21 22 23 24 25 26])
%set(gca,'YTick',24:2:40)
cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient
%  eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  
