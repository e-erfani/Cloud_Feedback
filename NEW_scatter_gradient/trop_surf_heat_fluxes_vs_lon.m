clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient
  aa=dir('*_tavg.*.nc');
  
%%%% meridional SST
for i = 1:10
    fname = aa(i,1).name;
       
    lon=ncread(fname,'TLONG'); lon_mm = nanmean(lon,2);
    lat=ncread(fname,'TLAT');
    area=ncread(fname,'TAREA');
    EVAP_F=ncread(fname,'EVAP_F'); % Evaporation Flux from Coupler: kg/m^2/s
    lat_ht_vap=ncread(fname,'latent_heat_vapor'); % Latent Heat of Vaporization: J/kg
    SENH_F=ncread(fname,'SENH_F');
    SW_N=ncread(fname,'SHF_QSW'); % Solar Short-Wave Heat Flux
    QFLUX=ncread(fname,'QFLUX'); 
    LW_u=ncread(fname,'LWUP_F');
    LW_d=ncread(fname,'LWDN_F');
    
    EVAP_F(EVAP_F > 1.0E+30) = NaN; SENH_F(SENH_F > 1.0E+30) = NaN;  
    SW_N(SW_N > 1.0E+30) = NaN; QFLUX(QFLUX > 1.0E+30) = NaN;  
    LW_u(LW_u > 1.0E+30) = NaN; LW_d(LW_d > 1.0E+30) = NaN;  

    latent =  EVAP_F .* lat_ht_vap;
    LW_N = -LW_u - LW_d ;
    
    area2 = area;
    I = find(isnan(SW_N) == 1);
    area2(I) = NaN;
    
      mask=zeros(size(area2));
      J = find (lat>=-8 & lat<=8);
      mask(J)=1; clear J
      B = find (mask==0);
      SW_N(B) = NaN; LW_N(B) = NaN; latent(B) = NaN; QFLUX(B) = NaN; 
      SENH_F(B) = NaN; EVAP_F(B) = NaN; clear B
      SW_N_mm = nanmean(SW_N,2); LW_N_mm = nanmean(LW_N,2); 
      latent_mm = nanmean(latent,2); QFLUX_mm = nanmean(QFLUX,2);
      SENH_F_mm = nanmean(SENH_F,2); 
      
    %%%%%      
      fig_name = strcat('ht_flx_',fname(4:13));%,num2str(tt));
      fig_dum = figure(i);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,1,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
      
    h1=plot(lon_mm,SW_N_mm,'o','markers',5); hold on
    set(h1,'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',4)
    h2=plot(lon_mm,latent_mm,'o','markers',5); hold on
    set(h2,'MarkerEdgeColor','b','MarkerFaceColor','b','LineWidth',4)
    h3=plot(lon_mm,QFLUX_mm,'o','markers',5); hold on
    set(h3,'MarkerEdgeColor','r','MarkerFaceColor','r','LineWidth',4)
    h4=plot(lon_mm,LW_N_mm,'o','markers',5); hold on
    set(h4,'MarkerEdgeColor','g','MarkerFaceColor','g','LineWidth',4)
    h5=plot(lon_mm,SENH_F_mm,'o','markers',5); hold on
    set(h5,'MarkerEdgeColor','c','MarkerFaceColor','c','LineWidth',4)

    xlabel('longitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('Energy Flux (W m^-^2)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2 h3 h4 h5],'net SW','latent','Q-flux','net LW','sensible');
    set(gca,'Fontsize',20,'linewidth',1.5)
    set(hleg1,'Fontsize',16,'linewidth',1.5,'Location','NorthWest')
  set(gca,'Fontsize',25,'linewidth',2)
  box on
xlim([0 370])
ylim([-150 250])
%set(gca,'XTick',[17 18 19 20 21 22 23 24 25 26])
%set(gca,'YTick',24:2:40)
%  eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
 clear SW_N_mm SW_N LW_N_mm LW_N QFLUX_mm QFLUX latent latent_mm SENSH_F SENH_F_mm EVAP_F LW_d LW_u
end
    