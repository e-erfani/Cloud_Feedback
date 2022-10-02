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
       
    lon=ncread(fname,'lon'); lon_mm = nanmean(lon,2);
    lat=ncread(fname,'lat');
     [lat_msh,lon_msh]=meshgrid(lat,lon);    
    gw=ncread(fname,'gw');
     I=length(lon);
     area=repmat(gw,[1 I])';
    latent=-ncread(fname,'LHFLX'); 
    SENH_F=-ncread(fname,'SHFLX');
    SW_N=ncread(fname,'FSNS'); % Net Solar Short-Wave Heat Flux
    LW_N=-ncread(fname,'FLNS');
    
    latent(latent > 1.0E+30) = NaN; SENH_F(SENH_F > 1.0E+30) = NaN;  
    SW_N(SW_N > 1.0E+30) = NaN; LW_N(LW_N > 1.0E+30) = NaN;   
    NET = - SW_N - LW_N - latent - SENH_F ;
    
    area2 = area;
    I = find(isnan(SW_N) == 1);
    area2(I) = NaN;
    
      mask=zeros(size(area2));
      J = find (lat_msh>=-8 & lat_msh<=8);
      mask(J)=1; clear J

      B = find (mask==0);
      SW_N(B) = NaN; LW_N(B) = NaN; latent(B) = NaN; SENH_F(B) = NaN; NET(B) = NaN; clear B
      
      SW_N_mm = nanmean(SW_N,2); LW_N_mm = nanmean(LW_N,2); 
      latent_mm = nanmean(latent,2); SENH_F_mm = nanmean(SENH_F,2); NET_mm = nanmean(NET,2); 
      
    %%%%%      
      fig_name = strcat('CAM_ht_flx_signs_',char(fig_name_fcm(:,i)));%,num2str(tt));
      fig_dum = figure(i);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
      
    h1=plot(lon_mm,SW_N_mm,'o','markers',8); hold on
    set(h1,'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',1)
    h2=plot(lon_mm,latent_mm,'o','markers',8); hold on
    set(h2,'MarkerEdgeColor','k','MarkerFaceColor','b','LineWidth',1)
    h4=plot(lon_mm,LW_N_mm,'o','markers',8); hold on
    set(h4,'MarkerEdgeColor','k','MarkerFaceColor','g','LineWidth',1)
    h5=plot(lon_mm,SENH_F_mm,'o','markers',8); hold on
    set(h5,'MarkerEdgeColor','k','MarkerFaceColor','c','LineWidth',1)
    h6=plot(lon_mm,NET_mm,'o','markers',8); hold on
    set(h6,'MarkerEdgeColor','k','MarkerFaceColor','r','LineWidth',1)

    xlabel('longitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('Energy Flux (W m^-^2)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2 h4 h5 h6],'net SW','latent','net LW','sensible','net heat');
    set(gca,'Fontsize',20,'linewidth',1.5)
    set(hleg1,'Fontsize',15,'linewidth',1.5,'Location','NorthEast')
  set(gca,'Fontsize',22,'linewidth',2)
  box on
xlim([100 300])
ylim([-150 250])
%set(gca,'XTick',[17 18 19 20 21 22 23 24 25 26])
%set(gca,'YTick',24:2:40)
%  eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
   dbstop
 clear SW_N_mm SW_N LW_N_mm LW_N QFLUX_mm QFLUX latent latent_mm SENSH_F SENH_F_mm EVAP_F LW_d LW_u
end

close all
%%%%% SOM
for i = 1:10
    fname = char(fname_som(:,i));
       
    lon=ncread(fname,'lon'); lon_mm = nanmean(lon,2);
    lat=ncread(fname,'lat');
     [lat_msh,lon_msh]=meshgrid(lat,lon);    
    gw=ncread(fname,'gw');
     I=length(lon);
     area=repmat(gw,[1 I])';
    latent= -ncread(fname,'LHFLX'); 
    SENH_F= -ncread(fname,'SHFLX');
    SW_N=ncread(fname,'FSNS'); % Net Solar Short-Wave Heat Flux
    LW_N= -ncread(fname,'FLNS');
    
    latent(latent > 1.0E+30) = NaN; SENH_F(SENH_F > 1.0E+30) = NaN;
    SW_N(SW_N > 1.0E+30) = NaN; LW_N(LW_N > 1.0E+30) = NaN;
    NET = - SW_N - LW_N - latent - SENH_F ;

    area2 = area;
    I = find(isnan(SW_N) == 1);
    area2(I) = NaN;

      mask=zeros(size(area2));
      J = find (lat_msh>=-8 & lat_msh<=8);
      mask(J)=1; clear J

      B = find (mask==0);
      SW_N(B) = NaN; LW_N(B) = NaN; latent(B) = NaN; SENH_F(B) = NaN; NET(B) = NaN; clear B

      SW_N_mm = nanmean(SW_N,2); LW_N_mm = nanmean(LW_N,2);
      latent_mm = nanmean(latent,2); SENH_F_mm = nanmean(SENH_F,2); NET_mm = nanmean(NET,2);

    %%%%%      
      fig_name = strcat('CAM_ht_flx_',char(fig_name_som(:,i)));%,num2str(tt));
      fig_dum = figure(i);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
 
    h1=plot(lon_mm,SW_N_mm,'o','markers',8); hold on
    set(h1,'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',1)
    h2=plot(lon_mm,latent_mm,'o','markers',8); hold on
    set(h2,'MarkerEdgeColor','k','MarkerFaceColor','b','LineWidth',1)
    h4=plot(lon_mm,LW_N_mm,'o','markers',8); hold on
    set(h4,'MarkerEdgeColor','k','MarkerFaceColor','g','LineWidth',1)
    h5=plot(lon_mm,SENH_F_mm,'o','markers',8); hold on
    set(h5,'MarkerEdgeColor','k','MarkerFaceColor','c','LineWidth',1)
    h6=plot(lon_mm,NET_mm,'o','markers',8); hold on
    set(h6,'MarkerEdgeColor','k','MarkerFaceColor','r','LineWidth',1)

    xlabel('longitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('Energy Flux (W m^-^2)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2 h4 h5 h6],'net SW','latent','net LW','sensible','net heat');
    set(gca,'Fontsize',20,'linewidth',1.5)
    set(hleg1,'Fontsize',15,'linewidth',1.5,'Location','NorthEast')
  set(gca,'Fontsize',22,'linewidth',2)
  box on
xlim([100 300]) 
ylim([-150 250])
   print(fig_name,'-r600','-depsc');
   dbstop     
 clear SW_N_mm SW_N LW_N_mm LW_N QFLUX_mm QFLUX latent latent_mm SENSH_F SENH_F_mm EVAP_F LW_d LW_u
end
    
