clear all;
close all;
clc;

%THIS program will be the comprehensive file on LiRa evaluation

%Figure 1
%ASMA's Radio Trigger Evaluation
load global_params.mat;

Nclients_max = 10;
Nlu_max = 4;
Ndistr = 20; %No. of distributions of VLC clients

uplink_mcs = [18];
uplink_mcs_id = [3];
wifi_chan = [1,14,48];
trigger_times = [1,5,10]*1e3;% in microseconds
Ntrigger_time = max(size(trigger_times));%1 ms, 5 ms, 10 ms
Nwifi_chan = max(size(wifi_chan));
Nuplink_mcs = max(size(uplink_mcs));

% 802.11-based contention approach
load WARP_PROCESSED_DATA/SECON_80211_performance_metrics.mat
res_del_80211 = response_delay;
wifi_tput_deg_80211 = 100*legacy_wifi_tput_deg_ota;

%LiRa - Night
load WARP_PROCESSED_DATA/SECON_LiRa_performance_metrics.mat
res_del_lira = response_delay;
wifi_tput_deg_lira = legacy_wifi_tput_deg;

%% PLOTS 
legend_clients = {'1 Client', '5 Clients', '10 Clients', '15 Clients'};
legend_trigg= {'1 ms','5 ms','10 ms'};
legend_lu= {'1 Legacy user - 6 Mbps', '1 Legacy User - 18 Mbps', '1 Legacy User - 54 Mbps', '2 Legacy Users - 18 Mbps', '3 Legacy Users - 18 Mbps'};
legend_dt = {'Variable MCS', '1 Gbps', '10 Mbps'};
legend_wifi = {'Channel 1', 'Channel 14', 'Channel 48'};
legend_pcc = {'LiRa - 1 ms trigger', 'LiRa - 4 ms trigger', 'LiRa - 7 ms trigger' , '802.11 Per-Client Contention'};

%% LiRa Plots 

% Response Delay with Trigger time
%Constants: 4 LU, 18 Mbps, Channel 48
%Bar graph
%-> X-axis: trigger times: 1, 4, 7, 10
%-> Y-axis: 1, 5, 10, 15 clients

wifi_chan = 3;
uplink_mcs = 1;

comp=[1 2 3 4];
figure;
colormap inferno;
y = 0.001*[median(res_del_lira(1,1,:,1,wifi_chan,uplink_mcs,1),3) median(res_del_lira(5,1,:,1,wifi_chan,uplink_mcs,1),3) median(res_del_lira(10,1,:,1,wifi_chan,uplink_mcs,1),3);
    median(res_del_lira(1,1,:,2,wifi_chan,uplink_mcs,1),3) median(res_del_lira(5,1,:,2,wifi_chan,uplink_mcs,1),3) median(res_del_lira(10,1,:,2,wifi_chan,uplink_mcs,1),3);
    median(res_del_lira(1,1,:,3,wifi_chan,uplink_mcs,1),3) median(res_del_lira(5,1,:,3,wifi_chan,uplink_mcs,1),3) median(res_del_lira(10,1,:,3,wifi_chan,uplink_mcs,1),3);
    ];
bar(y)
grid on;
xlabel('FEEDBACK TRIGGER TIME (ms)');
ylabel('RESPONSE DELAY (ms)');
legend(legend_clients);
set(gca,'FontSize',24,'fontWeight','bold');
set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

% %  Feedback Channel Access Delay:
% % Bar graph:
% % Constants: 10 clients
% % X-axis: 1 LU - 6 Mbps, 1 LU - 18 Mbps, 4 LU - 6 Mbps,  4 LU - 54 Mbps
% % Trigger time: 4 ms
% % Y-axis: Channel 1, Channel 14, Channel 48
% % Inter-cell interference
% 
% comp=[1 2 3 4];
% figure;
% colormap inferno;
% trigg_ind = 1;
% y = 0.001*[median(res_del_lira(10,1,:,trigg_ind,1,1,1),3) median(res_del_lira(10,1,:,trigg_ind,2,1,1),3) median(res_del_lira(10,1,:,trigg_ind,3,1,1),3);
%     median(res_del_lira(10,1,:,trigg_ind,1,3,1),3) median(res_del_lira(10,1,:,trigg_ind,2,3,1),3) median(res_del_lira(10,1,:,trigg_ind,3,3,1),3);
%     median(res_del_lira(10,4,:,trigg_ind,1,1,1),3) median(res_del_lira(10,4,:,trigg_ind,2,1,1),3) median(res_del_lira(10,4,:,trigg_ind,3,1,1),3);
%     median(res_del_lira(10,4,:,trigg_ind,1,3,1),3) median(res_del_lira(10,4,:,trigg_ind,2,3,1),3) median(res_del_lira(10,4,:,trigg_ind,3,3,1),3);
%     ];
% bar(y)
% grid on;
% xlabel('LEGACY RF TRAFFIC FLOWS - MCS');
% ylabel('RESPONSE DELAY (ms)');
% legend(legend_wifi);
% set(gca,'FontSize',24,'fontWeight','bold');
% set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
% 
% %Legacy Wi-Fi Degradation with Trigger Time
% comp=[1 2 3 4];
% figure;
% colormap inferno;
% y = [median(wifi_tput_deg_lira(1,4,:,1,3,2),3) median(wifi_tput_deg_lira(5,4,:,1,3,2),3) median(wifi_tput_deg_lira(10,4,:,1,3,2),3) median(wifi_tput_deg_lira_15_clients(15,4,:,1,3,2),3);
%     median(wifi_tput_deg_lira(1,4,:,3,3,2),3) median(wifi_tput_deg_lira(5,4,:,3,3,2),3) median(wifi_tput_deg_lira(10,4,:,3,3,2),3) median(wifi_tput_deg_lira_15_clients(15,4,:,3,3,2),3);
%     median(wifi_tput_deg_lira(1,4,:,5,3,2),3) median(wifi_tput_deg_lira(5,4,:,5,3,2),3) median(wifi_tput_deg_lira(10,4,:,5,3,2),3) median(wifi_tput_deg_lira_15_clients(15,4,:,5,3,2),3);
%     median(wifi_tput_deg_lira(1,4,:,7,3,2),3) median(wifi_tput_deg_lira(5,4,:,7,3,2),3) median(wifi_tput_deg_lira(10,4,:,7,3,2),3) median(wifi_tput_deg_lira_15_clients(15,4,:,7,3,2),3);
%     ];
% bar(y)
% grid on;
% xlabel('FEEDBACK TRIGGER TIME (ms)');
% ylabel('WIFI THROUGHPUT DEGRADATION (%)');
% legend(legend_clients);
% set(gca,'FontSize',24,'fontWeight','bold');
% set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
% set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
% 
% 
% %% BOX PLOTS
% %wifi_chan = 3;
% uplink_mcs = 1;
% Ngroups = 3;
% 
% %RESPONSE DELAY
% data = 0.001*[res_del_80211(1,:,1,1,uplink_mcs), res_del_80211(1,:,1,2,uplink_mcs), res_del_80211(1,:,1,3,uplink_mcs), res_del_80211(2,:,1,1,uplink_mcs), res_del_80211(2,:,1,2,uplink_mcs), res_del_80211(2,:,1,3,uplink_mcs), res_del_80211(3,:,1,1,uplink_mcs), res_del_80211(3,:,1,2,uplink_mcs), res_del_80211(3,:,1,3,uplink_mcs), res_del_80211(4,:,1,1,uplink_mcs), res_del_80211(4,:,1,2,uplink_mcs), res_del_80211(4,:,1,3,uplink_mcs), res_del_80211(5,:,1,1,uplink_mcs), res_del_80211(5,:,1,2,uplink_mcs), res_del_80211(5,:,1,3,uplink_mcs)];
% grouping = [ones(1,Ndistr), 2*ones(1,Ndistr), 3*ones(1,Ndistr), 4*ones(1,Ndistr), 5*ones(1,Ndistr), 6*ones(1,Ndistr), 7*ones(1,Ndistr), 8*ones(1,Ndistr), 9*ones(1,Ndistr), 10*ones(1,Ndistr) 11*ones(1,Ndistr), 12*ones(1,Ndistr), 13*ones(1,Ndistr), 14*ones(1,Ndistr), 15*ones(1,Ndistr)];
% positions = [1 1.25 1.5 2 2.25 2.5 3 3.25 3.5 4 4.25 4.5 5 5.25 5.5];
% boxplot(data,grouping,'positions',positions);
% grid on;
% set(gca,'FontSize',12,'fontWeight','bold');
% set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold');
% xlabel('NUMBER OF VLC USERS');
% ylabel('RESPONSE DELAY (ms)');
% set(gca,'xtick',[mean(positions(1:3)) mean(positions(4:6)) mean(positions(7:9)) mean(positions(10:12)) mean(positions(13:15))]);
% set(gca,'xticklabel',{'1','2', '3','4','5'});
% 
% cc = hsv(Ngroups);
% color = ['r'; 'c'; 'k'];
% color = repmat(color,1,5);
% h = findobj(gca,'Tag','Box');
% for j=1:length(h)
%    patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.75);
% end
% 
% c = get(gca, 'Children');
% hleg1 = legend(c(1:3), 'CHANNEL 1 - 2.4 GHz', 'CHANNEL 14 - 2.4 GHz', 'CHANNEL 48 -  5 GHz', 'Location','northwest');
% %print(gcf, '-dpdf', '80211_res_del_SECON.pdf'); 
% 
% figure;
% 
% data = [wifi_tput_deg_80211(1,:,1,1,uplink_mcs), wifi_tput_deg_80211(1,:,1,3,uplink_mcs), wifi_tput_deg_80211(2,:,1,1,uplink_mcs), wifi_tput_deg_80211(2,:,1,3,uplink_mcs), wifi_tput_deg_80211(3,:,1,1,uplink_mcs), wifi_tput_deg_80211(3,:,1,3,uplink_mcs), wifi_tput_deg_80211(4,:,1,1,uplink_mcs), wifi_tput_deg_80211(4,:,1,3,uplink_mcs), wifi_tput_deg_80211(5,:,1,1,uplink_mcs), wifi_tput_deg_80211(5,:,1,3,uplink_mcs)];
% grouping = [ones(1,Ndistr), 2*ones(1,Ndistr), 3*ones(1,Ndistr), 4*ones(1,Ndistr), 5*ones(1,Ndistr), 6*ones(1,Ndistr), 7*ones(1,Ndistr), 8*ones(1,Ndistr), 9*ones(1,Ndistr), 10*ones(1,Ndistr)];
% positions = [1 1.25 2 2.25 3 3.25 4 4.25 5 5.25];
% boxplot(data,grouping,'positions',positions);
% grid on;
% set(gca,'FontSize',12,'fontWeight','bold');
% set(findall(gcf,'type','text'),'FontSize',12,'fontWeight','bold');
% xlabel('NUMBER OF VLC USERS');
% ylabel('Wi-Fi DEGRADATION (%)');
% set(gca,'xtick',[mean(positions(1:2)) mean(positions(3:4)) mean(positions(5:6)) mean(positions(7:8)) mean(positions(9:10))]);
% set(gca,'xticklabel',{'1','2', '3','4','5'});
% 
% cc = hsv(Ngroups);
% color = ['r'; 'c'];
% color = repmat(color,1,5);
% h = findobj(gca,'Tag','Box');
% for j=1:length(h)
%    patch(get(h(j),'XData'),get(h(j),'YData'),color(j),'FaceAlpha',.75);
% end
% 
% c = get(gca, 'Children');
% hleg1 = legend(c(1:2), 'CHANNEL 1 - 2.4 GHz','CHANNEL 48 -  5 GHz', 'Location','northwest');
% %print(gcf, '-dpdf', '80211_wifi_deg_SECON.pdf'); 
% 
% %% BAR GRAPHSe
% 
% % % PCC Comparison - WiFi Channel Analysis
% % wifi_chan = 3;
% % uplink_mcs = 1;
% % figure;
% % colormap inferno;
% % 
% % 
% % 
% %  ppp = [mean(wifi_tput_deg_80211(1,:,1,1,uplink_mcs),2) mean(wifi_tput_deg_80211(1,:,1,2,uplink_mcs),2) mean(wifi_tput_deg_80211(1,:,1,3,uplink_mcs),2);
% %     mean(wifi_tput_deg_80211(2,:,1,1,uplink_mcs),2) mean(wifi_tput_deg_80211(2,:,1,2,uplink_mcs),2) mean(wifi_tput_deg_80211(2,:,1,3,uplink_mcs),2);
% %     mean(wifi_tput_deg_80211(3,:,1,1,uplink_mcs),2) mean(wifi_tput_deg_80211(3,:,1,2,uplink_mcs),2) mean(wifi_tput_deg_80211(3,:,1,3,uplink_mcs),2);
% %     mean(wifi_tput_deg_80211(4,:,1,1,uplink_mcs),2) mean(wifi_tput_deg_80211(4,:,1,2,uplink_mcs),2) mean(wifi_tput_deg_80211(4,:,1,3,uplink_mcs),2);
% %     ];
% % bar(ppp)
% % grid on;
% % xlabel('NO. OF VLC CLIENTS');
% % ylabel('WIFI THROUGHPUT DEGRADATION (%)');
% % legend(legend_wifi);
% % set(gca,'FontSize',24,'fontWeight','bold');
% % set(gca,'XTickLabel',{'1', '3', '3', '4'})
% % set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
% %                                                                     
% % 
% % figure;
% % colormap inferno;
% % ddd = 0.001*[mean(res_del_80211(1,:,1,1,uplink_mcs),2) mean(res_del_80211(1,:,1,2,uplink_mcs),2) mean(res_del_80211(1,:,1,3,uplink_mcs),2); 
% %     mean(res_del_80211(2,:,1,1,uplink_mcs),2) mean(res_del_80211(2,:,1,2,uplink_mcs,1),2) mean(res_del_80211(2,:,1,3,uplink_mcs),2);
% %     mean(res_del_80211(3,:,1,1,uplink_mcs),2) mean(res_del_80211(3,:,1,2,uplink_mcs,1),2) mean(res_del_80211(3,:,1,3,uplink_mcs),2);
% %     mean(res_del_80211(4,:,1,1,uplink_mcs),2) mean(res_del_80211(4,:,1,2,uplink_mcs,1),2) mean(res_del_80211(4,:,1,3,uplink_mcs),2);
% %     ];
% % bar(ddd)
% % 
% % grid on;
% % xlabel('NO. OF VLC CLIENTS');
% % ylabel('RESPONSE DELAY (ms)');
% % legend(legend_wifi);
% % set(gca,'FontSize',24,'fontWeight','bold');
% % %set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
% % set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
% % 
% %                                                                        
% % 
