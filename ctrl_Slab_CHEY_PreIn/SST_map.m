    clc
    clear
path(path,'/homes/eerfani/Bias/m_map') 
cd /shared/SWFluxCorr/CESM/ctrl_Slab_CHEY_PreIn

cd /homes/eerfani/Bias
load ('SST_Hadley.mat')
load('lat_HadI') ; load('lon_HadI')
load('latitude') ; load('longitude');
[lon_msh,lat_msh] = meshgrid(longitude,latitude);
 SST_mean_interp_HADI = griddata(double(lon_HadI),double(lat_HadI),SST_Hadley,lon_msh,lat_msh,'natural');

%%%%
cd /shared/SWFluxCorr/CESM/ctrl_Slab_CHEY_PreIn

    aa1=dir('*.anmn.nc');
    tt1=1; % ncdisp(aa(tt,1).name)
    filename1=aa1(tt1,1).name;
  gw=ncread(filename1,'gw'); % surface net Shortwave Radiation (W/m2)
    latitude =ncread(filename1,'lat');
    longitude =ncread(filename1,'lon');
[lon_msh,lat_msh] = meshgrid(longitude,latitude);

      I=length(longitude);
      GW=repmat(gw,[1 I])';

nn = 0 ;
for tt1=21:100%length(aa1)
    nn = nn + 1 ;
    filename1=aa1(tt1,1).name;
    sst=ncread(filename1,'SST'); 
    sst_all(:,:,nn) = sst - 273.15;      
end
    

%%%%%
  cellsize = 0.5; 
SST_T31(:,:,1)  = double(nanmean(sst_all,3) - SST_mean_interp_HADI') ;
lat_T31(:,:,1)  = lat_msh ;
lon_T31(:,:,1)  = lon_msh ; 
[Z_adjust(:,:,1),refvec_bias(:,:,1)] = geoloc2grid(squeeze(lat_T31(:,:,1)),squeeze(lon_T31(:,:,1)),squeeze(SST_T31(:,:,1)'), cellsize);   
 latlim = [-75 75];
 lonlim = [1 360];
 
        fig_name = strcat('SST_bias_annual_Chey_1st_crr');%,num2str(tt));
        fig_dum = figure(144);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.3,0.3,12,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
       m_proj('miller','long',[0 358],'lat',[-75 75])       
    axesm('miller','MapLatLimit',latlim,'MapLonLimit',lonlim, ...
   'Frame','off','Grid','off')
AA=geoshow(squeeze(Z_adjust(:,:,1)), squeeze(refvec_bias(:,:,1)), 'DisplayType', 'texturemap','EdgeColor','flat');
    set(AA,'FaceColor','flat','Linestyle','-'); 
    setm(gca,'frame','on');
    setm(gca,'fontsize',12);
    setm(gca,'FEdgeColor',[1 1 1]);
  m_coast('linewidth',2,'color','black');
    Title_1 = 'Bias, CESM - HADISST, SST, Annual Mean, CAM grid';
    title(Title_1,'fontsize',23,'fontweight','bold');
    cc = colorbar('peer',gca);
    set(gca,'Fontsize',20)
    m_grid('linewi',2,'linest','none','tickdir','in','fontsize',20);
    caxis([-8, 8])
      eval(['print -r600 -djpeg ', fig_name,'.jpg']);  
