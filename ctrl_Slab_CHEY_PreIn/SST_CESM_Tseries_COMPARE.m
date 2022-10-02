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
    sst =ncread(filename1,'SST'); % 
    sst(sst > 1E4) = NaN ;
    sst(sst < 100) = NaN ;
    sst_all(:,:,tt1) = sst ;

    II=find(isnan(sst_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    sst_Tseries_ctrl(tt1) = nansum(nansum(GW2 .* sst_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) - 273.15;
end

%%%%%%
time = 1:100 ;
       fig_name = strcat('SST_TIME_SERIES_GLOBAL_compare');%,num2str(tt));
        fig_dum = figure(3);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
h1 = plot(time,squeeze(sst_Tseries_ctrl(1:100)),'k','linewidth',1.5) ;
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
    ylabel('Global Sea Surface Temperature (\circC)','fontsize',23,'fontweight','bold');
%   hleg1 = legend([h1 h2 h3 h4 h5 h6],'CESM, 2XCO2','CESM, c=0.05','CESM, c=0.1',...
%           'CESM, c=0.15','CESM, c=0.2','CESM, c=0.5');    
    set(gca,'Fontsize',20,'linewidth',1.5)
%  ylim([-0.2 7.5])
  xlim([-10 120])
  box on
cd /shared/SWFluxCorr/CESM/ctrl_Slab_CHEY_PreIn  
  eval(['print -r600 -djpeg ', fig_name,'.jpg']);    

