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
[lat_msh,lon_msh] = meshgrid(lat,lon);

      I=length(lon);
      GW=repmat(gw,[1 I])';
      
idx = find(lat >= -8 & lat <= 8) ;
idy = find(lon >= 130 & lon <= 280) ;
lon2 = lon(idy) ;
nn = 0 ;
for tt1=21:100
    nn = nn + 1;          
    filename1=aa1(tt1,1).name;
    sst =ncread(filename1,'SST') - 273.15; % 
    sst(sst > 1E4) = NaN ;
    sst(sst < -100) = NaN ;
    sst_all(:,:,nn) = sst ;
end
sst_mean = nanmean(sst_all,3) ;
GW2 = GW ;
II = find(isnan(sst_mean)==1) ;
GW2(II) = NaN ;
GW2_trim = GW2(:,idx) ;
SST_POP_trim = sst_mean(:,idx) ;
SST_trim_mean_0_05 = nansum(GW2_trim .* SST_POP_trim,2) ./ nansum(GW2_trim,2);

%%%%%%
cd ../Slab_lay_strat_0_1_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
nn = 0 ;
for tt1=21:100
    nn = nn + 1;          
    filename1=aa1(tt1,1).name;
    sst =ncread(filename1,'SST') - 273.15; % 
    sst(sst > 1E4) = NaN ;
    sst(sst < -100) = NaN ;
    sst_all(:,:,nn) = sst ;
end
sst_mean = nanmean(sst_all,3) ;
SST_POP_trim = sst_mean(:,idx) ;
SST_trim_mean_0_1 = nansum(GW2_trim .* SST_POP_trim,2) ./ nansum(GW2_trim,2);

%%%%%%%%
cd ../Slab_lay_strat_0_15_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
nn = 0 ;
for tt1=21:100
    nn = nn + 1;          
    filename1=aa1(tt1,1).name;
    sst =ncread(filename1,'SST') - 273.15; % 
    sst(sst > 1E4) = NaN ;
    sst(sst < -100) = NaN ;
    sst_all(:,:,nn) = sst ;
end
sst_mean = nanmean(sst_all,3) ;
SST_POP_trim = sst_mean(:,idx) ;
SST_trim_mean_0_15 = nansum(GW2_trim .* SST_POP_trim,2) ./ nansum(GW2_trim,2);

%%%%%%%%
cd ../Slab_lay_strat_0_2_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
nn = 0 ;
for tt1=21:100
    nn = nn + 1;          
    filename1=aa1(tt1,1).name;
    sst =ncread(filename1,'SST') - 273.15; % 
    sst(sst > 1E4) = NaN ;
    sst(sst < -100) = NaN ;
    sst_all(:,:,nn) = sst ;
end
sst_mean = nanmean(sst_all,3) ;
SST_POP_trim = sst_mean(:,idx) ;
SST_trim_mean_0_2 = nansum(GW2_trim .* SST_POP_trim,2) ./ nansum(GW2_trim,2);

%%%%%%%%
cd ../co2_Slab_CHEY_PreIn
    aa1=dir('*anmn.nc');
nn = 0 ;
for tt1=21:100
    nn = nn + 1;          
    filename1=aa1(tt1,1).name;
    sst =ncread(filename1,'SST') - 273.15; % 
    sst(sst > 1E4) = NaN ;
    sst(sst < -100) = NaN ;
    sst_all(:,:,nn) = sst ;
end
sst_mean = nanmean(sst_all,3) ;
SST_POP_trim = sst_mean(:,idx) ;
SST_trim_mean_co2 = nansum(GW2_trim .* SST_POP_trim,2) ./ nansum(GW2_trim,2);

%%%%%%
cd ../neg_Slab_lay_strat_0_05_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
nn = 0 ;
for tt1=21:100
    nn = nn + 1;          
    filename1=aa1(tt1,1).name;
    sst =ncread(filename1,'SST') - 273.15; % 
    sst(sst > 1E4) = NaN ;
    sst(sst < -100) = NaN ;
    sst_all(:,:,nn) = sst ;
end
sst_mean = nanmean(sst_all,3) ;
SST_POP_trim = sst_mean(:,idx) ;
SST_trim_mean_0_05_n = nansum(GW2_trim .* SST_POP_trim,2) ./ nansum(GW2_trim,2);

%%%%%%
cd ../neg_Slab_lay_strat_0_1_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
nn = 0 ;
for tt1=21:100
    nn = nn + 1;          
    filename1=aa1(tt1,1).name;
    sst =ncread(filename1,'SST') - 273.15; % 
    sst(sst > 1E4) = NaN ;
    sst(sst < -100) = NaN ;
    sst_all(:,:,nn) = sst ;
end
sst_mean = nanmean(sst_all,3) ;
SST_POP_trim = sst_mean(:,idx) ;
SST_trim_mean_0_1_n = nansum(GW2_trim .* SST_POP_trim,2) ./ nansum(GW2_trim,2);

%%%%%%%%
cd ../neg_Slab_lay_strat_0_15_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
nn = 0 ;
for tt1=21:100
    nn = nn + 1;          
    filename1=aa1(tt1,1).name;
    sst =ncread(filename1,'SST') - 273.15; % 
    sst(sst > 1E4) = NaN ;
    sst(sst < -100) = NaN ;
    sst_all(:,:,nn) = sst ;
end
sst_mean = nanmean(sst_all,3) ;
SST_POP_trim = sst_mean(:,idx) ;
SST_trim_mean_0_15_n = nansum(GW2_trim .* SST_POP_trim,2) ./ nansum(GW2_trim,2);

%%%%%%%%
cd ../neg_Slab_lay_strat_0_2_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
nn = 0 ;
for tt1=21:100
    nn = nn + 1;          
    filename1=aa1(tt1,1).name;
    sst =ncread(filename1,'SST') - 273.15; % 
    sst(sst > 1E4) = NaN ;
    sst(sst < -100) = NaN ;
    sst_all(:,:,nn) = sst ;
end
sst_mean = nanmean(sst_all,3) ;
SST_POP_trim = sst_mean(:,idx) ;
SST_trim_mean_0_2_n = nansum(GW2_trim .* SST_POP_trim,2) ./ nansum(GW2_trim,2);

%%%%%%%%
cd ../ctrl_Slab_CHEY_PreIn
    aa1=dir('*anmn.nc');
nn = 0 ;
for tt1=21:100
    nn = nn + 1;          
    filename1=aa1(tt1,1).name;
    sst =ncread(filename1,'SST') - 273.15; % 
    sst(sst > 1E4) = NaN ;
    sst(sst < -100) = NaN ;
    sst_all(:,:,nn) = sst ;
end
sst_mean = nanmean(sst_all,3) ;
SST_POP_trim = sst_mean(:,idx) ;
SST_trim_mean_ctrl = nansum(GW2_trim .* SST_POP_trim,2) ./ nansum(GW2_trim,2);

%%%%%%
cd /homes/eerfani/Bias
load ('SST_Hadley.mat')
load('lat_HadI') ; load('lon_HadI')
load('latitude') ; load('longitude');
[lon_msh,lat_msh] = meshgrid(longitude,latitude);
 SST_mean_interp_HADI = griddata(double(lon_HadI),double(lat_HadI),SST_Hadley,lon_msh,lat_msh,'natural');
SST_mean_interp_HADI = SST_mean_interp_HADI' ;
GW_had = GW ;
II = find(isnan(SST_mean_interp_HADI)==1) ;
GW_had(II) = NaN ;
GW_trim_had = GW_had(:,idx) ;
SST_hadley_trim = SST_mean_interp_HADI(:,idx) ;
SST_hadley_trim_mean = nansum(GW_trim_had .* SST_hadley_trim,2) ./ nansum(GW_trim_had,2) ; 

%%%%%%%
       fig_name = strcat('SST_Longitude_last100_COMPARE_8_8_NS');%,num2str(tt));
        fig_dum = figure(2);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,0.5,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
tempp_ctrl = SST_trim_mean_ctrl(idy) ;
h001 = plot(lon2,tempp_ctrl,'m','linewidth',3) ;hold on
tempp_co2 = SST_trim_mean_co2(idy) ;
h000 = plot(lon2,tempp_co2,'k','linewidth',3) ;hold on
tempp = SST_trim_mean_0_05(idy) ;      
h100 = plot(lon2,tempp,'b','linewidth',3) ;hold on
tempp_10 = SST_trim_mean_0_1(idy) ;
h200 = plot(lon2,tempp_10,'r','linewidth',3) ;hold on
tempp_15 = SST_trim_mean_0_15(idy) ;
h250 = plot(lon2,tempp_15,'color',purple,'linewidth',3) ;hold on
tempp_20 = SST_trim_mean_0_2(idy) ;      
h300 = plot(lon2,tempp_20,'g','linewidth',3) ;hold on
tempp_n = SST_trim_mean_0_05_n(idy) ;      
h600 = plot(lon2,tempp_n,'--b','linewidth',3) ;hold on
tempp_10_n = SST_trim_mean_0_1_n(idy) ;
h700 = plot(lon2,tempp_10_n,'--r','linewidth',3) ;hold on
tempp_15_n = SST_trim_mean_0_15_n(idy) ;
h800 = plot(lon2,tempp_15_n,'--','color',purple,'linewidth',3) ;hold on
tempp_20_n = SST_trim_mean_0_2_n(idy) ;      
h900 = plot(lon2,tempp_20_n,'--g','linewidth',3) ;hold on
tempp_30 = SST_hadley_trim_mean(idy) ;
h500 = plot(lon2,tempp_30,'k-.','linewidth',3) ;
    xlabel('Longitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('SST (\circC)','fontsize',23,'fontweight','bold');
xlim([130 300])
ylim([23.8 34.2])
  hleg1 = legend([h001 h000 h900 h800 h700 h600 h100 h200 h250 h300 h500],'11','12',...
      '13','14','15','16','17','18','19','20','obs');
   set(hleg1,'Location','NorthEast','Fontsize',17)%h_legend-4)
   set(hleg1,'Interpreter','none')%,'box','Off')
set(gca,'FontSize',20,'linewidth',1.5)
box on
cd (address) 
  print ('-r600', fig_name,'-depsc')     
  
