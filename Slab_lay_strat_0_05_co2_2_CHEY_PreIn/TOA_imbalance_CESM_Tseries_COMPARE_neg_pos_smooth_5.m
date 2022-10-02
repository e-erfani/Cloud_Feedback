clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/Slab_lay_strat_0_05_co2_2_CHEY_PreIn' ; cd (address)
    aa=dir('*anmn.nc');
    tt=1; % ncdisp(aa(tt,1).name)
    filename=aa(tt,1).name;
  gw=ncread(filename,'gw'); % surface net Shortwave Radiation (W/m2)
    lat =ncread(filename,'lat');
    lon =ncread(filename,'lon');
[lon_msh,lat_msh] = meshgrid(lon,lat);
      I=length(lon);
      GW=repmat(gw,[1 I])';

cases = {'Slab_lay_strat_0_05_co2_2_CHEY_PreIn','Slab_lay_strat_0_1_co2_2_CHEY_PreIn',...
    'Slab_lay_strat_0_15_co2_2_CHEY_PreIn','Slab_lay_strat_0_2_co2_2_CHEY_PreIn',...
    'co2_Slab_CHEY_PreIn',...
    'neg_Slab_lay_strat_0_05_co2_2_CHEY_PreIn','neg_Slab_lay_strat_0_1_co2_2_CHEY_PreIn'...
    'neg_Slab_lay_strat_0_15_co2_2_CHEY_PreIn','neg_Slab_lay_strat_0_2_co2_2_CHEY_PreIn'} ;
cd ..
for i = 1:length(cases)
cd (char(cases(:,i)))
    aa=dir('*cam*anmn.nc');
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
smt = 5 ;
var_Tseries2(1:size(var_Tseries,1),1:size(var_Tseries,2)+2*smt) = NaN ;
% for j=1:smt
%     var_Tseries2(:,j) = nanmean(var_Tseries(:,1:smt),2);
%     var_Tseries2(:,end-j+1) = nanmean(var_Tseries(:,end-smt+1:end),2);
% end
for i = 1:size(var_Tseries2,1)
  for j=1:size(var_Tseries,2)
    var_Tseries2(i,j+smt) = var_Tseries(i,j) ;
  end
    var_Tseries_smooth(i,:) = smooth(var_Tseries2(i,:),smt);
end

var_Tseries_smooth(:,1:smt) = [] ;
var_Tseries_smooth(:,end-smt+1:end) = [] ;

time = 1:100 ;
       fig_name = strcat('TOA_imblnc_TIME_SERIES_GLOBAL_neg_pos_smooth_5');%,num2str(tt));
        fig_dum = figure(3);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
cl = ['b','r','m','g','k','b','r','m','g']; 
%st = ['-','-','-','-','-','--','--','--','--'] ;
nb = [17:20 12 16:-1:13] ;
for j = 1:5
if (j==1)
    plot(time,squeeze(var_Tseries_smooth(j,:)),'color',cl(j),'linewidth',1) ; hold on;
    text(time(end)+10,double(var_Tseries_smooth(j,end)),num2str(nb(j)),'color',cl(j),'FontSize',18); hold on
elseif (j==3)
    plot(time,squeeze(var_Tseries_smooth(j,:)),'color',purple,'linewidth',1) ; hold on;
    text(time(end)+0.5,double(var_Tseries_smooth(j,end)),num2str(nb(j)),'color',purple,'FontSize',18); hold on
elseif (j==5)
    plot(time,squeeze(var_Tseries_smooth(j,:)),'color',cl(j),'linewidth',1) ; hold on;
    text(time(end)+5,double(var_Tseries_smooth(j,end)),num2str(nb(j)),'color',cl(j),'FontSize',18); hold on
else    
    plot(time,squeeze(var_Tseries_smooth(j,:)),'color',cl(j),'linewidth',1) ; hold on;
    text(time(end)+0.5,double(var_Tseries_smooth(j,end)),num2str(nb(j)),'color',cl(j),'FontSize',18); hold on
end
end
for j = 6:9
if (j==6)
    plot(time,squeeze(var_Tseries_smooth(j,:)),'--','color',cl(j),'linewidth',1) ; hold on;
    text(time(end)+10,double(var_Tseries_smooth(j,end)),num2str(nb(j)),'color',cl(j),'FontSize',18); hold on
elseif (j==7)
    plot(time,squeeze(var_Tseries_smooth(j,:)),'--','color',cl(j),'linewidth',1) ; hold on;
    text(time(end)+0.5,double(var_Tseries_smooth(j,end))+0.1,num2str(nb(j)),'color',cl(j),'FontSize',18); hold on
elseif (j==8)
    plot(time,squeeze(var_Tseries_smooth(j,:)),'--','color',purple,'linewidth',1) ; hold on;
    text(time(end)+5,double(var_Tseries_smooth(j,end)),num2str(nb(j)),'color',purple,'FontSize',18); hold on
else    
    plot(time,squeeze(var_Tseries_smooth(j,:)),'--','color',cl(j),'linewidth',1) ; hold on;
    text(time(end)+0.5,double(var_Tseries_smooth(j,end)),num2str(nb(j)),'color',cl(j),'FontSize',18); hold on
end
end
    xlabel('Time (year)','fontsize',23,'fontweight','bold');
    ylabel('Global TOA imbalance (Wm^-^2)','fontsize',23,'fontweight','bold');
    set(gca,'FontSize',20,'linewidth',1.5)
  ylim([-0.5 3.5])
  xlim([-2 115])
  box on
cd (address) 
print ('-r600', fig_name,'-depsc')     
  