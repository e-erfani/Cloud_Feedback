clc 
clear
path(path,'/homes/eerfani/Bias/m_map')  
path(path,'/homes/eerfani/DrosteEffect-BrewerMap-04533de') 
path(path,'/homes/eerfani/tight_subplot') 

cd /shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn   
cd /shared/SWFluxCorr/CESM/lay_strat_0_15_co2_2_CHEY_PreIn   
    aa1=dir('*._ANN_climo.nc');
    tt1=1; % ncdisp(aa(tt,1).name)
    filename1=aa1(tt1,1).name;
  gw=ncread(filename1,'gw'); % surface net Shortwave Radiation (W/m2)
    latitude =ncread(filename1,'lat');
    longitude =ncread(filename1,'lon');
[lat_msh,lon_msh] = meshgrid(latitude,longitude);
      I=length(longitude);
      GW=repmat(gw,[1 I])';
      ncid = netcdf.open(filename1,'NOWRITE');      
      varid = netcdf.inqVarID(ncid,'PRECC'); 
      precc = netcdf.getVar(ncid,varid,'double'); clear  varid       
      varid = netcdf.inqVarID(ncid,'PRECL'); 
      precl = netcdf.getVar(ncid,varid,'double'); clear  varid            
      precip_field =  precc + precl;      
      varid = netcdf.inqVarID(ncid,'QFLX'); 
      evap = netcdf.getVar(ncid,varid,'double'); clear  varid     
precip_field = precip_field.*1000.*60.*60.*24;
evap_field = evap.*(1000.*60.*60.*24)./1000;
PE_field = precip_field - evap_field;
      cldlow_0_15 = PE_field;
  II=find(isnan(cldlow_0_15)==1);
  GW2 = GW ;
  GW2(II)=nan;
  cldlow_ave_0_15 = nansum(nansum(GW2 .* cldlow_0_15,1),2) ./ nansum(nansum(GW2,1),2)           
      clear PE_field precip_field evapo_field evap_ precc precl    

%%%%    
cd ../PreInd_chey_contr   
    aa1=dir('*._ANN_climo.nc');
    filename1=aa1(tt1,1).name;
      ncid = netcdf.open(filename1,'NOWRITE');      
      varid = netcdf.inqVarID(ncid,'PRECC'); 
      precc = netcdf.getVar(ncid,varid,'double'); clear  varid       
      varid = netcdf.inqVarID(ncid,'PRECL'); 
      precl = netcdf.getVar(ncid,varid,'double'); clear  varid            
      precip_field =  precc + precl;      
      varid = netcdf.inqVarID(ncid,'QFLX'); 
      evap = netcdf.getVar(ncid,varid,'double'); clear  varid     
precip_field = precip_field.*1000.*60.*60.*24;
evap_field = evap.*(1000.*60.*60.*24)./1000;
PE_field = precip_field - evap_field;
cldlow_ctrl = PE_field;
   
%%%%%
cellsize = 0.5; 
var4  = double(cldlow_0_15 - cldlow_ctrl) ;
lat  = lat_msh ;
lon  = lon_msh ; 
[Z_adjust4,refvec_bias4] = geoloc2grid(lat,lon,var4, cellsize);   
 latlim = [-75 75];
 lonlim = [1 360]; 
 
       fig_name = strcat('Diff_P_E_CESM_ctrl_PAPER_FCM');
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,14,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
    m_proj('miller','long',[0 358],'lat',[-75 75])       
    axesm('miller','MapLatLimit',latlim,'MapLonLimit',lonlim, ...
   'Frame','off','Grid','off')
    AA1=geoshow(Z_adjust4, refvec_bias4, 'DisplayType', 'texturemap','EdgeColor','flat');
    set(AA1,'FaceColor','flat','Linestyle','-'); 
    setm(gca,'frame','on');
    setm(gca,'fontsize',15);
    setm(gca,'FEdgeColor',[1 1 1]);
  m_coast('linewidth',2,'color','black');
    Title_1 = strcat('(c=0.15) - (ctrl)');
    title(Title_1,'fontsize',17,'fontweight','bold');
    set(gca,'Fontsize',15)
    m_grid('linewi',2,'linest','none','tickdir','in','fontsize',15);
    caxis([-4, 4])
    colormap(brewermap(64,'RdBu'))
    
h = colorbar%('location','Manual', 'position', [0.95 0.049 0.02 0.905]);
set(h, 'ylim', [-4 4]);
    set(gca,'Fontsize',15)
        
cd /shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn       
      eval(['print -r600 -djpeg ', fig_name,'.jpg']);       
