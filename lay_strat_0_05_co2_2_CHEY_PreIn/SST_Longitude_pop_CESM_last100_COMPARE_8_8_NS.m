    clc
    clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn' ; cd (address)

aa=dir('*tavg.*.nc');
filename=aa(1,1).name;
TAREA=ncread(filename,'TAREA'); % surface net Shortwave Radiation (W/m2)
    latitude=ncread(filename,'TLAT'); % lat
    longitude=ncread(filename,'TLONG'); % lon
idx = find(latitude(68,:) >= -8 & latitude(68,:) <= 8) ;
idy = find(longitude(:,50) >= 130 & longitude(:,50) <= 280) ;
lon = longitude(idy,50) ;

cases = {'lay_strat_0_05_co2_2_CHEY_PreIn','lay_strat_0_1_co2_2_CHEY_PreIn',...
    'lay_strat_0_15_co2_2_CHEY_PreIn','2lay_strat_0_2_co2_2_CHEY_PreIn',...
    'chey_co2_2_rhminl_PreIn',...
    'neg_lay_strat_0_05_co2_2_CHEY_PreIn','neg_lay_strat_0_1_co2_2_CHEY_PreIn'...
    'neg_lay_strat_0_15_co2_2_CHEY_PreIn','neg_lay_strat_0_2_co2_2_CHEY_PreIn'...
    'PreInd_chey_contr'} ;
cd ..

for i = 1:length(cases)
cd (char(cases(:,i)))
aa=dir('*tavg.*.nc');
    filename=aa(1,1).name;
    var=ncread(filename,'TEMP'); % surface net Shortwave Radiation (W/m2)
    var(var > 1E4) = NaN ;  
    var_all = var(:,:,1) ;    
TAREA2 = TAREA ;
II = find(isnan(var_all)==1) ;
TAREA2(II) = NaN ;
TAREA2_trim = TAREA2(:,idx) ;
var_trim = var_all(:,idx) ;
var_trim_mean(i,:) = nansum(TAREA2_trim .* var_trim ,2) ./ nansum(TAREA2_trim,2) ; 
cd ..
end

%%%%%
cd /homes/eerfani/Bias
load ('SST_Hadley_interp.mat')
TAREA2 = TAREA ;
II = find(isnan(SST_mean_interp)==1) ;
TAREA2(II) = NaN ;
TAREA2_trim = TAREA2(:,idx) ;
SST_hadley_trim = SST_mean_interp(:,idx) ;
SST_hadley_trim_mean = nansum(TAREA2_trim .* SST_hadley_trim,2) ./ nansum(TAREA2_trim,2) ; 

%%%%%%%
       fig_name = strcat('SST_Longitude_last100_COMPARE_neg_pos_8_8_NS');%,num2str(tt));
        fig_dum = figure(2);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,0.5,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
cl = ['b','r','m','g','k','b','r','m','g']; 
nb = [7:10 2 6:-1:3 1] ;

for j = 1:5
if (j==3)
    h(j)=plot(lon,squeeze(var_trim_mean(j,idy)),'color',purple,'linewidth',3) ; hold on;
else
    h(j)=plot(lon,squeeze(var_trim_mean(j,idy)),'color',cl(j),'linewidth',3) ; hold on;
end
end
for j = 6:9
if (j==8)
    h(j)=plot(lon,squeeze(var_trim_mean(j,idy)),'--','color',purple,'linewidth',3) ; hold on;
else    
    h(j)=plot(lon,squeeze(var_trim_mean(j,idy)),'--','color',cl(j),'linewidth',3) ; hold on;
end
end

 h(10)=plot(lon,squeeze(var_trim_mean(10,idy)),'m','linewidth',3) ; hold on;
 h(11)=plot(lon,squeeze(SST_hadley_trim_mean(idy)),'k-.','linewidth',3) ; hold on;

    xlabel('Longitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('SST (\circC)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h(10) h(5) h(9) h(8) h(7) h(6) h(1) h(2) h(3) h(4) h(11)],'1','2',...
         '3','4','5','6','7','8','9','10','obs');% ,'SOM');
    set(hleg1,'Location','NorthEast','Fontsize',17)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')
set(gca,'Fontsize',20,'linewidth',1.5)
xlim([130 300])
ylim([23.8 34.2])
box on
cd (address)
  print ('-r600', fig_name,'-depsc')     
