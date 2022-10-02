clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/NEW_scatter_gradient' ;
cd (address)

 fname_fcm = {'chey_co2_2_rhminl_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
   'neg_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
  'neg_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
   'neg_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
  'neg_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
      'lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
       'lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
      'lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
      '2lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc',...
               'chey_ctrl_rhminl_PreInd_T31_gx3v7.cam.h0.0471-0570._ANN_climo.nc'};      

       fname_som = { 'co2_Slab_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
 'neg_Slab_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
'neg_Slab_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
 'neg_Slab_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
'neg_Slab_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
    'Slab_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
     'Slab_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
    'Slab_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
     'Slab_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
                    'ctrl_Slab_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc'};

for i = 1:10
    var = ncread(char(fname_fcm(:,i)),'U'); 
    lat = ncread(char(fname_fcm(:,i)),'lat');
    lev = ncread(char(fname_fcm(:,i)),'lev');
    l867 = find(lev > 850 & lev < 900);
    var_trim = var(:,:,l867) ;    
    var_ZM_fcm = nanmean(var_trim,1);
    var_ZM_fcm_all(:,i) = var_ZM_fcm;  
end
    
%%%%
    
for i = 1:10
    var = ncread(char(fname_som(:,i)),'U'); 
    lat = ncread(char(fname_som(:,i)),'lat');
    lev = ncread(char(fname_som(:,i)),'lev');
    l867 = find(lev > 850 & lev < 900);
    var_trim = var(:,:,l867) ;    
    var_ZM_som = nanmean(var_trim,1);
    var_ZM_som_all(:,i) = var_ZM_som; 
end     
%%%%%%%
       fig_name = strcat('zonal_867_U_FCM');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');      
      
cl = ['k','g','m','r','b','b','r','m','g','c']; 

h(10)=plot(lat,squeeze(var_ZM_fcm_all(:,10)),'color',cl(10),'linewidth',2) ; hold on
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
    ylabel('867 hPa Zonal Wind (m s^-^1)','fontsize',23,'fontweight','bold');
xlim([-90 90])
%ylim([-0.91 1.6])
set(gca,'Fontsize',20,'linewidth',1.5)
   hleg1 = legend([h(10) h(1) h(2) h(3) h(4) h(5) h(6) h(7) h(8) h(9)],'1','2',...
         '3','4','5','6','7','8','9','10');% ,'SOM');
    set(hleg1,'Location','northwest','Fontsize',15)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')
box on
%   eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  
%%%%
       fig_name = strcat('zonal_867_U_SOM');%,num2str(tt));
        fig_dum = figure(2);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
            
cl = ['k','g','m','r','b','b','r','m','g','c']; 

h(10)=plot(lat,squeeze(var_ZM_som_all(:,10)),'color',cl(10),'linewidth',2) ; hold on
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
    ylabel('867 hPa Zonal Wind (m s^-^1)','fontsize',23,'fontweight','bold');
xlim([-90 90])
%ylim([-0.91 1.6])
set(gca,'Fontsize',20,'linewidth',1.5)
   hleg1 = legend([h(10) h(1) h(2) h(3) h(4) h(5) h(6) h(7) h(8) h(9)],'11','12',...
         '13','14','15','16','17','18','19','20');% ,'SOM');
    set(hleg1,'Location','northwest','Fontsize',15)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')
box on
%   eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  