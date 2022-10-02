clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/NEW_scatter_gradient' ;
cd (address)
    aa=dir('*_tavg.*.nc');
    
for i = 1:10
    fname = aa(i,1).name;
    [SST_ZM,lat_ZM] = get_meridional_SST(fname);
    lat_ZM = lat_ZM' ; 
 SST_ZM_fcm_temp(:,i) = SST_ZM;  
end

ctrl_fcm = SST_ZM_fcm_temp(:,2);
SST_ZM_fcm_temp(:,2) = [];
SST_ZM_fcm = SST_ZM_fcm_temp ;
nn = 2;
for i = 5:-1:2
  SST_ZM_fcm(:,nn) = SST_ZM_fcm_temp(:,i) ;
  nn = nn + 1 ;
end

for ii = 1:9
  SST_ZM_fcm_anom(:,ii) =  SST_ZM_fcm(:,ii) - ctrl_fcm ; 
end
%%%%

cd /shared/SWFluxCorr/CESM/scatter_gradient
    aa=dir('sst_CO_sl*'); load('lat_msh_CAM.mat'); load('lon_msh_CAM.mat');
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
 SST_ZM_SOM = nanmean(sst,2);
 lat_ZM_SOM = nanmean(lat_msh_CAM,2);
 %[SST_ZM_SOM,lat_ZM_SOM]=get_meridional_SST_SOM(sst,lat_msh_CAM,lon_msh_CAM);
 %    lat_ZM_SOM = lat_ZM_SOM' ;
 SST_ZM_SOM_temp(:,tt) = SST_ZM_SOM;
end     

ctrl_som = SST_ZM_SOM_temp(:,2);
SST_ZM_SOM_temp(:,2) = [];
nn = 2 ;
SST_ZM_SOM = SST_ZM_SOM_temp ;
for i = 5:-1:2
  SST_ZM_SOM(:,nn) = SST_ZM_SOM_temp(:,i) ;
  nn = nn + 1 ;
end

for ii = 1:9
  SST_ZM_som_anom(:,ii) =  SST_ZM_SOM(:,ii) - ctrl_som ; 
end
%%%%%%%
       fig_name = strcat('zonal_SST_FCM_anomaly_1800');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');      
      
cl = ['k','g','m','r','b','b','r','m','g']; 

h(1)=plot(lat_ZM,squeeze(SST_ZM_fcm_anom(:,1)),'color',cl(1),'linewidth',2) ; hold on;
for j = 2:5
    if (j==3)
      h(j)=plot(lat_ZM,squeeze(SST_ZM_fcm_anom(:,j)),'--','color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat_ZM,squeeze(SST_ZM_fcm_anom(:,j)),'--','color',cl(j),'linewidth',2) ; hold on;
    end
end
for j = 6:9
    if (j==8)
      h(j)=plot(lat_ZM,squeeze(SST_ZM_fcm_anom(:,j)),'color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat_ZM,squeeze(SST_ZM_fcm_anom(:,j)),'color',cl(j),'linewidth',2) ; hold on;
    end
end

    xlabel('Latitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('SST anomaly (\circC)','fontsize',23,'fontweight','bold');
xlim([-99.99 99.99])
ylim([-0.5 14])
   hleg1 = legend([h(1) h(2) h(3) h(4) h(5) h(6) h(7) h(8) h(9)],'2',...
         '3','4','5','6','7','8','9','10');% ,'SOM');
    set(hleg1,'Location','NorthWest','Fontsize',16)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')
set(gca,'Fontsize',20,'linewidth',1.5)
box on
cd (address)
  % eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  
%%%%
       fig_name = strcat('zonal_SST_SOM_anomaly');%,num2str(tt));
        fig_dum = figure(2);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
            
cl = ['k','g','m','r','b','b','r','m','g']; 

h(1)=plot(lat_ZM_SOM,squeeze(SST_ZM_som_anom(:,1)),'color',cl(1),'linewidth',2) ; hold on;
for j = 2:5
    if (j==3)
      h(j)=plot(lat_ZM_SOM,squeeze(SST_ZM_som_anom(:,j)),'--','color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat_ZM_SOM,squeeze(SST_ZM_som_anom(:,j)),'--','color',cl(j),'linewidth',2) ; hold on;
    end
end
for j = 6:9
    if (j==8)
      h(j)=plot(lat_ZM_SOM,squeeze(SST_ZM_som_anom(:,j)),'color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat_ZM_SOM,squeeze(SST_ZM_som_anom(:,j)),'color',cl(j),'linewidth',2) ; hold on;
    end
end

    xlabel('Latitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('SST anomaly (\circC)','fontsize',23,'fontweight','bold');
xlim([-99.99 99.99])
ylim([-0.5 14])
   hleg1 = legend([h(1) h(2) h(3) h(4) h(5) h(6) h(7) h(8) h(9)],'12',...
         '13','14','15','16','17','18','19','20');% ,'SOM');
    set(hleg1,'Location','NorthWest','Fontsize',16)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')
set(gca,'Fontsize',20,'linewidth',1.5)
box on
cd (address)
  % eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  