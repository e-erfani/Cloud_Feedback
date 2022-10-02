clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient

       fname_som = {'ctrl_Slab_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc'};

  fig_name_som = {'sl_ctrl'};

 %%%%SOM    
 i = 1
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
clear fname

%%%%%%%%%%%%%%%
  fname_fcm = {'chey_ctrl_rhminl_PreInd_T31_gx3v7.cam.h0.0471-0570._ANN_climo.nc'};

%%%% FCM
i = 1
    fname = char(fname_fcm(:,i));

    latent_fc=-ncread(fname,'LHFLX');
    SENH_F_fc=-ncread(fname,'SHFLX');
    SW_N_fc=ncread(fname,'FSNS'); % Net Solar Short-Wave Heat Flux
    LW_N_fc=-ncread(fname,'FLNS');

    latent_fc(latent_fc > 1.0E+30) = NaN; SENH_F_fc(SENH_F_fc > 1.0E+30) = NaN;
    SW_N_fc(SW_N_fc > 1.0E+30) = NaN; LW_N_fc(LW_N_fc > 1.0E+30) = NaN;
    NET_fc = - SW_N_fc - LW_N_fc - latent_fc - SENH_F_fc ;

%%%%%%%%%%%%
d_latent  = latent_fc - latent ;
d_SENSH_F = SENH_F_fc -  SENH_F ;
d_SW_N    = SW_N_fc   - SW_N ;
d_LW_N_fc = LW_N_fc   - LW_N ;
d_NET     = NET_fc    - NET ;

%%%%%%%%%%%%%%%
    area2 = area;
    I = find(isnan(d_SW_N) == 1);
    area2(I) = NaN;

      mask=zeros(size(area2));
      J = find (lat_msh>=-8 & lat_msh<=8);
      mask(J)=1; clear J

      B = find (mask==0);
      d_SW_N(B) = NaN; d_LW_N(B) = NaN; d_latent(B) = NaN; d_SENH_F(B) = NaN; d_NET(B) = NaN; clear B

      d_SW_N_mm = nanmean(d_SW_N,2); d_LW_N_mm = nanmean(d_LW_N,2);
      d_latent_mm = nanmean(d_latent,2); d_SENH_F_mm = nanmean(d_SENH_F,2); d_NET_mm = nanmean(d_NET,2);

    %%%%%      
      fig_name = 'diff_CAM_ht_flx_ctrl_FCM_SOM';%,num2str(tt));
      fig_dum = figure(i);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
 
    h1=plot(lon_mm,d_SW_N_mm,'o','markers',8); hold on
    set(h1,'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',1)
    h2=plot(lon_mm,d_latent_mm,'o','markers',8); hold on
    set(h2,'MarkerEdgeColor','k','MarkerFaceColor','b','LineWidth',1)
    h4=plot(lon_mm,d_LW_N_mm,'o','markers',8); hold on
    set(h4,'MarkerEdgeColor','k','MarkerFaceColor','g','LineWidth',1)
    h5=plot(lon_mm,d_SENH_F_mm,'o','markers',8); hold on
    set(h5,'MarkerEdgeColor','k','MarkerFaceColor','c','LineWidth',1)
    h6=plot(lon_mm,d_NET_mm,'o','markers',8); hold on
    set(h6,'MarkerEdgeColor','k','MarkerFaceColor','r','LineWidth',1)

    xlabel('longitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('FCM - SOM, Energy Flux (W m^-^2)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2 h4 h5 h6],'net SW','latent','net LW','sensible','net heat');
    set(gca,'Fontsize',20,'linewidth',1.5)
    set(hleg1,'Fontsize',15,'linewidth',1.5,'Location','NorthEast')
  set(gca,'Fontsize',22,'linewidth',2)
  box on
xlim([100 300]) 
%ylim([-150 250])
   print(fig_name,'-r600','-depsc');
    
