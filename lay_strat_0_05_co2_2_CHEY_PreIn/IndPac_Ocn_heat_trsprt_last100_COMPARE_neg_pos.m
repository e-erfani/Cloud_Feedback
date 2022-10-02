    clc
    clear
path(path,'/homes/eerfani/Bias/m_map') 
purple = [0.5 0 0.5] ;

address = '/shared/SWFluxCorr/CESM/lay_strat_0_05_co2_2_CHEY_PreIn' ; cd (address)

cases = {'lay_strat_0_05_co2_2_CHEY_PreIn','lay_strat_0_1_co2_2_CHEY_PreIn',...
    'lay_strat_0_15_co2_2_CHEY_PreIn','2lay_strat_0_2_co2_2_CHEY_PreIn',...
    'chey_co2_2_rhminl_PreIn',...
    'neg_lay_strat_0_05_co2_2_CHEY_PreIn','neg_lay_strat_0_1_co2_2_CHEY_PreIn'...
    'neg_lay_strat_0_15_co2_2_CHEY_PreIn','neg_lay_strat_0_2_co2_2_CHEY_PreIn'...
    'PreInd_chey_contr'} ;
cd ..

for i = 1:length(cases)
    cd (char(cases(:,i)))
    aa=dir('*tavg.*.nc');
    fname = aa(1,1).name;
    filename{i}=fname ;
    [OHT(:,i),lat_pop]= get_zonalmean_Global_minus_Atlantic_OHT(fname);
    clear aa fname
    cd ..
end
%%%%%
% cd /shared/SWFluxCorr/CESM/slab_coef_flx_crrt_PreIn 
% aa=dir('pop_frc.b.c40.B1850CN.T31_g37.110128.nc');
%     filename=aa(1,1).name;
%     [OHT_SOM,latt]= get_zonalmean_OHT(filename);
%  lat_SOM = nanmean(latt,2);
%  OHT_SOM(OHT_SOM < -5E2) = NaN ; OHT_SOM(OHT_SOM > 5E2) = NaN ; 
%%%%%%%
       fig_name = strcat('Ocn_heat_trnsprt_last100_COMPARE_neg_pos_1800_IndPac');%,num2str(tt));
        fig_dum = figure(2);
      set(fig_dum, 'name', fig_name,'numbertitle','on');
      set(fig_dum,'units','inches','position',[0.5,0.5,11,8]);%,'PaperOrientation','landscape');
      set(fig_dum,'paperpositionmode','auto');
cl = ['b','r','m','g','k','b','r','m','g']; 
nb = [7:10 2 6:-1:3 1] ;

 h(10) = plot(lat_pop,squeeze(OHT(:,10)),'m','linewidth',2) ; hold on;
% h(11) = plot(lat_SOM,squeeze(OHT_SOM),':k','linewidth',2) ; hold on;
for j = 1:5
    if (j==3)
      h(j)=plot(lat_pop,squeeze(OHT(:,j)),'color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat_pop,squeeze(OHT(:,j)),'color',cl(j),'linewidth',2) ; hold on;
    end
end
for j = 6:9
    if (j==8)
      h(j)=plot(lat_pop,squeeze(OHT(:,j)),'--','color',purple,'linewidth',2) ; hold on;        
    else
      h(j)=plot(lat_pop,squeeze(OHT(:,j)),'--','color',cl(j),'linewidth',2) ; hold on;
    end
end

    xlabel('Latitude (\circ)','fontsize',23,'fontweight','bold');
    ylabel('Ocean Heat Transport (PW)','fontsize',23,'fontweight','bold');
xlim([-95 95])
ylim([-1.2 1.7])
   hleg1 = legend([h(10) h(5) h(9) h(8) h(7) h(6) h(1) h(2) h(3) h(4)],'1','2',...
         '3','4','5','6','7','8','9','10');% ,'SOM');
    set(hleg1,'Location','NorthWest','Fontsize',17)%h_legend-4)
    set(hleg1,'Interpreter','none')%,'box','Off')
set(gca,'Fontsize',20,'linewidth',1.5)
box on
cd (address)
  print ('-r600', fig_name,'-depsc')     
