clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient


sst_fcm = [18.78    18.08   18.20   18.32   18.52   19.31   20.63   23.11   24.41...
            16.6	16.53	16.51	16.53	16.53	16.6	16.61	16.59	16.6];


cldlow_fcm = [37.33   39.14   38.82   38.46   37.94   36.20   33.60   28.61   25.69...
            37.65	37.62	37.6	37.63	37.64	37.65	37.61	37.66	37.61];

sst_som = [18.5	17.74	17.86	18	18.22	19.16	21.58	24.02	25.13...
    16.38	16.37	16.37	16.38	16.38	16.42	16.48	16.64	16.81];

cldlow_som = [37.24	39.17	38.79	38.43	37.91	35.91	31.93	27.19...
    24.85	37.83	37.93	37.89	37.89	37.87	37.74	37.6	37.24	36.72];

%%%%
[ffit,gof] = fit(sst_fcm(1:9)',cldlow_fcm(1:9)','poly1') ;
R_sq=sprintf('R^2=%g',gof.rsquare);
rmse=sprintf('RMSE=%g',gof.rmse);

[ffit2,gof2] = fit(sst_som(1:9)',cldlow_som(1:9)','poly1') ;
R_sq2=sprintf('R^2=%g',gof2.rsquare);
rmse2=sprintf('RMSE=%g',gof2.rmse);

[ffit2_1,gof2_1] = fit(sst_som(2:5)',cldlow_som(2:5)','poly1') ;
R_sq2_1=sprintf('R^2=%g',gof2_1.rsquare);
[ffit2_2,gof2_2] = fit(sst_som(6:9)',cldlow_som(6:9)','poly1') ;
R_sq2_2=sprintf('R^2=%g',gof2_2.rsquare);

%%%%%%%
       fig_name = strcat('cldlow_sst_scatter_1800');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,0.5,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
      
    h1=plot(sst_fcm(1:9),cldlow_fcm(1:9),'o','markers',13); hold on
    set(h1,'MarkerEdgeColor','k','MarkerFaceColor','b','LineWidth',1)
FCM_2 = 2:10 ;
for ii = 1:9
    text(sst_fcm(ii)+0.12,cldlow_fcm(ii)+0.2,num2str(FCM_2(ii)),'color','b','FontSize',15)
end    
    
    h2=plot(sst_som(1:9),cldlow_som(1:9),'o','markers',13); hold on
    set(h2,'MarkerEdgeColor','k','MarkerFaceColor','r','LineWidth',1)
SOM_2 = 12:20 ;
for ii = 1:9
    text(sst_som(ii)-0.4,cldlow_som(ii)-0.2,num2str(SOM_2(ii)),'color','r','FontSize',15)
end     
    h3=plot(sst_fcm(10:18),cldlow_fcm(10:18),'o','markers',13); hold on
    set(h3,'MarkerEdgeColor','k','MarkerFaceColor','c','LineWidth',1)%,'MarkerFaceColor','k')
    
    h4=plot(sst_som(10:18),cldlow_som(10:18),'o','markers',13); hold on
    set(h4,'MarkerEdgeColor','k','MarkerFaceColor','m','LineWidth',1)
    
    xlabel('Global SST (\circC)','fontsize',23,'fontweight','bold');
    ylabel('Global LCC (%)','fontsize',23,'fontweight','bold');
   hleg1 = legend([h3 h1 h4 h2],'FCM, Pre-ind', 'FCM, 2XCO2','SOM, Pre-ind','SOM, 2XCO2');
    set(gca,'Fontsize',20,'linewidth',1.5)
    set(hleg1,'Fontsize',16,'linewidth',1.5)

set(gca,'Fontsize',25,'linewidth',2)
box on
%xlim([11.5 13.1])
ylim([24 40])
set(gca,'XTick',[16 17 18 19 20 21 22 23 24 25 26])
set(gca,'YTick',24:2:40)
cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient
  eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  