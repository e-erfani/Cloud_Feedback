    clc
    clear
path(path,'/homes/eerfani/Bias/m_map') 

cd /shared/SWFluxCorr/CESM/ctrl_Slab_CHEY_PreIn
cd all
    aa1=dir('*.nc');
    tt1=1; % ncdisp(aa(tt,1).name)
    filename1=aa1(tt1,1).name;
  gw=ncread(filename1,'gw'); % surface net Shortwave Radiation (W/m2)
    latitude =ncread(filename1,'lat');
    longitude =ncread(filename1,'lon');
[lon_msh,lat_msh] = meshgrid(longitude,latitude);

      I=length(longitude);
      GW=repmat(gw,[1 I])';
md = [15 46 74 105	135	166	196	227	258	288	319	349] ;

nn = 0 ;
for tt1=20*12+1:12*100%length(aa1)
    nn = nn + 1 ;
    filename1=aa1(tt1,1).name;
    sst=ncread(filename1,'SST'); % Downwelling solar flux at surface (W/m2)
    sst_all_all(:,:,nn) = sst;      
end

for mm=1:12
    for yy=1:80
        sst_mm_yy(:,:,mm,yy) = sst_all_all(:,:, (yy-1) .* 12 + mm ) ;
    end
end
sst_all = nanmean(sst_mm_yy,4);
%%%%%% initial method %%%%%%%
sst_all(isnan(sst_all) == 1) = 0.0;

for t1 = 1:365
    for m = 1:11
        if ( t1 >= md(m) && t1 < md(m+1) )
            for i = 1:size(sst_all,1)
            for j = 1:size(sst_all,2)
                sst_daily(i,j,t1) = (t1 - md(m)) .* (sst_all(i,j,m+1) - sst_all(i,j,m))...
                                           ./ (md(m+1) - md(m)) + sst_all(i,j,m)  ; 
                                       
            end
            end            
        end
    
    end
        if ( t1 < md(1) ) 
            for i = 1:size(sst_all,1)
            for j = 1:size(sst_all,2)
                sst_daily(i,j,t1) = (t1 - (-15)) .* (sst_all(i,j,1) - sst_all(i,j,12))...
                                           ./ (md(1) - (-15)) + sst_all(i,j,12)  ; 
            end
            end
        end
        
        if ( t1 >= md(12) )
            for i = 1:size(sst_all,1)
            for j = 1:size(sst_all,2)
                sst_daily(i,j,t1) = (t1 - md(12)) .* (sst_all(i,j,1) - sst_all(i,j,12))...
                                           ./ (365+15 - md(12)) + sst_all(i,j,12)  ; 
            end
            end
        end            
end

    sst_tsries = nanmean(nanmean(sst_daily,1),2) ;
    day = 1:365 ;
    figure(1)
    plot(day,permute(sst_tsries,[3 1 2]))
    sst_month_mean = nanmean(nanmean(sst_all,1),2) ;
    hold on
    plot(md,permute(sst_month_mean,[3 1 2]),'ok')
   
    sst_daily(isnan(sst_daily)==1) = 0.0 ;
    sst_daily_mean = nanmean(sst_daily,3) ;

%%%%%%%%%%
  cellsize = 0.5; 
SST_T31(:,:,1)  = double(sst_daily_mean) - 273.15 ;
lat_T31(:,:,1)  = lat_msh ;
lon_T31(:,:,1)  = lon_msh ; 
[Z_adjust(:,:,1),refvec_bias(:,:,1)] = geoloc2grid(squeeze(lat_T31(:,:,1)),squeeze(lon_T31(:,:,1)),squeeze(SST_T31(:,:,1)'), cellsize);   
 latlim = [-75 75];
 lonlim = [1 360];
 
        fig_name = strcat('sst_annual_FILE_CAM_NEW');
        fig_dum = figure(100);
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
    Title_1 = 'SST, CESM(ctrl), \circC, Annual Mean';
    title(Title_1,'fontsize',23,'fontweight','bold');
    cc = colorbar('peer',gca);
    set(gca,'Fontsize',20)
    m_grid('linewi',2,'linest','none','tickdir','in','fontsize',20);
    caxis([0, 30])
cd /shared/SWFluxCorr/CESM/ctrl_Slab_CHEY_PreIn
      eval(['print -r600 -djpeg ', fig_name,'.jpg']);  
      
%%%%
GW2 = GW;
sst_all_all_mean = nanmean(sst_all_all,3) ;
sst_all_all_mean(sst_all_all_mean ==0) = NaN;
II = find(isnan(sst_all_all_mean) == 1) ;
GW2(II) = NaN ;
sst_month_mean_glb = nansum(nansum(GW2 .* sst_daily_mean,1),2) ./ nansum(nansum(GW2,1),2)
sst_month_mean_glb_true = nansum(nansum(GW2 .* sst_all_all_mean,1),2) ./ nansum(nansum(GW2,1),2)

dbstop

 nccreate('sst_daily_CAM_slab.nc','sst_daily','Dimensions',{'lon',96,'lat',48,'day',365},'Format','classic');
 nccreate('sst_daily_CAM_slab.nc','lat','Dimensions',{'lon',96,'lat',48},'Format','classic');
 nccreate('sst_daily_CAM_slab.nc','lon','Dimensions',{'lon',96,'lat',48},'Format','classic'); 
  ncwrite('sst_daily_CAM_slab.nc','sst_daily',sst_daily);
  ncwrite('sst_daily_CAM_slab.nc','lat',lat_msh');
  ncwrite('sst_daily_CAM_slab.nc','lon',lon_msh');

%%%%%%%

Test_SW = ncread('sst_daily_CAM_slab.nc','sst_daily') ;
Test_lat = ncread('sst_daily_CAM_slab.nc','lat') ;
Test_lon = ncread('sst_daily_CAM_slab.nc','lon') ;

clear SST_T31; clear lat_T31; clear lon_T31
  cellsize = 0.5;
SST_T31(:,:,1)  = double(nanmean(Test_SW,3) - 273.15) ;
lat_T31(:,:,1)  = Test_lat ;
lon_T31(:,:,1)  = Test_lon ; 
[Z_adjust(:,:,1),refvec_bias(:,:,1)] = geoloc2grid(squeeze(lat_T31(:,:,1)),squeeze(lon_T31(:,:,1)),squeeze(SST_T31(:,:,1)), cellsize);   
 latlim = [-75 75];
 lonlim = [1 360];
 
        fig_name = strcat('SST_annual_fromFILE_CAM_NEW');%,num2str(tt));
        fig_dum = figure(266);
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
    Title_1 = 'SST, CESM(ctrl), \circC, Annual Mean';
    title(Title_1,'fontsize',23,'fontweight','bold');
    cc = colorbar('peer',gca);
    set(gca,'Fontsize',20)
    m_grid('linewi',2,'linest','none','tickdir','in','fontsize',20);
    caxis([0 30])
      eval(['print -r600 -djpeg ', fig_name,'.jpg']);
