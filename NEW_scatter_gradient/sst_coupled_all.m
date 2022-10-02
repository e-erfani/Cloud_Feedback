clc 
clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient

    aa=dir('*_tavg.*.nc');

for i = 1:10
    fname = aa(i,1).name;
    [T1(i),T1_area(i),T1_dx(i)] = get_SST1(fname); 
    [T2(i),T2_area(i),T2_dx(i)] = get_SST2(fname); 
    [T3(i),T3_area(i)] = get_SST3_25to65NS(fname);
    [T4(i),T4_area(i),T4_dx(i)] = get_SST4(fname);     
 end

Pac_meri_grad_UO=T4-T3;
Pac_zonal_grad_UO=T1-T2;

%%%%%%%
       fig_name = strcat('sst_scatter_gradient_coupled_all');%,num2str(tt));
        fig_dum = figure(1);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,0.5,11,9]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
xx = 11.0:0.01:13.1 ;
p = polyfit(Pac_meri_grad_UO,Pac_zonal_grad_UO,1);
f = polyval(p,xx);
plot(xx,f,'color',purple,'LineWidth',2); hold on;
    h=scatter(Pac_meri_grad_UO,Pac_zonal_grad_UO,'o');%,'black','LineWidth',3);
    set(h,'MarkerEdgeColor','k','MarkerFaceColor','k','LineWidth',0.6)

%plot(Pac_meri_grad_UO,Pac_zonal_grad_UO,'ko','linewidth',3)
hold on
abc = [2 1 6:-1:3 7:10] ;
for ii = 1:length(Pac_meri_grad_UO)
   if (ii==5)
      text(Pac_meri_grad_UO(ii)+0.015,Pac_zonal_grad_UO(ii)+0.025,num2str(abc(ii)),'color','k','FontSize',20)
   elseif (ii==3)
      text(Pac_meri_grad_UO(ii)+0.015,Pac_zonal_grad_UO(ii)-0.015,num2str(abc(ii)),'color','k','FontSize',20)
   else 
      text(Pac_meri_grad_UO(ii)+0.015,Pac_zonal_grad_UO(ii)+0.015,num2str(abc(ii)),'color','k','FontSize',20)
   end
end


set(gca,'Fontsize',21,'linewidth',2)
    x=xlabel('\DeltaT_m_e_r_i_d_i_o_n_a_l (\circC)','fontsize',21,'fontweight','bold');
    set(x, 'Units', 'Normalized', 'Position', [0.5, -0.07, 0]);
    ylabel('\DeltaT_z_o_n_a_l (\circC)','fontsize',21,'fontweight','bold');

[ffit,gof2] = fit(Pac_meri_grad_UO',Pac_zonal_grad_UO','poly1') ;
R2=sprintf('R^2=%g',gof2.rsquare);
rmse=sprintf('RMSE=%g',gof2.rmse);
equation=sprintf('y=%gx%g',p(1),p(2));
str = {equation , R2, rmse};
rrr=annotation('textbox', [.63 .19, .1, .1], 'String', str);
set(rrr,'Fontsize',18)

box on
xlim([11.4 13.05])
ylim([1.0 4.2])    
cd /shared/SWFluxCorr/CESM/NEW_scatter_gradient
  eval(['print -r600 -djpeg ', fig_name,'.jpg']);
   print(fig_name,'-r600','-depsc'); 
  
