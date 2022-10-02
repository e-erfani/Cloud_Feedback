clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient

sst_fcm = [18.78    18.08   18.20   18.32   18.52   19.31   20.63   23.11   24.41...
            16.6	16.53	16.51	16.53	16.53	16.6	16.61	16.59	16.6];

sst_som = [18.5     17.74	17.86	18      18.22	20.99	22.98	24.97	25.71...
           16.38	16.37	16.37	16.38	16.38	16.42	16.48	16.64	16.81];

%%%%
    aa=dir('*_tavg.*.nc');
    fname = aa(1,1).name;

for i = 1:10
    fname = aa(i,1).name;
    grad_SST = get_zon_SST_grad_burls2014(fname);
 
 Pac_meri_grad_UO_fcm_temp(i) = grad_SST;  
end
    
Pac_meri_grad_UO_fcm_temp(2) = [];
Pac_meri_grad_UO_fcm = Pac_meri_grad_UO_fcm_temp ;
nn = 2;
for i = 5:-1:2
  Pac_meri_grad_UO_fcm(nn) = Pac_meri_grad_UO_fcm_temp(i) ;
  nn = nn + 1 ;
end
%%%%

   aa=dir('sst_CO_sl*'); load('lat_msh_CAM.mat'); load('lon_msh_CAM.mat'); load('GW.mat')
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
     grad_SST_SOM = get_zon_SST_grad_SOM_burls2014(sst,lat_msh_CAM,lon_msh_CAM,GW);

 dSST_m_temp(tt) = grad_SST_SOM;
end     

dSST_m_temp(2) = [];
nn = 2 ;
dSST_m = dSST_m_temp ;
for i = 5:-1:2
  dSST_m(nn) = dSST_m_temp(i) ;
  nn = nn + 1 ;
end

%%% calculate and add scaling factor to plot   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fname_som = { 'neg_Slab_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
             'neg_Slab_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
              'neg_Slab_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
             'neg_Slab_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
                                  'co2_Slab_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
                 'Slab_lay_strat_0_05_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
                  'Slab_lay_strat_0_1_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
                 'Slab_lay_strat_0_15_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc',...
                  'Slab_lay_strat_0_2_co2_2_CHEY_PreInd_T31_gx3v7.cam.h0.0121-0200._ANN_climo.nc'};

 Lv = 2260 ;
 Rv = 461 ;
 
for i = 1:9
    fname = char(fname_som(:,i));
    lon1=ncread(fname,'lon'); 
    lat1=ncread(fname,'lat');
     [lat,lon]=meshgrid(lat1,lon1);
     gw=ncread(fname,'gw');
     I=length(lon1);
     area=repmat(gw,[1 I])';
    TS=ncread(fname,'TS'); 
    PS=ncread(fname,'PS');
     ps=100000; % Pa    
  %   TS(-TS > 1.0E+30) = NaN; PS(-PS > 1.0E+30) = NaN;     
    TS_c = TS - 273.15 ;
    es = 1000.0 .* 0.6112 .* exp(17.67 .* TS_c ./ (TS_c + 243.5)) ;
    qs = 0.622 .* es ./ ps ;
    
    des_dT = es .* Lv ./ (Rv .* TS .^ 2.0) ;
    dqs_dT = (0.622 ./ ps) .* des_dT ;
    
    
     % set 1st region in tropical Pacific to 2
      mask=zeros(size(TS));
      J = find (lat>-8 & lat<8 & lon>130 & lon<205);
      mask(J)=2; clear J
      B = find (mask==2);
      qs_1=nansum(qs(B).*area(B))./nansum(area(B));
      dqs_dT_1=nansum(dqs_dT(B).*area(B))./nansum(area(B));
      clear B mask
     % set 2nd region in tropical Pacific to 2
      mask=zeros(size(TS));
      J = find (lat>-8 & lat<8 & lon>205 & lon<280);
      mask(J)=2; clear J
      B = find (mask==2);
      qs_2=nansum(qs(B).*area(B))./nansum(area(B));
      dqs_dT_2=nansum(dqs_dT(B).*area(B))./nansum(area(B));
      clear B mask
    
      d_qs(i) = qs_1 - qs_2;
      dqs_dT_mean(i) = (dqs_dT_1 + dqs_dT_2) ./ 2;   
end
    d_qs_mean = nanmean(d_qs);
%    d_qs_mean = d_qs(5);
    scaling = d_qs_mean .* dqs_dT_mean .^ (-1) ./ 1000; 
    
sst_som2 = [17.74	17.86	18      18.22	18.5     20.99	22.98	24.97	25.71...
           16.38	16.37	16.37	16.38	16.38	16.42	16.48	16.64	16.81];
    
%%%%%%%
       fig_name = strcat('zonal_grad_vs_GSST_scaling');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
      
    h1=plot(sst_fcm(1:9),Pac_meri_grad_UO_fcm,'o','markers',13); hold on
    set(h1,'MarkerEdgeColor','k','MarkerFaceColor','b','LineWidth',1)

    h2=plot(sst_som(1:9),dSST_m,'o','markers',13); hold on
    set(h2,'MarkerEdgeColor','k','MarkerFaceColor','r','LineWidth',1)

    h3 = plot(sst_som2(1:9),scaling,'color',purple,'LineWidth',3); hold on
    
   x = xlabel('Global SST (\circC)','fontsize',23,'fontweight','bold');
   y = ylabel('\DeltaT_z_o_n_a_l (\circC)','fontsize',23,'fontweight','bold');
   set(x, 'Units', 'Normalized', 'Position', [0.5, -0.085, 0]);
   hleg1 = legend([h1 h2 h3],'FCM','SOM', 'scaling factor');
    set(gca,'Fontsize',23,'linewidth',2)
    set(hleg1,'Fontsize',20,'linewidth',2)
    box on
xlim([17 26])
ylim([0.6 2.6])
set(gca,'XTick',[17 18 19 20 21 22 23 24 25 26])
set(gca,'YTick',0.6:0.4:2.6)
  eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  