clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
path(path,'/homes/eerfani/DrosteEffect-BrewerMap-04533de') 
path(path,'/homes/eerfani/tight_subplot') 

cd /shared/SWFluxCorr/CESM/Slab_lay_strat_0_05_co2_2_CHEY_PreIn   
cd /shared/SWFluxCorr/CESM/Slab_lay_strat_0_15_co2_2_CHEY_PreIn   
    aa1=dir('*anmn.nc');
    tt1=1; % ncdisp(aa(tt,1).name)
    filename1=aa1(tt1,1).name;
  gw=ncread(filename1,'gw'); % surface net Shortwave Radiation (W/m2)
    latitude =ncread(filename1,'lat');
    longitude =ncread(filename1,'lon');
[lat_msh,lon_msh] = meshgrid(latitude,longitude);
      I=length(longitude);
      GW=repmat(gw,[1 I])';
nn = 0;
for tt1 = 21:100
    nn = nn + 1 ;
    filename1=aa1(tt1,1).name;    
    SST_all(:,:,nn) = ncread(filename1,'SST') - 273.15; % low cloud amount
end
SST_all(SST_all > 1E2) = NaN ; SST_all(SST_all < -100) = NaN ;
SST_0_15 = nanmean(SST_all,3) ;
  II=find(isnan(SST_0_15)==1);
  GW2 = GW ;
  GW2(II)=nan;
  SST_glb_0_15 = nansum(nansum(GW2 .* SST_0_15,1),2) ./ nansum(nansum(GW2,1),2)           
%%%%    
cd ../ctrl_Slab_CHEY_PreIn
    aa1=dir('*anmn.nc');
nn = 0;
for tt1 = 21:100
    nn = nn + 1 ;
    filename1=aa1(tt1,1).name;  
    SST = ncread(filename1,'SST') - 273.15; % low cloud amount
    SST_all(:,:,nn) = SST ; 
end
SST_all(SST_all > 1E2) = NaN ; SST_all(SST_all < -100) = NaN ;
SST_ctrl = nanmean(SST_all,3) ;
  SST_glb_ctrl = nansum(nansum(GW2 .* SST_ctrl,1),2) ./ nansum(nansum(GW2,1),2)           

%%%%    
cd ../Slab_lay_strat_0_05_co2_2_CHEY_PreIn  
    aa1=dir('*anmn.nc');
nn = 0;
for tt1 = 21:100
    nn = nn + 1 ;
    filename1=aa1(tt1,1).name;  
    SST = ncread(filename1,'SST') - 273.15; % low cloud amount
    SST_all(:,:,nn) = SST ; 
end
SST_all(SST_all > 1E2) = NaN ; SST_all(SST_all < -100) = NaN ;
SST_0_05 = nanmean(SST_all,3) ;
  SST_glb_0_05 = nansum(nansum(GW2 .* SST_0_05,1),2) ./ nansum(nansum(GW2,1),2)           

%%%%    
cd ../Slab_lay_strat_0_1_co2_2_CHEY_PreIn  
    aa1=dir('*anmn.nc');
nn = 0;
for tt1 = 21:100
    nn = nn + 1 ;
    filename1=aa1(tt1,1).name;  
    SST = ncread(filename1,'SST') - 273.15; % low cloud amount
    SST_all(:,:,nn) = SST ; 
end
SST_all(SST_all > 1E2) = NaN ; SST_all(SST_all < -100) = NaN ;
SST_0_1 = nanmean(SST_all,3) ;
  SST_glb_0_1 = nansum(nansum(GW2 .* SST_0_1,1),2) ./ nansum(nansum(GW2,1),2)           

%%%%    
cd ../neg_Slab_lay_strat_0_2_co2_2_CHEY_PreIn
    aa1=dir('*anmn.nc');
nn = 0;
for tt1 = 21:100
    nn = nn + 1 ;
    filename1=aa1(tt1,1).name;  
    SST = ncread(filename1,'SST') - 273.15; % low cloud amount
    SST_all(:,:,nn) = SST ; 
end
SST_all(SST_all > 1E2) = NaN ; SST_all(SST_all < -100) = NaN ;
SST_0_2_n = nanmean(SST_all,3) ;
  SST_glb_0_2_n = nansum(nansum(GW2 .* SST_0_2_n,1),2) ./ nansum(nansum(GW2,1),2)           

%%%%    
cd ../co2_Slab_CHEY_PreIn   
    aa1=dir('*anmn.nc');
nn = 0;
for tt1 = 21:100
    nn = nn + 1 ;
    filename1=aa1(tt1,1).name;  
    SST = ncread(filename1,'SST') - 273.15; % low cloud amount
    SST_all(:,:,nn) = SST ; 
end
SST_all(SST_all > 1E2) = NaN ; SST_all(SST_all < -100) = NaN ;
SST_CO2_2 = nanmean(SST_all,3) ;
  SST_glb_co2_2 = nansum(nansum(GW2 .* SST_CO2_2,1),2) ./ nansum(nansum(GW2,1),2)           
   
%%%%%
cellsize = 0.5; 
var1  = double(SST_CO2_2 - SST_ctrl) ;
var2  = double(SST_0_2_n - SST_ctrl) ;
var3  = double(SST_0_1 - SST_ctrl) ;
var4  = double(SST_0_15 - SST_ctrl) ;
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
  %AA1 = m_contourf(lon,lat,var1);
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
    caxis([-10, 10])
    colormap(brewermap(60,'*RdBu'))
    
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
    caxis([-10, 10])
    colormap(brewermap(60,'*RdBu'))

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
    caxis([-10, 10])
    colormap(brewermap(60,'*RdBu'))
    
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
    Title_1 = strcat('(c0.15) - (ctrl)');
    title(Title_1,'fontsize',17,'fontweight','bold');
    set(gca,'Fontsize',15)
    m_grid('linewi',2,'linest','none','yticklabels',[],'tickdir','in','fontsize',15);
    caxis([-10, 10])
    colormap(brewermap(60,'*RdBu'))    
colorbar('location','Manual', 'position', [0.95 0.049 0.02 0.905]);
    set(gca,'Fontsize',15)
        
cd /shared/SWFluxCorr/CESM/Slab_lay_strat_0_05_co2_2_CHEY_PreIn       
      eval(['print -r600 -djpeg ', fig_name,'.jpg']);       

%%%%%%%%%%%   
cellsize = 0.5; 
var1  = double(SST_ctrl - SST_CO2_2) ;
var2  = double(SST_0_2_n - SST_CO2_2) ;
var3  = double(SST_0_1 - SST_CO2_2) ;
var4  = double(SST_0_15 - SST_CO2_2) ;
lat  = lat_msh ;
lon  = lon_msh ; 
[Z_adjust1,refvec_bias1] = geoloc2grid(lat,lon,var1, cellsize);   
[Z_adjust2,refvec_bias2] = geoloc2grid(lat,lon,var2, cellsize);   
[Z_adjust3,refvec_bias3] = geoloc2grid(lat,lon,var3, cellsize);   
[Z_adjust4,refvec_bias4] = geoloc2grid(lat,lon,var4, cellsize);   
 latlim = [-75 75];
 lonlim = [1 360]; 
 
       fig_name = strcat('Diff_sst_CESM_2XCO2_PAPER');
        fig_dum = figure(2);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,14,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
      
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
    Title_1 = strcat('(ctrl) - (2XCO2)');
    title(Title_1,'fontsize',17,'fontweight','bold');
    set(gca,'Fontsize',15)
    m_grid('linewi',2,'linest','none','xticklabels',[],'tickdir','in','fontsize',15);
    caxis([-10, 10])
    colormap(brewermap(60,'*RdBu'))
    
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
    Title_1 = strcat('(c=-0.2) - (2XCO2)');
    title(Title_1,'fontsize',17,'fontweight','bold');
    set(gca,'Fontsize',15)
    m_grid('linewi',2,'linest','none','xticklabels',[],'yticklabels',[],'tickdir','in','fontsize',15);
    caxis([-10, 10])
    colormap(brewermap(60,'*RdBu'))

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
    Title_1 = strcat('(c=0.1) - (2XCO2)');
    title(Title_1,'fontsize',17,'fontweight','bold');
    set(gca,'Fontsize',15)
    m_grid('linewi',2,'linest','none','tickdir','in','fontsize',15);
    caxis([-10, 10])
    colormap(brewermap(60,'*RdBu'))
    
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
    Title_1 = strcat('(c=0.15) - (2XCO2)');
    title(Title_1,'fontsize',17,'fontweight','bold');
    set(gca,'Fontsize',15)
    m_grid('linewi',2,'linest','none','yticklabels',[],'tickdir','in','fontsize',15);
    caxis([-10, 10])
    colormap(brewermap(60,'*RdBu'))    
colorbar('location','Manual', 'position', [0.95 0.049 0.02 0.905]);
    set(gca,'Fontsize',15)
        
      eval(['print -r600 -djpeg ', fig_name,'.jpg']);       
