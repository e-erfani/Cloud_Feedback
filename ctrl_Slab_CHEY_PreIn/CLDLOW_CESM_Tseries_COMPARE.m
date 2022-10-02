clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

cd /shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn 
    aa1=dir('lay*CLDLOW*.nc');
    month = {'January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'} ;
    tt1=1; % ncdisp(aa(tt,1).name)
    filename1=aa1(tt1,1).name;
  gw=ncread(filename1,'gw'); % surface net Shortwave Radiation (W/m2)
    lat =ncread(filename1,'lat');
    lon =ncread(filename1,'lon');
[lon_msh,lat_msh] = meshgrid(lon,lat);

      I=length(lon);
      GW=repmat(gw,[1 I])';

for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    cldlow =ncread(filename1,'CLDLOW'); % T
    for i = 1:size(cldlow,3)
        cldlow_all(:,:,(tt1 - 1) .* size(cldlow,3) + i) = cldlow(:,:,i);
    end
end

for i = 1:size(cldlow_all,3)
    cldlow_Tseries(i) = nansum(nansum(GW .* cldlow_all(:,:,i),1),2) ./ nansum(nansum(GW,1),2) ; 
end

for j = 1:size(cldlow_all,3)/12
      temp = cldlow_Tseries(:,j*12-11:j*12);
      cldlow_Tseries_yr_0_05(j) = nanmean(temp);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear cldlow_all1 cldlow_all2 cldlow_all cldlow_Tseries
cd ../chey_co2_2_rhminl_PreIn
    aa1=dir('chey*CLDLOW*.nc');

for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    cldlow =ncread(filename1,'CLDLOW'); % T
    for i = 1:size(cldlow,3)
        cldlow_all(:,:,(tt1 - 1) .* size(cldlow,3) + i) = cldlow(:,:,i);
    end
end

for i = 1:size(cldlow_all,3)
    cldlow_Tseries(i) = nansum(nansum(GW .* cldlow_all(:,:,i),1),2) ./ nansum(nansum(GW,1),2) ;
end

for j = 1:size(cldlow_all,3)/12
      temp = cldlow_Tseries(:,j*12-11:j*12);
      cldlow_Tseries_yr_co2(j) = nanmean(temp);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear cldlow_all1 cldlow_all2 cldlow_all cldlow_Tseries
cd ../lay_strat_0_1_co2_2_CHEY_PreIn
    aa1=dir('lay*CLDLOW*.nc');

for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    cldlow =ncread(filename1,'CLDLOW'); % T
    for i = 1:size(cldlow,3)
        cldlow_all(:,:,(tt1 - 1) .* size(cldlow,3) + i) = cldlow(:,:,i);
    end
end

for i = 1:size(cldlow_all,3)
    cldlow_Tseries(i) = nansum(nansum(GW .* cldlow_all(:,:,i),1),2) ./ nansum(nansum(GW,1),2) ;
end

for j = 1:size(cldlow_all,3)/12
      temp = cldlow_Tseries(:,j*12-11:j*12);
      cldlow_Tseries_yr_0_1(j) = nanmean(temp);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear cldlow_all1 cldlow_all2 cldlow_all cldlow_Tseries
cd ../lay_strat_0_15_co2_2_CHEY_PreIn
    aa1=dir('lay*CLDLOW*.nc');

for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    cldlow =ncread(filename1,'CLDLOW'); % T
    for i = 1:size(cldlow,3)
        cldlow_all(:,:,(tt1 - 1) .* size(cldlow,3) + i) = cldlow(:,:,i);
    end
end

for i = 1:size(cldlow_all,3)
    cldlow_Tseries(i) = nansum(nansum(GW .* cldlow_all(:,:,i),1),2) ./ nansum(nansum(GW,1),2) ;
end

for j = 1:size(cldlow_all,3)/12
      temp = cldlow_Tseries(:,j*12-11:j*12);
      cldlow_Tseries_yr_0_15(j) = nanmean(temp);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear cldlow_all1 cldlow_all2 cldlow_all cldlow_Tseries 
cd ../2lay_strat_0_2_co2_2_CHEY_PreIn 
    aa1=dir('lay*CLDLOW*.nc');
    aa2=dir('2lay*CLDLOW*.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    cldlow =ncread(filename1,'CLDLOW'); % T
    for i = 1:size(cldlow,3)
        cldlow_all1(:,:,(tt1 - 1) .* size(cldlow,3) + i) = cldlow(:,:,i);
    end
end

for tt2=1:length(aa2)
    filename2=aa2(tt2,1).name;
    cldlow =ncread(filename2,'CLDLOW'); % T
    for i = 1:size(cldlow,3)
        cldlow_all2(:,:,(tt2 - 1) .* size(cldlow,3) + i) = cldlow(:,:,i);
    end
end

cldlow_all = cat(3,cldlow_all1,cldlow_all2);

for i = 1:size(cldlow_all,3)
    cldlow_Tseries(i) = nansum(nansum(GW .* cldlow_all(:,:,i),1),2) ./ nansum(nansum(GW,1),2) ; 
end

for j = 1:size(cldlow_all,3)/12
      temp = cldlow_Tseries(:,j*12-11:j*12);
      cldlow_Tseries_yr_0_2(j) = nanmean(temp);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear cldlow_all1 cldlow_all2 cldlow_all cldlow_Tseries 
cd ../lay_strat_0_5_co2_2_CHEY_PreIn 
    aa1=dir('lay*CLDLOW*.nc');
    aa2=dir('2lay*CLDLOW*.nc');
for tt1=1:length(aa1)
    filename1=aa1(tt1,1).name;
    cldlow =ncread(filename1,'CLDLOW'); % T
    for i = 1:size(cldlow,3)
        cldlow_all1(:,:,(tt1 - 1) .* size(cldlow,3) + i) = cldlow(:,:,i);
    end
end

for tt2=1:length(aa2)
    filename2=aa2(tt2,1).name;
    cldlow =ncread(filename2,'CLDLOW'); % T
    for i = 1:size(cldlow,3)
        cldlow_all2(:,:,(tt2 - 1) .* size(cldlow,3) + i) = cldlow(:,:,i);
    end
end

cldlow_all = cat(3,cldlow_all1,cldlow_all2);

for i = 1:size(cldlow_all,3)
    cldlow_Tseries(i) = nansum(nansum(GW .* cldlow_all(:,:,i),1),2) ./ nansum(nansum(GW,1),2) ; 
end

for j = 1:size(cldlow_all,3)/12
      temp = cldlow_Tseries(:,j*12-11:j*12);
      cldlow_Tseries_yr_0_5(j) = nanmean(temp);
end

%%%%%%
time = 1:600 ;
       fig_name = strcat('cldlow_TIME_SERIES_GLOBAL');%,num2str(tt));
        fig_dum = figure(3);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
          
h1 = plot(time,squeeze(cldlow_Tseries_yr_co2(1:600)*100),'k','linewidth',2) ;
hold on
h2 = plot(time,squeeze(cldlow_Tseries_yr_0_05(1:600)*100),'b','linewidth',2) ;
hold on
h3 = plot(time,squeeze(cldlow_Tseries_yr_0_1(1:600)*100),'r','linewidth',2) ;
hold on
h4 = plot(time,squeeze(cldlow_Tseries_yr_0_15(1:600)*100),'color',purple,'linewidth',2) ;
hold on
h5 = plot(time,squeeze(cldlow_Tseries_yr_0_2(1:600)*100),'g','linewidth',2) ;
hold on
h6 = plot(time,squeeze(cldlow_Tseries_yr_0_5(1:600)*100),'c','linewidth',2) ;
    xlabel('Time (year)','fontsize',23,'fontweight','bold');
    ylabel('Global low-level cloud amount (%)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h1 h2 h3 h4 h5 h6],'CESM, 2XCO2','CESM, c=0.05','CESM, c=0.1',...
           'CESM, c=0.15','CESM, c=0.2', 'CESM, c=0.5');        
    set(gca,'Fontsize',20,'linewidth',1.5)
    set(hleg1,'Fontsize',16,'linewidth',1.5)
 % ylim([32 42])
  xlim([-10 650])
  box on
cd /shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn   
  eval(['print -r600 -djpeg ', fig_name,'.jpg']);    
 