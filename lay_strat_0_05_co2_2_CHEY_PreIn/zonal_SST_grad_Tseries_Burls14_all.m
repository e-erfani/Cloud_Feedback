clc 
clear 
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn'; cd (address)
 
 cases = {'chey_co2_2_rhminl_PreIn','neg_lay_strat_0_2_co2_2_CHEY_PreIn',...
    'neg_lay_strat_0_15_co2_2_CHEY_PreIn','neg_lay_strat_0_1_co2_2_CHEY_PreIn',...
    'neg_lay_strat_0_05_co2_2_CHEY_PreIn','lay_strat_0_05_co2_2_CHEY_PreIn',...
    'lay_strat_0_1_co2_2_CHEY_PreIn','lay_strat_0_15_co2_2_CHEY_PreIn','2lay_strat_0_2_co2_2_CHEY_PreIn'} ;

cd ..
for i = 1:9
cd (char(cases(:,i)))
if (i==9)
    aa1 = dir('lay*pop*anmn.nc'); aa2 = dir('2lay*pop*anmn.nc'); aa = [aa1; aa2];
else
    aa=dir('*pop*anmn.nc');
end
  for tt1=1:length(aa)
    filename=aa(tt1,1).name;
    lat =ncread(filename,'TLAT');
    lon =ncread(filename,'TLONG');
    area=ncread(filename,'TAREA'); % surface net Shortwave Radiation (W/m2)
  
    ncid = netcdf.open(filename,'nowrite');
    varid = netcdf.inqVarID(ncid,'TEMP');
    SST1=netcdf.getVar(ncid,varid,'double');

    clear ncid varid missing_value I 
    SST1(SST1 > 1E4) = NaN ;
    SST1(SST1 < -100) = NaN ;
    SST=squeeze(SST1(:,:,1));
    I=find(isnan(SST)==1);
    area(I)=NaN;
    % set tropical Pacific to 2
      mask=zeros(size(SST));
      J = find (lat>-8 & lat<8 & lon>130 & lon<205);
      mask(J)=2; clear J
      B = find (mask==2);
      T1=nansum(SST(B).*area(B))./nansum(area(B));
      clear B mask
    % set extratropical Pacific to 2 
      mask=zeros(size(SST));
      J = find (lat>-8 & lat<8 & lon>205 & lon<280);
      mask(J)=2; clear J
      B = find (mask==2);
      T2=nansum(SST(B).*area(B))./nansum(area(B));
      clear B mask

      grad_SST_Tseries(tt1,i) = T1 - T2;
    
  end
  cd ..
end
%grad_SST_Tseries = grad_SST_Tseries' ;
%%%%%%
time = 1:length(aa) ;
       fig_name = strcat('zonal_grad_SST_Tseries_Burls2014_all');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
h1 = plot(time,squeeze(grad_SST_Tseries(:,1)),'k','linewidth',3) ; hold on;
h2 = plot(time,squeeze(grad_SST_Tseries(:,2)),'--g','linewidth',3) ;hold on
h3 = plot(time,squeeze(grad_SST_Tseries(:,3)),'--','color',purple,'linewidth',3) ; hold on  
h4 = plot(time,squeeze(grad_SST_Tseries(:,4)),'--r','linewidth',3) ; hold on
h5 = plot(time,squeeze(grad_SST_Tseries(:,5)),'--b','linewidth',3) ; hold on
h6 = plot(time,squeeze(grad_SST_Tseries(:,6)),'b','linewidth',3) ;hold on
h7 = plot(time,squeeze(grad_SST_Tseries(:,7)),'r','linewidth',3) ; hold on
h8 = plot(time,squeeze(grad_SST_Tseries(:,8)),'color',purple,'linewidth',3) ; hold on
h9 = plot(time,squeeze(grad_SST_Tseries(:,9)),'g','linewidth',3) ; hold on
    xlabel('Time (year)','fontsize',23,'fontweight','bold');
    ylabel('Zonal SST gradient (\circC)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2 h3 h4 h5 h6 h7 h8 h9],'2',...
         '3','4','5','6','7','8','9','10');% ,'SOM');
    set(hleg1,'Location','NorthEast','Fontsize',17)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')        
 set(gca,'FontSize',20,'linewidth',1.5)
  ylim([1.1 3.1])
  xlim([-2 115])
  box on
cd (address)  
  print ('-r600', fig_name,'-depsc')     
  
%%%%%%
grad_SST_Tseries = grad_SST_Tseries' ;
smt = 10 ;
var_Tseries2(1:size(grad_SST_Tseries,1),1:size(grad_SST_Tseries,2)+2*smt) = NaN ;
for i = 1:size(grad_SST_Tseries,1)
  for j=1:size(grad_SST_Tseries,2)
    var_Tseries2(i,j+smt) = grad_SST_Tseries(i,j) ;
  end
    var_Tseries_smooth(i,:) = smooth(var_Tseries2(i,:),smt);
end

var_Tseries_smooth(:,1:smt) = [] ;
var_Tseries_smooth(:,end-smt+1:end) = [] ;
var_Tseries_smooth = var_Tseries_smooth' ;
%%%%%%
%time = 1:length(aa) ;
       fig_name = strcat('zonal_grad_SST_Tseries_Burls2014_smooth_10_all');%,num2str(tt));
        fig_dum = figure(2);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
h1 = plot(time,squeeze(var_Tseries_smooth(:,1)),'k','linewidth',3) ; hold on;
h2 = plot(time,squeeze(var_Tseries_smooth(:,2)),'--g','linewidth',3) ;hold on
h3 = plot(time,squeeze(var_Tseries_smooth(:,3)),'--','color',purple,'linewidth',3) ; hold on  
h4 = plot(time,squeeze(var_Tseries_smooth(:,4)),'--r','linewidth',3) ; hold on
h5 = plot(time,squeeze(var_Tseries_smooth(:,5)),'--b','linewidth',3) ; hold on
h6 = plot(time,squeeze(var_Tseries_smooth(:,6)),'b','linewidth',3) ;hold on
h7 = plot(time,squeeze(var_Tseries_smooth(:,7)),'r','linewidth',3) ; hold on
h8 = plot(time,squeeze(var_Tseries_smooth(:,8)),'color',purple,'linewidth',3) ; hold on
h9 = plot(time,squeeze(var_Tseries_smooth(:,9)),'g','linewidth',3) ; hold on
    xlabel('Time (year)','fontsize',23,'fontweight','bold');
    ylabel('Zonal SST gradient (\circC)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2 h3 h4 h5 h6 h7 h8 h9],'2',...
         '3','4','5','6','7','8','9','10');% ,'SOM');
    set(hleg1,'Location','NorthEast','Fontsize',17)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')        
 set(gca,'FontSize',20,'linewidth',1.5)
 % ylim([16.4 26])
  xlim([-2 115])
  box on
cd (address)  
  print ('-r600', fig_name,'-depsc')     
    