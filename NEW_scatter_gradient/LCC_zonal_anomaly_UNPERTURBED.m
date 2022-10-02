clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/NEW_scatter_gradient' ;
cd (address)

  fname_fcm = {'chey_ctrl_rhminl_PreInd_T31_gx3v7.cam.h0.0471-0570._ANN_climo.nc',...
              'chey_co2_2_rhminl_PreInd_T31_gx3v7.cam.h0.2181-2280._ANN_climo.nc'};

       fname_som = {'ctrl_Slab_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
                     'co2_Slab_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc'};

for i = 1:2
    infile = char(fname_fcm(:,i)) ;
    ncid = netcdf.open(infile,'NOWRITE');
    varid = netcdf.inqVarID(ncid,'CLDLOW'); 
    var = netcdf.getVar(ncid,varid,'double'); clear  varid       
    lat=ncread(infile,'lat');
    var = var.*100;
    var_ZM_fcm = squeeze(mean(var,1));
    var_ZM_fcm_all(:,i) = var_ZM_fcm;    
end
ctrl_fcm = var_ZM_fcm_all(:,1) ; 
var_ZM_fcm_all(:,1) = [] ;
  ZM_fcm_anom(:,1) =  var_ZM_fcm_all(:,1) - ctrl_fcm ; 
%%%%
    
for i = 1:2    
    infile = char(fname_som(:,i)) ;
    ncid = netcdf.open(infile,'NOWRITE');
    varid = netcdf.inqVarID(ncid,'CLDLOW'); 
    var = netcdf.getVar(ncid,varid,'double'); clear  varid       
    lat=ncread(infile,'lat');
    var = var.*100;
    var_ZM_som = squeeze(mean(var,1));
    var_ZM_som_all(:,i) = var_ZM_som;     
end
ctrl_som = var_ZM_som_all(:,1) ; 
var_ZM_som_all(:,1) = [] ;
  ZM_som_anom(:,1) =  var_ZM_som_all(:,1) - ctrl_som ; 
%%%%%%%
       fig_name = strcat('zonal_LCC_anomaly_unperturbed');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');      
      
cl = ['k','g','m','r','b','b','r','m','g']; 

h(1)=plot(lat,squeeze(ZM_fcm_anom(:,1)),'color',cl(5),'linewidth',2) ; hold on;
h(2)=plot(lat,squeeze(ZM_som_anom(:,1)),'color',cl(4),'linewidth',2) ; hold on;

    xlabel('Latitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('LCC anomaly (%)','fontsize',23,'fontweight','bold');
xlim([-60 60])
ylim([-7 5])
   hleg1 = legend([h(1) h(2)],'2', '12');% ,'SOM');
    set(hleg1,'Location','southEast','Fontsize',18)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')
set(gca,'Fontsize',22,'linewidth',1.5)
box on
%   eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  