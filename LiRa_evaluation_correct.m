clear all;
close all;
clc;

%THIS program will be the comprehensive file on LiRa evaluation

%Figure 1
%ASMA's Radio Trigger Evaluation
load global_params.mat;

Nclients_max = 10;
Nlu_max = 4;
Ndistr = 50; %No. of distributions of VLC clients

uplink_mcs = [6, 18, 54];
uplink_mcs_id = [1,3,7];
wifi_chan = [1,14,48];
trigger_times = [1,2.5,4,5.5,7,8.5,10]*1e3;% in microseconds
Ntrigger_time = max(size(trigger_times));%1 ms, 5 ms, 10 ms
Nwifi_chan = max(size(wifi_chan));
Nuplink_mcs = max(size(uplink_mcs));

chan_curr = 2;
trigg_curr = 2;
uplink_mcs_iter = 2;

% 802.11-based contention approach
load WARP_PROCESSED_DATA/NSDI_2017/80211_PCC_performance_metrics_correct.mat
res_del_80211 = response_delay;
wifi_tput_deg_80211 = 100*legacy_wifi_tput_deg;

%LiRa - Night
load WARP_PROCESSED_DATA/LiRa_performance_metrics_correct.mat
res_del_lira = response_delay;
wifi_tput_deg_lira = legacy_wifi_tput_deg;

%% PLOTS 
legend_clients = {'1 Client', '5 Clients', '10 Clients', '15 Clients'};
legend_trigg= {'1 ms','5 ms','10 ms'};
legend_lu= {'1 Legacy user - 6 Mbps', '1 Legacy User - 18 Mbps', '1 Legacy User - 54 Mbps', '2 Legacy Users - 18 Mbps', '3 Legacy Users - 18 Mbps'};
legend_dt = {'Variable MCS', '1 Gbps', '10 Mbps'};
legend_wifi = {'Channel 1', 'Channel 14', 'Channel 48'};
legend_pcc = {'LiRa - 1 ms trigger', 'LiRa - 4 ms trigger', 'LiRa - 7 ms trigger' , '802.11 Per-Client Contention'};

% wifi_chan = 3;
% uplink_mcs = 2;
% % 
% % PCC Comparison - WiFi Degradation
% figure;
% colormap inferno;
% f = [median(wifi_tput_deg_lira(1,1,:,1,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(1,1,:,2,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(1,1,:,3,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_80211(1,:,wifi_chan,uplink_mcs),2);
%     median(wifi_tput_deg_lira(2,1,:,1,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(2,1,:,2,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(2,1,:,3,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_80211(2,:,wifi_chan,uplink_mcs),2);
%     median(wifi_tput_deg_lira(3,1,:,1,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(3,1,:,2,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(3,1,:,3,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_80211(3,:,wifi_chan,uplink_mcs),2);
%     median(wifi_tput_deg_lira(4,1,:,1,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(4,1,:,2,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(4,1,:,3,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_80211(4,:,wifi_chan,uplink_mcs),2);
%     ];
% bar(f)
% grid on;
% xlabel('NO. OF VLC CLIENTS');
% ylabel('WIFI THROUGHPUT DEGRADATION (%)');
% legend(legend_pcc);
% set(gca,'FontSize',24,'fontWeight','bold');
% %set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
% set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

% PCC Comparison - WiFi Channel Analysis
wifi_chan = 3;
uplink_mcs = 2;
figure;
colormap inferno;



 ppp = [mean(wifi_tput_deg_80211(1,:,1,uplink_mcs),2) mean(wifi_tput_deg_80211(1,:,2,uplink_mcs),2) mean(wifi_tput_deg_80211(1,:,3,uplink_mcs),2);
    mean(wifi_tput_deg_80211(2,:,1,uplink_mcs),2) mean(wifi_tput_deg_80211(2,:,2,uplink_mcs),2) mean(wifi_tput_deg_80211(2,:,3,uplink_mcs),2);
    mean(wifi_tput_deg_80211(3,:,1,uplink_mcs),2) mean(wifi_tput_deg_80211(3,:,2,uplink_mcs),2) mean(wifi_tput_deg_80211(3,:,3,uplink_mcs),2);
    mean(wifi_tput_deg_80211(4,:,1,uplink_mcs),2) mean(wifi_tput_deg_80211(4,:,2,uplink_mcs),2) mean(wifi_tput_deg_80211(4,:,3,uplink_mcs),2);
    ];
boxplot(ppp)
grid on;
xlabel('NO. OF VLC CLIENTS');
ylabel('WIFI THROUGHPUT DEGRADATION (%)');
legend(legend_wifi);
set(gca,'FontSize',24,'fontWeight','bold');
set(gca,'XTickLabel',{'1', '3', '3', '4'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
                                                                    

figure;
colormap inferno;
ddd = 0.001*[mean(res_del_80211(1,:,1,uplink_mcs,1),2) mean(res_del_80211(1,:,2,uplink_mcs,1),2) mean(res_del_80211(1,:,3,uplink_mcs,1),2); 
    mean(res_del_80211(2,:,1,uplink_mcs,1),2) mean(res_del_80211(2,:,2,uplink_mcs,1),2) mean(res_del_80211(2,:,3,uplink_mcs,1),2);
    mean(res_del_80211(3,:,1,uplink_mcs,1),2) mean(res_del_80211(3,:,2,uplink_mcs,1),2) mean(res_del_80211(3,:,3,uplink_mcs,1),2);
    mean(res_del_80211(4,:,1,uplink_mcs,1),2) mean(res_del_80211(4,:,2,uplink_mcs,1),2) mean(res_del_80211(4,:,3,uplink_mcs,1),2);
    ];
boxplot(ddd)

grid on;
xlabel('NO. OF VLC CLIENTS');
ylabel('RESPONSE DELAY (ms)');
legend(legend_wifi);
set(gca,'FontSize',24,'fontWeight','bold');
%set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

                                                                       

