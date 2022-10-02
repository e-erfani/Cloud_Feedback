clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/Slab_lay_strat_0_05_co2_2_CHEY_PreIn'; cd (address)
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
    CLDLOW =ncread(filename1,'CLDLOW') * 100; % 
    CLDLOW_all(:,:,tt1) = CLDLOW ;

    II=find(isnan(CLDLOW_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    CLDLOW_Tseries_0_05(tt1) = nansum(nansum(GW2 .* CLDLOW_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%
cd ../Slab_lay_strat_0_1_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    CLDLOW =ncread(filename1,'CLDLOW') * 100; % 
    CLDLOW_all(:,:,tt1) = CLDLOW ;

    II=find(isnan(CLDLOW_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    CLDLOW_Tseries_0_1(tt1) = nansum(nansum(GW2 .* CLDLOW_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%%%
cd ../Slab_lay_strat_0_15_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    CLDLOW =ncread(filename1,'CLDLOW') * 100; % 
    CLDLOW_all(:,:,tt1) = CLDLOW ;

    II=find(isnan(CLDLOW_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    CLDLOW_Tseries_0_15(tt1) = nansum(nansum(GW2 .* CLDLOW_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%%%
cd ../Slab_lay_strat_0_2_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    CLDLOW =ncread(filename1,'CLDLOW') * 100; % 
    CLDLOW_all(:,:,tt1) = CLDLOW ;

    II=find(isnan(CLDLOW_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    CLDLOW_Tseries_0_2(tt1) = nansum(nansum(GW2 .* CLDLOW_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%%%
cd ../co2_Slab_CHEY_PreIn
    aa1=dir('*anmn.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    CLDLOW =ncread(filename1,'CLDLOW') * 100; % 
    CLDLOW_all(:,:,tt1) = CLDLOW ;

    II=find(isnan(CLDLOW_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    CLDLOW_Tseries_co2_2(tt1) = nansum(nansum(GW2 .* CLDLOW_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%
cd ../neg_Slab_lay_strat_0_05_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    CLDLOW =ncread(filename1,'CLDLOW') * 100; % 
    CLDLOW_all(:,:,tt1) = CLDLOW ;

    II=find(isnan(CLDLOW_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    CLDLOW_Tseries_0_05_n(tt1) = nansum(nansum(GW2 .* CLDLOW_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%
cd ../neg_Slab_lay_strat_0_1_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    CLDLOW =ncread(filename1,'CLDLOW') * 100; % 
    CLDLOW_all(:,:,tt1) = CLDLOW ;

    II=find(isnan(CLDLOW_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    CLDLOW_Tseries_0_1_n(tt1) = nansum(nansum(GW2 .* CLDLOW_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%%%
cd ../neg_Slab_lay_strat_0_15_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    CLDLOW =ncread(filename1,'CLDLOW') * 100; % 
    CLDLOW_all(:,:,tt1) = CLDLOW ;

    II=find(isnan(CLDLOW_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    CLDLOW_Tseries_0_15_n(tt1) = nansum(nansum(GW2 .* CLDLOW_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%%%
cd ../neg_Slab_lay_strat_0_2_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    CLDLOW =ncread(filename1,'CLDLOW') * 100; % 
    CLDLOW_all(:,:,tt1) = CLDLOW ;

    II=find(isnan(CLDLOW_all(:,:,tt1))==1);
    GW2 = GW ;
    GW2(II)=nan;
    CLDLOW_Tseries_0_2_n(tt1) = nansum(nansum(GW2 .* CLDLOW_all(:,:,tt1),1),2) ./ nansum(nansum(GW2,1),2) ;
end

%%%%%%
time = 1:100 ;
       fig_name = strcat('CLDLOW_TIME_SERIES_GLOBAL_neg_pos');%,num2str(tt));
        fig_dum = figure(3);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
          
h1 = plot(time,squeeze(CLDLOW_Tseries_co2_2),'k','linewidth',3) ; hold on;
text(time(end)+0.015,double(CLDLOW_Tseries_co2_2(end)),num2str(12),'color','k','FontSize',18); hold on
h2 = plot(time,squeeze(CLDLOW_Tseries_0_05),'b','linewidth',3) ;hold on
text(time(end)+0.015,double(CLDLOW_Tseries_0_05(end)),num2str(17),'color','b','FontSize',18); hold on
h3 = plot(time,squeeze(CLDLOW_Tseries_0_1),'r','linewidth',3) ; hold on 
text(time(end)+0.015,double(CLDLOW_Tseries_0_1(end)),num2str(18),'color','r','FontSize',18); hold on
h4 = plot(time,squeeze(CLDLOW_Tseries_0_15),'color',purple,'linewidth',3) ; hold on
text(time(end)+0.015,double(CLDLOW_Tseries_0_15(end)),num2str(19),'color',purple,'FontSize',18); hold on
h5 = plot(time,squeeze(CLDLOW_Tseries_0_2),'g','linewidth',3) ; hold on
text(time(end)+0.5,double(CLDLOW_Tseries_0_2(end)),num2str(20),'color','g','FontSize',18); hold on
h7 = plot(time,squeeze(CLDLOW_Tseries_0_05_n),'--b','linewidth',3) ;hold on
text(time(end)+4,double(CLDLOW_Tseries_0_05_n(end)),num2str(16),'color','b','FontSize',18); hold on
h8 = plot(time,squeeze(CLDLOW_Tseries_0_1_n),'--r','linewidth',3) ; hold on
text(time(end)+0.015,double(CLDLOW_Tseries_0_1_n(end)),num2str(15),'color','r','FontSize',18); hold on
h9 = plot(time,squeeze(CLDLOW_Tseries_0_15_n),'--','color',purple,'linewidth',3) ; hold on
text(time(end)+4,double(CLDLOW_Tseries_0_15_n(end)),num2str(14),'color',purple,'FontSize',18); hold on
h10 = plot(time,squeeze(CLDLOW_Tseries_0_2_n),'--g','linewidth',3) ; hold on
text(time(end)+0.015,double(CLDLOW_Tseries_0_2_n(end)),num2str(13),'color','g','FontSize',18); hold on
xlabel('Time (year)','fontsize',23,'fontweight','bold');
    ylabel('Global Low Cloud Amount (%)','fontsize',23,'fontweight','bold');
    set(gca,'FontSize',20,'linewidth',1.5)
 % ylim([24 38])
  xlim([-10 110])
  box on
cd (address)  
  print ('-r600', fig_name,'-depsc')     
  