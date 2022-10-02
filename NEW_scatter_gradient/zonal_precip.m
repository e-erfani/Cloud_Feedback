clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/NEW_scatter_gradient' ;
cd (address)

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

for i = 1:9
    % convective + large-scale (stable) precipitation rate (liq + ice), unit: m/s
    var = ncread(char(fname_fcm(:,i)),'PRECC') +  ncread(char(fname_fcm(:,i)),'PRECL'); 
    lat = ncread(char(fname_fcm(:,i)),'lat');
    var_ZM_fcm = nanmean(var,1); var_ZM_fcm = double(var_ZM_fcm') .* 8.64E7 ;
    var_ZM_fcm_all(:,i) = var_ZM_fcm;  
end
    
%%%%
    
for i = 1:9
    var_ = ncread(char(fname_som(:,i)),'PRECC') +  ncread(char(fname_som(:,i)),'PRECL'); 
    lat = ncread(char(fname_fcm(:,i)),'lat');
    var_ZM_som = nanmean(var_,1); var_ZM_som = double(var_ZM_som') .* 8.64E7 ;
    var_ZM_som_all(:,i) = var_ZM_som; 
end     
%%%%%%%
       fig_name = strcat('zonal_precip_FCM');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');      
      
cl = ['k','g','m','r','b','b','r','m','g']; 

h(1)=plot(lat,squeeze(var_ZM_fcm_all(:,1)),'color',cl(1),'linewidth',2) ; hold on;
for j = 2:5
    if (j==3)
      h(j)=plot(lat,squeeze(var_ZM_fcm_all(:,j)),'--','color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat,squeeze(var_ZM_fcm_all(:,j)),'--','color',cl(j),'linewidth',2) ; hold on;
    end
end
for j = 6:9
    if (j==8)
      h(j)=plot(lat,squeeze(var_ZM_fcm_all(:,j)),'color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat,squeeze(var_ZM_fcm_all(:,j)),'color',cl(j),'linewidth',2) ; hold on;
    end
end

    xlabel('Latitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('Precipitation rate (mm day^-^1)','fontsize',23,'fontweight','bold');
xlim([-90 90])
%ylim([-0.91 1.6])
   hleg1 = legend([h(1) h(2) h(3) h(4) h(5) h(6) h(7) h(8) h(9)],'2',...
         '3','4','5','6','7','8','9','10');% ,'SOM');
    set(hleg1,'Location','NorthWest','Fontsize',17)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')
set(gca,'Fontsize',20,'linewidth',1.5)
box on
%   eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  
%%%%
       fig_name = strcat('zonal_precip_SOM');%,num2str(tt));
        fig_dum = figure(2);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
            
cl = ['k','g','m','r','b','b','r','m','g']; 

h(1)=plot(lat,squeeze(var_ZM_som_all(:,1)),'color',cl(1),'linewidth',2) ; hold on;
for j = 2:5
    if (j==3)
      h(j)=plot(lat,squeeze(var_ZM_som_all(:,j)),'--','color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat,squeeze(var_ZM_som_all(:,j)),'--','color',cl(j),'linewidth',2) ; hold on;
    end
end
for j = 6:9
    if (j==8)
      h(j)=plot(lat,squeeze(var_ZM_som_all(:,j)),'color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat,squeeze(var_ZM_som_all(:,j)),'color',cl(j),'linewidth',2) ; hold on;
    end
end

    xlabel('Latitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('Precipitation rate (mm day^-^1)','fontsize',23,'fontweight','bold');
xlim([-90 90])
%ylim([-0.91 1.6])
   hleg1 = legend([h(1) h(2) h(3) h(4) h(5) h(6) h(7) h(8) h(9)],'12',...
         '13','14','15','16','17','18','19','20');% ,'SOM');
    set(hleg1,'Location','NorthWest','Fontsize',17)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')
set(gca,'Fontsize',20,'linewidth',1.5)
box on
%   eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  