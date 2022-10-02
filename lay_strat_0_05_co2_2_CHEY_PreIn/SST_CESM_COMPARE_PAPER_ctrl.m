clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
path(path,'/homes/eerfani/DrosteEffect-BrewerMap-04533de') 
path(path,'/homes/eerfani/tight_subplot') 

cd /shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn 
cd /shared/SWFluxCorr/CESM/lay_strat_0_15_co2_2_CHEY_PreIn   

    aa1=dir('*tavg.*.nc');
    tt1=1; % ncdisp(aa(tt,1).name)
    filename1=aa1(tt1,1).name;
TAREA=ncread(filename1,'TAREA'); % surface net Shortwave Radiation (W/m2)
    lat_msh=ncread(filename1,'TLAT'); % lat
    lon_msh=ncread(filename1,'TLONG'); % lon 
    temp = ncread(filename1,'TEMP') ; % temp
    sst_0_15 = temp(:,:,1) ; 
%   II=find(isnan(sst_0_15)==1);
%   TAREA2 = TAREA ;
%   TAREA2(II)=nan;
%   SST_ave_0_15 = nansum(nansum(TAREA2 .* sst_0_15,1),2) ./ nansum(nansum(TAREA2,1),2)      

%%%%    
cd ../PreInd_chey_contr   
    aa1=dir('*tavg.*.nc');
    filename1=aa1(tt1,1).name;
    temp = ncread(filename1,'TEMP') ; % temp
    sst_ctrl = temp(:,:,1) ;
%%%%    
cd ../lay_strat_0_1_co2_2_CHEY_PreIn   
    aa1=dir('*tavg.*.nc');
    filename1=aa1(tt1,1).name;
    temp = ncread(filename1,'TEMP') ; % temp
    sst_0_1 = temp(:,:,1) ;
%%%%    
cd ../neg_lay_strat_0_2_co2_2_CHEY_PreIn   
    aa1=dir('*tavg.*.nc');
    filename1=aa1(tt1,1).name;
    temp = ncread(filename1,'TEMP') ; % temp
    sst_0_2_n = temp(:,:,1) ;
%%%%    
cd ../chey_co2_2_rhminl_PreIn   
    aa1=dir('*tavg.*.nc');
    filename1=aa1(tt1,1).name;
    temp = ncread(filename1,'TEMP') ; % temp
    sst_CO2_2 = temp(:,:,1) ;    
%%%%%
cellsize = 0.5; 
var1  = double(sst_CO2_2 - sst_ctrl) ;
var2  = double(sst_0_2_n - sst_ctrl) ;
var3  = double(sst_0_1 - sst_ctrl) ;
var4  = double(sst_0_15 - sst_ctrl) ;
lat  = lat_msh ;
lon  = lon_msh ; 
[Z_adjust1,refvec_bias1] = geoloc2grid(lat,lon,var1, cellsize);   
[Z_adjust2,refvec_bias2] = geoloc2grid(lat,lon,var2, cellsize);   
[Z_adjust3,refvec_bias3] = geoloc2grid(lat,lon,var3, cellsize);   
[Z_adjust4,refvec_bias4] = geoloc2grid(lat,lon,var4, cellsize);   
 latlim = [-75 75];
 lonlim = [1 360]; 
 
       fig_name = strcat('Diff_sst_CESM_ctrl_PAPER');
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,14,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
      
%[ha, pos] = tight_subplot(2,2,[.01 .03],[.03 .03],[.05 .06]) ;
[ha, pos] = tight_subplot(2,2,[.00 .01],[.01 .01],[.05 .06]) ;
      
axes(ha(1))
    m_proj('miller','long',[0 358],'lat',[-75 75])       
    axesm('miller','MapLatLimit',latlim,'MapLonLimit',lonlim, ...
   'Frame','off','Grid','off')
    AA1=geoshow(Z_adjust1, refvec_bias1, 'DisplayType', 'texturemap','EdgeColor','flat');
    set(AA1,'FaceColor','flat','Linestyle','-'); 
    setm(gca,'frame','on');
    setm(gca,'fontsize',15);
    setm(gca,'FEdgeColor',[1 1 1]);
  m_coast('linewidth',2,'color','black');
    Title_1 = strcat('(2XCO2) - (ctrl)');
    title(Title_1,'fontsize',17,'fontweight','bold');
    set(gca,'Fontsize',15)
    m_grid('linewi',2,'linest','none','xticklabels',[],'tickdir','in','fontsize',15);
    caxis([-13, 13])
    colormap(brewermap(104,'*Spectral'))
    
axes(ha(2))
    m_proj('miller','long',[0 358],'lat',[-75 75])       
    axesm('miller','MapLatLimit',latlim,'MapLonLimit',lonlim, ...
   'Frame','off','Grid','off')
    AA2=geoshow(Z_adjust2, refvec_bias2, 'DisplayType', 'texturemap','EdgeColor','flat');
    set(AA2,'FaceColor','flat','Linestyle','-'); 
    setm(gca,'frame','on');
    setm(gca,'fontsize',15);
    setm(gca,'FEdgeColor',[1 1 1]);
  m_coast('linewidth',2,'color','black');
    Title_1 = strcat('(c=-0.2) - (ctrl)');
    title(Title_1,'fontsize',17,'fontweight','bold');
    set(gca,'Fontsize',15)
    m_grid('linewi',2,'linest','none','xticklabels',[],'yticklabels',[],'tickdir','in','fontsize',15);
    caxis([-13, 13])
    colormap(brewermap(104,'*Spectral'))

axes(ha(3))
    m_proj('miller','long',[0 358],'lat',[-75 75])       
    axesm('miller','MapLatLimit',latlim,'MapLonLimit',lonlim, ...
   'Frame','off','Grid','off')
    AA3=geoshow(Z_adjust3, refvec_bias3, 'DisplayType', 'texturemap','EdgeColor','flat');
    set(AA3,'FaceColor','flat','Linestyle','-'); 
    setm(gca,'frame','on');
    setm(gca,'fontsize',15);
    setm(gca,'FEdgeColor',[1 1 1]);
  m_coast('linewidth',2,'color','black');
    Title_1 = strcat('(c=0.1) - (ctrl)');
    title(Title_1,'fontsize',17,'fontweight','bold');
    set(gca,'Fontsize',15)
    m_grid('linewi',2,'linest','none','tickdir','in','fontsize',15);
    caxis([-13, 13])
    colormap(brewermap(104,'*Spectral'))
    
axes(ha(4))
    m_proj('miller','long',[0 358],'lat',[-75 75])       
    axesm('miller','MapLatLimit',latlim,'MapLonLimit',lonlim, ...
   'Frame','off','Grid','off')
    AA4=geoshow(Z_adjust4, refvec_bias4, 'DisplayType', 'texturemap','EdgeColor','flat');
    set(AA4,'FaceColor','flat','Linestyle','-'); 
    setm(gca,'frame','on');
    setm(gca,'fontsize',15);
    setm(gca,'FEdgeColor',[1 1 1]);
  m_coast('linewidth',2,'color','black');
    Title_1 = strcat('(c=0.15) - (ctrl)');
    title(Title_1,'fontsize',17,'fontweight','bold');
    set(gca,'Fontsize',15)
    m_grid('linewi',2,'linest','none','yticklabels',[],'tickdir','in','fontsize',15);
    caxis([-13, 13])
    colormap(brewermap(104,'*Spectral'))    
h = colorbar('location','Manual', 'position', [0.95 0.049 0.02 0.905]);
set(h, 'ylim', [0 13])
set(gca,'Fontsize',15)
        
cd /shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn       
     eval(['print -r600 -djpeg ', fig_name,'.jpg']);       
