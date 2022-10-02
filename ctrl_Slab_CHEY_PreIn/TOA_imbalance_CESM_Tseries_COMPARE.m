clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

cd /shared/SWFluxCorr/CESM/ctrl_Slab_CHEY_PreIn
    aa1=dir('*anmn.nc');
    tt1=1; % ncdisp(aa(tt,1).name)
    filename1=aa1(tt1,1).name;
  gw=ncread(filename1,'gw'); % surface net Shortwave Radiation (W/m2)
    lat =ncread(filename1,'lat');
    lon =ncread(filename1,'lon');
[lon_msh,lat_msh] = meshgrid(lon,lat);

      I=length(lon);
      GW=repmat(gw,[1 I])';

for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    fsnt =ncread(filename1,'FSNT'); % 
    flnt =ncread(filename1,'FLNT'); % 
    fsnt_all(:,:,tt1) = fsnt ;
    flnt_all(:,:,tt1) = flnt ;
end

for i = 1:size(fsnt_all,3)
    fsnt_Tseries(i) = nansum(nansum(GW .* fsnt_all(:,:,i),1),2) ./ nansum(nansum(GW,1),2) ;
    flnt_Tseries(i) = nansum(nansum(GW .* flnt_all(:,:,i),1),2) ./ nansum(nansum(GW,1),2) ; 
end

TOA_imbalance_ctrl = fsnt_Tseries - flnt_Tseries ;

clear fsnt_all1 fsnt_all2 fsnt_all fsnt_Tseries fsnt_Tseries_yr 
clear flnt_all1 flnt_all2 flnt_all flnt_Tseries flnt_Tseries_yr

%%%%%%
time = 1:100 ;
       fig_name = strcat('TOA_imbalance_TIME_SERIES_GLOBAL_compare');%,num2str(tt));
        fig_dum = figure(3);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
h1 = plot(time,squeeze(TOA_imbalance_ctrl(1:100)),'k','linewidth',1.5) ;
%hold on
%h2 = plot(time,squeeze(TOA_imbalance_0_05(1:600)),'b','linewidth',1.5) ;
%hold on
%h3 = plot(time,squeeze(TOA_imbalance_0_1(1:600)),'r','linewidth',1.5) ;
%hold on
%h4 = plot(time,squeeze(TOA_imbalance_0_15(1:600)),'color',purple,'linewidth',1.5) ;
%hold on
%h5 = plot(time,squeeze(TOA_imbalance_0_2(1:600)),'g','linewidth',1.5) ;   
%hold on
%h6 = plot(time,squeeze(TOA_imbalance_0_5(1:600)),'c','linewidth',1.5) ;
    xlabel('Time (year)','fontsize',23,'fontweight','bold');
    ylabel('Global TOA imbalance (W m^-^2)','fontsize',23,'fontweight','bold');
%   hleg1 = legend([h1 h2 h3 h4 h5 h6],'CESM, 2XCO2','CESM, c=0.05','CESM, c=0.1',...
%           'CESM, c=0.15','CESM, c=0.2','CESM, c=0.5');    
    set(gca,'Fontsize',20,'linewidth',1.5)
%  ylim([-0.2 7.5])
  xlim([-10 120])
  box on
cd /shared/SWFluxCorr/CESM/ctrl_Slab_CHEY_PreIn  
  eval(['print -r600 -djpeg ', fig_name,'.jpg']);    

