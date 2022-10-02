clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

cd /shared/SWFluxCorr/CESM/Slab_lay_strat_0_05_co2_2_CHEY_PreIn
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
    fsnt =ncread(filename1,'FSNT'); 
    flnt =ncread(filename1,'FLNT'); 
    TOA_imblnc_all(:,:,tt1) = fsnt - flnt ;

    II=find(isnan(TOA_imblnc_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    TOA_imblnc_Tseries_0_05(tt1) = nansum(nansum(GW2 .* TOA_imblnc_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%
cd ../Slab_lay_strat_0_1_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    fsnt =ncread(filename1,'FSNT'); 
    flnt =ncread(filename1,'FLNT'); 
    TOA_imblnc_all(:,:,tt1) = fsnt - flnt ;

    II=find(isnan(TOA_imblnc_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    TOA_imblnc_Tseries_0_1(tt1) = nansum(nansum(GW2 .* TOA_imblnc_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%%%
cd ../Slab_lay_strat_0_15_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    fsnt =ncread(filename1,'FSNT'); 
    flnt =ncread(filename1,'FLNT'); 
    TOA_imblnc_all(:,:,tt1) = fsnt - flnt ;

    II=find(isnan(TOA_imblnc_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    TOA_imblnc_Tseries_0_15(tt1) = nansum(nansum(GW2 .* TOA_imblnc_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%%%
cd ../Slab_lay_strat_0_2_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    fsnt =ncread(filename1,'FSNT'); 
    flnt =ncread(filename1,'FLNT'); 
    TOA_imblnc_all(:,:,tt1) = fsnt - flnt ;

    II=find(isnan(TOA_imblnc_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    TOA_imblnc_Tseries_0_2(tt1) = nansum(nansum(GW2 .* TOA_imblnc_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%%%
cd ../co2_Slab_CHEY_PreIn
    aa1=dir('*anmn.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    fsnt =ncread(filename1,'FSNT'); 
    flnt =ncread(filename1,'FLNT'); 
    TOA_imblnc_all(:,:,tt1) = fsnt - flnt ;

    II=find(isnan(TOA_imblnc_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    TOA_imblnc_Tseries_co2_2(tt1) = nansum(nansum(GW2 .* TOA_imblnc_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%
time = 1:100 ;
       fig_name = strcat('TOA_imblnc_TIME_SERIES_GLOBAL');%,num2str(tt));
        fig_dum = figure(3);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
          
h1 = plot(time,squeeze(TOA_imblnc_Tseries_co2_2),'k','linewidth',2) ;
hold on
h2 = plot(time,squeeze(TOA_imblnc_Tseries_0_05),'b','linewidth',2) ;
hold on
h3 = plot(time,squeeze(TOA_imblnc_Tseries_0_1),'r','linewidth',2) ;
hold on
h4 = plot(time,squeeze(TOA_imblnc_Tseries_0_15),'color',purple,'linewidth',2) ;
hold on
h5 = plot(time,squeeze(TOA_imblnc_Tseries_0_2),'g','linewidth',2) ;
    xlabel('Time (year)','fontsize',23,'fontweight','bold');
    ylabel('Global TOA imbalance (Wm^-^2)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2 h3 h4 h5],'CESM, 2XCO2','CESM, c=0.05','CESM, c=0.1',...
           'CESM, c=0.15','CESM, c=0.2');%,'Orientation','horizontal');        
    set(gca,'Fontsize',20,'linewidth',1.5)
    set(hleg1,'Fontsize',20,'linewidth',1.5)
  ylim([-0.7 4])
  xlim([-10 110])
  box on
cd /shared/SWFluxCorr/CESM/Slab_lay_strat_0_05_co2_2_CHEY_PreIn  
  eval(['print -r600 -djpeg ', fig_name,'.jpg']);    
  