clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn' ; cd (address)
    aa=dir('*pop*anmn.nc');
     tt=1; % ncdisp(aa(tt,1).name)
    filename=aa(tt,1).name;
  TAREA=ncread(filename,'TAREA'); % surface net Shortwave Radiation (W/m2)
    lat =ncread(filename,'TLAT');
    lon =ncread(filename,'TLONG');

cases = {'lay_strat_0_05_co2_2_CHEY_PreIn','lay_strat_0_1_co2_2_CHEY_PreIn',...
    'lay_strat_0_15_co2_2_CHEY_PreIn','2lay_strat_0_2_co2_2_CHEY_PreIn',...
    'chey_co2_2_rhminl_PreIn',...
    'neg_lay_strat_0_05_co2_2_CHEY_PreIn','neg_lay_strat_0_1_co2_2_CHEY_PreIn'...
    'neg_lay_strat_0_15_co2_2_CHEY_PreIn','neg_lay_strat_0_2_co2_2_CHEY_PreIn'} ;
cd ..

for i = 4 % 1:length(cases)
cd (char(cases(:,i)))
if (i==4)
    aa1 = dir('lay*pop*anmn.nc'); aa2 = dir('2lay*pop*anmn.nc'); aa = [aa1; aa2];
else
    aa=dir('*pop*anmn.nc');
end
for tt=1:length(aa)
    filename=aa(tt,1).name;
    tmp=ncread(filename,'TEMP'); % ocn temp
    tmp(tmp > 1E4) = NaN ;  
    var = tmp(:,:,1) ; 
    
    II=find(isnan(var)==1);
    TAREA2 = TAREA ;
    TAREA2(II)=nan;
    %global
    var_Tser_glob(i,tt) = nansum(nansum(TAREA2 .* var,1),2) ./ nansum(nansum(TAREA2,1),2) ;     
    % tropics   
    mask=zeros(size(var));
    J = find (lat>-30 & lat<30);
    mask(J)=2; clear J
    B = find (mask==2);
    var_Tser_trop(i,tt) = nansum(TAREA2(B) .* var(B)) ./ nansum(TAREA2(B)) ;     
    clear B mask    
    % NH   
    mask=zeros(size(var));
    J = find (lat > 0);
    mask(J)=2; clear J
    B = find (mask==2);
    var_Tser_NH(i,tt) = nansum(TAREA2(B) .* var(B)) ./ nansum(TAREA2(B)) ;     
    clear B mask     
    % SH   
    mask=zeros(size(var));
    J = find (lat < 0);
    mask(J)=2; clear J
    B = find (mask==2);
    var_Tser_SH(i,tt) = nansum(TAREA2(B) .* var(B)) ./ nansum(TAREA2(B)) ;     
    clear B mask    
    % SH, South of 30S  
    mask=zeros(size(var));
    J = find (lat < -30);
    mask(J)=2; clear J
    B = find (mask==2);
    var_Tser_south_30S(i,tt) = nansum(TAREA2(B) .* var(B)) ./ nansum(TAREA2(B)) ;     
    clear B mask 
    % SH, between 50S and 70S  
    mask=zeros(size(var));
    J = find (lat < -50 & lat > -70);
    mask(J)=2; clear J
    B = find (mask==2);
    var_Tser_50_70S(i,tt) = nansum(TAREA2(B) .* var(B)) ./ nansum(TAREA2(B)) ;     
    clear B mask    
end
cd ..
end
var_Tser_glob_last100 = 0.01 .* nanmean(var_Tser_glob(i,end-100:end),2);
%%%%%%
time = 1:size(var_Tser_glob,2) ;
%fig_name = strcat('SST_T_SERIES_1800_REGIONS_0_2');%,num2str(tt));
fig_name = strcat('SST_T_SERIES_1800_REGIONS_0_2_relative');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
cl = ['b','r','m','g','k','b','r','m','g']; 
%st = ['-','-','-','-','-','--','--','--','--'] ;
nb = [7:10 2 6:-1:3] ;

h6=plot(time,squeeze(100.*var_Tser_50_70S(i,:) ./ nanmean(var_Tser_50_70S(i,end-100:end),2)),'c','linewidth',2) ; hold on;
h5=plot(time,squeeze(100.*var_Tser_south_30S(i,:) ./ nanmean(var_Tser_south_30S(i,end-100:end),2)),'g','linewidth',2) ; hold on;
h1=plot(time,squeeze(var_Tser_glob(i,:) ./ var_Tser_glob_last100),'k','linewidth',2) ; hold on;
h2=plot(time,squeeze(100.*var_Tser_NH(i,:) ./ nanmean(var_Tser_NH(i,end-100:end),2)),'r','linewidth',2) ; hold on;
h3=plot(time,squeeze(100.*var_Tser_SH(i,:) ./ nanmean(var_Tser_SH(i,end-100:end),2)),'b','linewidth',2) ; hold on;
h4=plot(time,squeeze(100.*var_Tser_trop(i,:) ./ nanmean(var_Tser_trop(i,end-100:end),2)),'color',purple,'linewidth',2) ; hold on;

% h1=plot(time,squeeze(var_Tser_glob(i,:) ./ var_Tser_glob_last100),'k','linewidth',2) ; hold on;
% h2=plot(time,squeeze(var_Tser_NH(i,:) ./   var_Tser_glob_last100),'r','linewidth',2) ; hold on;
% h3=plot(time,squeeze(var_Tser_SH(i,:) ./   var_Tser_glob_last100),'b','linewidth',2) ; hold on;
% h4=plot(time,squeeze(var_Tser_trop(i,:) ./ var_Tser_glob_last100),'color',purple,'linewidth',2) ; hold on;
% h5=plot(time,squeeze(var_Tser_south_30S(i,:) ./ var_Tser_glob_last100),'g','linewidth',2) ; hold on;
% h6=plot(time,squeeze(var_Tser_50_70S(i,:) ./ var_Tser_glob_last100),'c','linewidth',2) ; hold on;

    xlabel('Time (year)','fontsize',23,'fontweight','bold');
    ylabel('Relative SST (%)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2 h3 h4 h5 h6],'global',...
         'NH','SH','tropics','south of 30S','50S-70S');% ,'SOM');
    set(hleg1,'Location','southeast','Fontsize',17)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')    
 set(gca,'FontSize',20,'linewidth',2)
%  ylim([10 110])
  xlim([-50 1850])
  box on
cd (address) 
print ('-r600', fig_name,'-depsc')     
dbstop



for j = 1:5
if (j==3)
    h(j)=plot(time,squeeze(var_Tser(j,:)),'color',purple,'linewidth',1) ; hold on;
else    
    h(j)=plot(time,squeeze(var_Tser(j,:)),'color',cl(j),'linewidth',1) ; hold on;
end
end
for j = 6:9
if (j==8)
    h(j)=plot(time,squeeze(var_Tser(j,:)),'--','color',purple,'linewidth',1) ; hold on;
else    
    h(j)=plot(time,squeeze(var_Tser(j,:)),'--','color',cl(j),'linewidth',1) ; hold on;
end
end
  