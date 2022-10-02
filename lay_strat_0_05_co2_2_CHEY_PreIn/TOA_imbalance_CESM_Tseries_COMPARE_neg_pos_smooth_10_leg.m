clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn' ; cd (address)
    aa=dir('*anmn.nc');
    tt=1; % ncdisp(aa(tt,1).name)
    filename=aa(tt,1).name;
  gw=ncread(filename,'gw'); % surface net Shortwave Radiation (W/m2)
    lat =ncread(filename,'lat');
    lon =ncread(filename,'lon');
[lon_msh,lat_msh] = meshgrid(lon,lat);
      I=length(lon);
      GW=repmat(gw,[1 I])';

cases = {'lay_strat_0_05_co2_2_CHEY_PreIn','lay_strat_0_1_co2_2_CHEY_PreIn',...
    'lay_strat_0_15_co2_2_CHEY_PreIn','lay_strat_0_2_co2_2_CHEY_PreIn',...
    'chey_co2_2_rhminl_PreIn',...
    'neg_lay_strat_0_05_co2_2_CHEY_PreIn','neg_lay_strat_0_1_co2_2_CHEY_PreIn'...
    'neg_lay_strat_0_15_co2_2_CHEY_PreIn','neg_lay_strat_0_2_co2_2_CHEY_PreIn'} ;
cd ..
for i = 1:length(cases)
cd (char(cases(:,i)))
if (i==4)
    aa1 = dir('lay*cam*anmn.nc'); aa2 = dir('2lay*cam*anmn.nc'); aa = [aa1; aa2];
else
    aa=dir('*cam*anmn.nc');
end
for tt=1:length(aa)
    filename=aa(tt,1).name;
    fsnt =ncread(filename,'FSNT'); 
    flnt =ncread(filename,'FLNT'); 
    var_all(:,:,tt) = fsnt - flnt ;

    II=find(isnan(var_all(:,:,tt))==1);
    GW2 = GW ;
    GW2(II)=nan;
    var_Tseries(i,tt) = nansum(nansum(GW2 .* var_all(:,:,tt),1),2) ./ nansum(nansum(GW2,1),2) ;
end
cd ..
end

%%%%%%
smt = 10 ;
var_Tseries2(1:size(var_Tseries,1),1:size(var_Tseries,2)+2*smt) = NaN ;
for i = 1:size(var_Tseries2,1)
  for j=1:size(var_Tseries,2)
    var_Tseries2(i,j+smt) = var_Tseries(i,j) ;
  end
    var_Tseries_smooth(i,:) = smooth(var_Tseries2(i,:),smt);
end

var_Tseries_smooth(:,1:smt) = [] ;
var_Tseries_smooth(:,end-smt+1:end) = [] ;

time = 1:size(var_Tseries_smooth,2) ;
       fig_name = strcat('TOA_imblnc_TIME_SERIES_GLOBAL_neg_pos_smooth_10_1800');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
cl = ['b','r','m','g','k','b','r','m','g']; 
%st = ['-','-','-','-','-','--','--','--','--'] ;
nb = [7:10 2 6:-1:3] ;
for j = 1:5
if (j==3)
    h(j)=plot(time(1:end-5),squeeze(var_Tseries_smooth(j,1:end-5)),'color',purple,'linewidth',1.5) ; hold on;
else
    h(j)=plot(time(1:end-5),squeeze(var_Tseries_smooth(j,1:end-5)),'color',cl(j),'linewidth',1.5) ; hold on;
end
end
for j = 6:9
if (j==8)
    h(j)=plot(time(1:end-5),squeeze(var_Tseries_smooth(j,1:end-5)),'--','color',purple,'linewidth',1.5) ; hold on;
else    
    h(j)=plot(time(1:end-5),squeeze(var_Tseries_smooth(j,1:end-5)),'--','color',cl(j),'linewidth',1.5) ; hold on;
end
end
    xlabel('Time (year)','fontsize',23,'fontweight','bold');
    ylabel('Global TOA imbalance (Wm^-^2)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h(5) h(9) h(8) h(7) h(6) h(1) h(2) h(3) h(4)],'2',...
         '3','4','5','6','7','8','9','10');% ,'SOM');
    set(hleg1,'Location','NorthEast','Fontsize',16)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')        
 set(gca,'FontSize',20,'linewidth',1.5)
  ylim([-0.2 3])
  xlim([-30 1860])
  box on
cd (address) 
print ('-r600', fig_name,'-depsc')     
  