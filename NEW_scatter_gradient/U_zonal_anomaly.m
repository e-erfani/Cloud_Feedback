clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/NEW_scatter_gradient' ;
cd (address)

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

for i = 1:10
    var = ncread(char(fname_fcm(:,i)),'U');
    lat = ncread(char(fname_fcm(:,i)),'lat');
    lev = ncread(char(fname_fcm(:,i)),'lev');
    lev0 = lev(9:end) ;
    lev2 = lev0(1:17) ;
    delta_lev = lev0(2:18) - lev2 ;
    var_trim = var(:,:,10:26) ;
    for ii=1:size(var_trim,1)
      for jj=1:size(var_trim,2)
         var_vert(ii,jj) = nansum(squeeze(var_trim(ii,jj,:)) .* delta_lev) ./ nansum(delta_lev ) ;
      end
    end
    var_ZM_fcm = nanmean(var_vert,1);
    var_ZM_fcm_all(:,i) = var_ZM_fcm;    
end
ctrl_fcm = var_ZM_fcm_all(:,1) ; 
var_ZM_fcm_all(:,1) = [] ;
for ii = 1:9
  ZM_fcm_anom(:,ii) =  var_ZM_fcm_all(:,ii) - ctrl_fcm ; 
end
%%%%
    
for i = 1:10
    var = ncread(char(fname_som(:,i)),'U');
    lat = ncread(char(fname_som(:,i)),'lat');
    lev = ncread(char(fname_som(:,i)),'lev');
    lev0 = lev(9:end) ;
    lev2 = lev0(1:17) ;
    delta_lev = lev0(2:18) - lev2 ;
    var_trim = var(:,:,10:26) ;
    for ii=1:size(var_trim,1)
      for jj=1:size(var_trim,2)
         var_vert(ii,jj) = nansum(squeeze(var_trim(ii,jj,:)) .* delta_lev) ./ nansum(delta_lev ) ;
      end
    end
    var_ZM_som = nanmean(var_vert,1);	
    var_ZM_som_all(:,i) = var_ZM_som;    
end
ctrl_som = var_ZM_som_all(:,1) ; 
var_ZM_som_all(:,1) = [] ;
for ii = 1:9
  ZM_som_anom(:,ii) =  var_ZM_som_all(:,ii) - ctrl_som ; 
end
%%%%%%%
       fig_name = strcat('zonal_vert_U_FCM_anomaly_1800');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');      
      
cl = ['k','g','m','r','b','b','r','m','g']; 

h(1)=plot(lat,squeeze(ZM_fcm_anom(:,1)),'color',cl(1),'linewidth',2) ; hold on;
for j = 2:5
    if (j==3)
      h(j)=plot(lat,squeeze(ZM_fcm_anom(:,j)),'--','color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat,squeeze(ZM_fcm_anom(:,j)),'--','color',cl(j),'linewidth',2) ; hold on;
    end
end
for j = 6:9
    if (j==8)
      h(j)=plot(lat,squeeze(ZM_fcm_anom(:,j)),'color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat,squeeze(ZM_fcm_anom(:,j)),'color',cl(j),'linewidth',2) ; hold on;
    end
end

    xlabel('Latitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('Zonal wind anomaly (m s^-^1)','fontsize',23,'fontweight','bold');
xlim([-90 90])
ylim([-2.5 2.5])
set(gca,'Fontsize',20,'linewidth',1.5)
   hleg1 = legend([h(1) h(2) h(3) h(4) h(5) h(6) h(7) h(8) h(9)],'2',...
         '3','4','5','6','7','8','9','10');% ,'SOM');
    set(hleg1,'Location','northwest','Fontsize',13)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')
box on
%   eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  
%%%%
       fig_name = strcat('zonal_vert_U_SOM_anomaly');%,num2str(tt));
        fig_dum = figure(2);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
            
cl = ['k','g','m','r','b','b','r','m','g']; 

h(1)=plot(lat,squeeze(ZM_som_anom(:,1)),'color',cl(1),'linewidth',2) ; hold on;
for j = 2:5
    if (j==3)
      h(j)=plot(lat,squeeze(ZM_som_anom(:,j)),'--','color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat,squeeze(ZM_som_anom(:,j)),'--','color',cl(j),'linewidth',2) ; hold on;
    end
end
for j = 6:9
    if (j==8)
      h(j)=plot(lat,squeeze(ZM_som_anom(:,j)),'color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat,squeeze(ZM_som_anom(:,j)),'color',cl(j),'linewidth',2) ; hold on;
    end
end

    xlabel('Latitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('Zonal wind anomaly (m s^-^1)','fontsize',23,'fontweight','bold');
xlim([-90 90])
ylim([-2.5 2.5])
set(gca,'Fontsize',20,'linewidth',1.5)
   hleg1 = legend([h(1) h(2) h(3) h(4) h(5) h(6) h(7) h(8) h(9)],'12',...
         '13','14','15','16','17','18','19','20');% ,'SOM');
    set(hleg1,'Location','northwest','Fontsize',13)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')
box on
%   eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  
