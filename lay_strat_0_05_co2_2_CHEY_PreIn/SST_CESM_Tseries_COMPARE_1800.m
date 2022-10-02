clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn' ; cd (address)
    aa=dir('*pop*anmn.nc');
     tt=1; % ncdisp(aa(tt,1).name)
    filename=aa(tt,1).name;
  TAREA=ncread(filename,'TAREA'); % surface net Shortwave Radiation (W/m2)
    lat_msh =ncread(filename,'TLAT');
    lon_msh =ncread(filename,'TLONG');

cases = {'lay_strat_0_05_co2_2_CHEY_PreIn','lay_strat_0_1_co2_2_CHEY_PreIn',...
    'lay_strat_0_15_co2_2_CHEY_PreIn','2lay_strat_0_2_co2_2_CHEY_PreIn',...
    'chey_co2_2_rhminl_PreIn',...
    'neg_lay_strat_0_05_co2_2_CHEY_PreIn','neg_lay_strat_0_1_co2_2_CHEY_PreIn'...
    'neg_lay_strat_0_15_co2_2_CHEY_PreIn','neg_lay_strat_0_2_co2_2_CHEY_PreIn'} ;
cd ..

for i = 1:length(cases)
cd (char(cases(:,i)))
if (i==4)
    aa1 = dir('lay*pop*anmn.nc'); aa2 = dir('2lay*pop*anmn.nc'); aa = [aa1; aa2];
else
    aa=dir('*pop*anmn.nc');
end
for tt=1:length(aa)
    filename=aa(tt,1).name;
    var=ncread(filename,'TEMP'); % ocn temp
    var(var > 1E4) = NaN ;  
    var_all(:,:,tt) = var(:,:,1) ;   

    II=find(isnan(var_all(:,:,tt))==1);
    TAREA2 = TAREA ;
    TAREA2(II)=nan;
    var_Tseries(i,tt) = nansum(nansum(TAREA2 .* var_all(:,:,tt),1),2) ./ nansum(nansum(TAREA2,1),2) ;     
end
cd ..
end

%%%%%%
time = 1:size(var_Tseries,2) ;
fig_name = strcat('SST_TIME_SERIES_GLOBAL_neg_pos_1800');%,num2str(tt));
        fig_dum = figure(3);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
cl = ['b','r','m','g','k','b','r','m','g']; 
%st = ['-','-','-','-','-','--','--','--','--'] ;
nb = [7:10 2 6:-1:3] ;
for j = 1:5
if (j==3)
    h(j)=plot(time,squeeze(var_Tseries(j,:)),'color',purple,'linewidth',1) ; hold on;
else    
    h(j)=plot(time,squeeze(var_Tseries(j,:)),'color',cl(j),'linewidth',1) ; hold on;
end
end
for j = 6:9
if (j==8)
    h(j)=plot(time,squeeze(var_Tseries(j,:)),'--','color',purple,'linewidth',1) ; hold on;
else    
    h(j)=plot(time,squeeze(var_Tseries(j,:)),'--','color',cl(j),'linewidth',1) ; hold on;
end
end
    xlabel('Time (year)','fontsize',23,'fontweight','bold');
    ylabel('Global SST (\circC)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h(5) h(9) h(8) h(7) h(6) h(1) h(2) h(3) h(4)],'2',...
         '3','4','5','6','7','8','9','10');% ,'SOM');
    set(hleg1,'Location','northwest','Fontsize',15)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')    
 set(gca,'FontSize',20,'linewidth',1.5)
  ylim([16.7 25])
  xlim([-100 1860])
  box on
cd (address) 
print ('-r600', fig_name,'-depsc')     
  