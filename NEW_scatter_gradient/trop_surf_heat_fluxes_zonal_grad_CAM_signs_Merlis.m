clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient
  fname_fcm = {'chey_ctrl_rhminl_PreInd_T31_gx3v7.cam.h0.0471-0570._ANN_climo.nc',...
              'chey_co2_2_rhminl_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
   'neg_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
  'neg_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
   'neg_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
  'neg_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
      'lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
       'lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
      'lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
      '2lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc'};

       fname_som = {'ctrl_Slab_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
                     'co2_Slab_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
 'neg_Slab_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
'neg_Slab_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
 'neg_Slab_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
'neg_Slab_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
    'Slab_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
     'Slab_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
    'Slab_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
     'Slab_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc'};

 fig_name_fcm = {'fl_ctrl','fl_2_CO2','fl_ng_0_20','fl_ng_0_15','fl_ng_0_10','fl_ng_0_05',...
     'fl_ps_0_05','fl_ps_0_10','fl_ps_0_15','fl_ps_0_20'};
  fig_name_som = {'sl_ctrl','sl_2_CO2','sl_ng_0_20','sl_ng_0_15','sl_ng_0_10','sl_ng_0_05',...
     'sl_ps_0_05','sl_ps_0_10','sl_ps_0_15','sl_ps_0_20'};
 
%%%% FCM
for i = 1:10
    fname = char(fname_fcm(:,i));
       
    lon1=ncread(fname,'lon'); 
    lat1=ncread(fname,'lat');
     [lat,lon]=meshgrid(lat1,lon1);    
    gw=ncread(fname,'gw');
     I=length(lon1);
     area=repmat(gw,[1 I])';
    LATH_F=-ncread(fname,'LHFLX'); 
    SENH_F=-ncread(fname,'SHFLX');
    SW_N=ncread(fname,'FSNS'); % Net Solar Short-Wave Heat Flux
    LW_N=-ncread(fname,'FLNS');
    
    LATH_F(-LATH_F > 1.0E+30) = NaN; SENH_F(-SENH_F > 1.0E+30) = NaN;  
    SW_N(SW_N > 1.0E+30) = NaN; LW_N(-LW_N > 1.0E+30) = NaN;   
    NET = - SW_N - LW_N - SENH_F - LATH_F ;
    I = find(isnan(SW_N) == 1);
    area(I) = NaN;    
    % set tropical Pacific to 2
      mask=zeros(size(SW_N));
      J = find (lat>-8 & lat<8 & lon>130 & lon<205);
      mask(J)=2; clear J
      B = find (mask==2);
      SW_N_1=nansum(SW_N(B).*area(B))./nansum(area(B));
      LW_N_1=nansum(LW_N(B).*area(B))./nansum(area(B));
      SENH_F_1=nansum(SENH_F(B).*area(B))./nansum(area(B));
      LATH_F_1=nansum(LATH_F(B).*area(B))./nansum(area(B));
      NET_1=nansum(NET(B).*area(B))./nansum(area(B));
      clear B mask
    % set extratropical Pacific to 2 
      mask=zeros(size(SW_N));
      J = find (lat>-8 & lat<8 & lon>205 & lon<280);
      mask(J)=2; clear J
      B = find (mask==2);
      SW_N_2=nansum(SW_N(B).*area(B))./nansum(area(B));
      LW_N_2=nansum(LW_N(B).*area(B))./nansum(area(B));
      SENH_F_2=nansum(SENH_F(B).*area(B))./nansum(area(B));
      LATH_F_2=nansum(LATH_F(B).*area(B))./nansum(area(B));
      NET_2=nansum(NET(B).*area(B))./nansum(area(B));
      clear B mask

      d_SW_N(i) = SW_N_1 - SW_N_2;
      d_LW_N(i) = LW_N_1 - LW_N_2;
      d_SENH_F(i) = SENH_F_1 - SENH_F_2;
      d_LATH_F(i) = LATH_F_1 - LATH_F_2;
      d_NET(i) = NET_1 - NET_2;  
end
    
    %%%%% 
    exp_fcm = 1:10 ;
      fig_name = strcat('ht_flx_zonal_grad_CAM_FCM_signs_Merlis');%,num2str(tt));
      fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,12,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
      
    h1=plot(exp_fcm,d_SW_N,'o','markers',13); hold on
    set(h1,'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',1)
    h2=plot(exp_fcm,d_LATH_F,'o','markers',13); hold on
    set(h2,'MarkerEdgeColor','k','MarkerFaceColor','b','LineWidth',1)
    h4=plot(exp_fcm,d_LW_N,'o','markers',13); hold on
    set(h4,'MarkerEdgeColor','k','MarkerFaceColor','g','LineWidth',1)
    h5=plot(exp_fcm,d_SENH_F,'o','markers',13); hold on
    set(h5,'MarkerEdgeColor','k','MarkerFaceColor','c','LineWidth',1)
    h6=plot(exp_fcm,d_NET,'o','markers',13); hold on
    set(h6,'MarkerEdgeColor','k','MarkerFaceColor','r','LineWidth',1)

    xlabel('Experiment #','fontsize',23,'fontweight','bold');
    ylabel('Zonal Gradient of Energy Flux (W m^-^2)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2 h4 h5 h6],'net SW','latent','net LW','sensible','net flux');
    set(gca,'Fontsize',20,'linewidth',1.5)
    set(hleg1,'Fontsize',15,'linewidth',1.5,'Location','Northwest')
  set(gca,'Fontsize',22,'linewidth',2)
  box on
xlim([0.5 10.5])
ylim([-35 55])
set(gca,'XTick',1:10)
set(gca,'YTick',-40:10:50)
%  eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 

%%%%%%   
for i = 1:10
    fname = char(fname_som(:,i));
       
    lon1=ncread(fname,'lon'); 
    lat1=ncread(fname,'lat');
     [lat,lon]=meshgrid(lat1,lon1);
     gw=ncread(fname,'gw');
     I=length(lon1);
     area=repmat(gw,[1 I])';
    LATH_F=-ncread(fname,'LHFLX'); 
    SENH_F=-ncread(fname,'SHFLX');
    SW_N=ncread(fname,'FSNS'); % Net Solar Short-Wave Heat Flux
    LW_N=-ncread(fname,'FLNS');
    
    LATH_F(-LATH_F > 1.0E+30) = NaN; SENH_F(-SENH_F > 1.0E+30) = NaN;  
    SW_N(SW_N > 1.0E+30) = NaN; LW_N(-LW_N > 1.0E+30) = NaN;   
    NET = - SW_N - LW_N - SENH_F - LATH_F ;
    I = find(isnan(SW_N) == 1);
    area(I) = NaN;    
    % set tropical Pacific to 2
      mask=zeros(size(SW_N));
      J = find (lat>-8 & lat<8 & lon>130 & lon<205);
      mask(J)=2; clear J
      B = find (mask==2);
      SW_N_1=nansum(SW_N(B).*area(B))./nansum(area(B));
      LW_N_1=nansum(LW_N(B).*area(B))./nansum(area(B));
      SENH_F_1=nansum(SENH_F(B).*area(B))./nansum(area(B));
      LATH_F_1=nansum(LATH_F(B).*area(B))./nansum(area(B));
      NET_1=nansum(NET(B).*area(B))./nansum(area(B));
      clear B mask
    % set extratropical Pacific to 2 
      mask=zeros(size(SW_N));
      J = find (lat>-8 & lat<8 & lon>205 & lon<280);
      mask(J)=2; clear J
      B = find (mask==2);
      SW_N_2=nansum(SW_N(B).*area(B))./nansum(area(B));
      LW_N_2=nansum(LW_N(B).*area(B))./nansum(area(B));
      SENH_F_2=nansum(SENH_F(B).*area(B))./nansum(area(B));
      LATH_F_2=nansum(LATH_F(B).*area(B))./nansum(area(B));
      NET_2=nansum(NET(B).*area(B))./nansum(area(B));
      clear B mask

      d_SW_N_s(i) = SW_N_1 - SW_N_2;
      d_LW_N_s(i) = LW_N_1 - LW_N_2;
      d_SENH_F_s(i) = SENH_F_1 - SENH_F_2;
      d_LATH_F_s(i) = LATH_F_1 - LATH_F_2;
      d_NET_s(i) = NET_1 - NET_2;  
end

    %%%%% 
    exp_som = 11:20 ;
      fig_name = strcat('ht_flx_zonal_grad_CAM_SOM_signs_Merlis');%,num2str(tt));
      fig_dum = figure(2);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,12,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
      
    h1=plot(exp_som,d_SW_N_s,'o','markers',13); hold on
    set(h1,'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',1)
    h2=plot(exp_som,d_LATH_F_s,'o','markers',13); hold on
    set(h2,'MarkerEdgeColor','k','MarkerFaceColor','b','LineWidth',1)
    h4=plot(exp_som,d_LW_N_s,'o','markers',13); hold on
    set(h4,'MarkerEdgeColor','k','MarkerFaceColor','g','LineWidth',1)
    h5=plot(exp_som,d_SENH_F_s,'o','markers',13); hold on
    set(h5,'MarkerEdgeColor','k','MarkerFaceColor','c','LineWidth',1)
    h6=plot(exp_som,d_NET_s,'o','markers',13); hold on
    set(h6,'MarkerEdgeColor','k','MarkerFaceColor','r','LineWidth',1)

    xlabel('Experiment #','fontsize',23,'fontweight','bold');
    ylabel('Zonal Gradient of Energy Flux (W m^-^2)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2 h4 h5 h6],'net SW','latent','net LW','sensible','net flux');
    set(gca,'Fontsize',20,'linewidth',1.5)
    set(hleg1,'Fontsize',15,'linewidth',1.5,'Location','Northwest')
  set(gca,'Fontsize',22,'linewidth',2)
  box on
xlim([10.5 20.5])
ylim([-40 55])
set(gca,'XTick',11:20)
set(gca,'YTick',-40:10:50)
   print(fig_name,'-r600','-depsc'); 
