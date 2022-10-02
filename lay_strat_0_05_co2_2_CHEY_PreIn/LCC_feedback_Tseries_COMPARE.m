clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn' ; cd (address)
    aa=dir('*anmn.nc');
    filename=aa(1,1).name;
  gw=ncread(filename,'gw'); 
    lat =ncread(filename,'lat');
    lon =ncread(filename,'lon');
[lon_msh_CAM,lat_msh_CAM] = meshgrid(lon,lat);
      I=length(lon);
      GW=repmat(gw,[1 I])';

cases = {'lay_strat_0_05_co2_2_CHEY_PreIn','lay_strat_0_1_co2_2_CHEY_PreIn',...
    'lay_strat_0_15_co2_2_CHEY_PreIn','2lay_strat_0_2_co2_2_CHEY_PreIn',...
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
    LCC =ncread(filename,'CLDLOW') .* 100; 
    LCC_all(:,:,tt) = LCC ;

    II=find(isnan(LCC_all(:,:,tt))==1);
    GW2 = GW ;
    GW2(II)=nan;
    LCC_Tseries(i,tt) = nansum(nansum(GW2 .* LCC_all(:,:,tt),1),2) ./ nansum(nansum(GW2,1),2) ;
end
cd ..
end

cd ..
%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%

address = '/shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn' ; cd (address)
  aa=dir('*pop*anmn.nc');
  filename=aa(1,1).name;
  TAREA=ncread(filename,'TAREA'); 
  lat_msh =ncread(filename,'TLAT');
  lon_msh =ncread(filename,'TLONG');
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
    temp=ncread(filename,'TEMP'); % ocn temp
    temp(temp > 1E4) = NaN ;  
    sst_all(:,:,tt) = temp(:,:,1) ;   

    II=find(isnan(sst_all(:,:,tt))==1);
    TAREA2 = TAREA ;
    TAREA2(II)=nan;
    sst_Tseries(i,tt) = nansum(nansum(TAREA2 .* sst_all(:,:,tt),1),2) ./ nansum(nansum(TAREA2,1),2) ;     
end
cd ..
end

% %%%%
% cd PreInd_chey_contr   
%     aa1=dir('*tavg.*.nc');
%     filename1=aa1(1,1).name;
%     temp = ncread(filename1,'TEMP') ; % temp
%     sst_ctrl = temp(:,:,1) ;
%     II=find(isnan(sst_ctrl)==1);
%     TAREA2 = TAREA ;
%     TAREA2(II)=nan;    
%     sst_ctrl_glb = nansum(nansum(TAREA2 .* sst_ctrl)) ./ nansum(nansum(TAREA2))      
% 
%     aa1=dir('*._ANN_climo.nc');
%     filename1=aa1(1,1).name;
%     LCC_ctrl = ncread(filename1,'CLDLOW') .* 100; % low cloud amount
%     II=find(isnan(LCC_ctrl)==1);
%     GW2 = GW ;
%     GW2(II)=nan;   
%     LCC_ctrl_glb = nansum(nansum(GW2 .* LCC_ctrl)) ./ nansum(nansum(GW2))           
%%%%
   
Diff_sst_Tseries = sst_Tseries - 16.5943 ;
Diff_LCC_Tseries = LCC_Tseries - 37.65 ;
LCC_feedback     = Diff_LCC_Tseries ./ Diff_sst_Tseries ;

%%%%%%
time = 1:size(LCC_feedback,2) ;
       fig_name = strcat('LCC_feedback_Tseries_GLOBAL');
        fig_dum = figure(3);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
cl = ['b','r','m','g','k','b','r','m','g']; 
nb = [7:10 2 6:-1:3] ;
for j = 1:5
if (j==3)
    h(j)=plot(time,squeeze(LCC_feedback(j,:)),'color',purple,'linewidth',1) ; hold on;
else
    h(j)=plot(time,squeeze(LCC_feedback(j,:)),'color',cl(j),'linewidth',1) ; hold on;
end
end
for j = 6:9
if (j==8)
    h(j)=plot(time,squeeze(LCC_feedback(j,:)),'--','color',purple,'linewidth',1) ; hold on;
else    
    h(j)=plot(time,squeeze(LCC_feedback(j,:)),'--','color',cl(j),'linewidth',1) ; hold on;
end
end
    xlabel('Time (year)','fontsize',20,'fontweight','bold');
    ylabel('Global LCC Feedback (% per K)','fontsize',20,'fontweight','bold');
   hleg1 = legend([h(5) h(9) h(8) h(7) h(6) h(1) h(2) h(3) h(4)],'2',...
         '3','4','5','6','7','8','9','10');
    set(hleg1,'Location','SouthEast','Fontsize',14)
    set(hleg1,'Interpreter','none')  
 set(gca,'FontSize',16,'linewidth',1.5)
  ylim([-3.5 2])
  xlim([-50 2000])
  box on
cd (address) 

set(gcf,'color','w');
set(gcf, 'PaperPositionMode', 'auto')
set(gcf,'renderer','Painters')
print ('-depsc','-tiff','-r600','-painters', fig_name)
    