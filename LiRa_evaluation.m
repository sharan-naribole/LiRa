clear all;
close all;
clc;

%THIS program will be the comprehensive file on LiRa evaluation

%Figure 1
%ASMA's Radio Trigger Evaluation
load global_params.mat;

Ndistr = 50; %No. of distributions of VLC clients
Nlu_max = 2;
Nclients_max = 10;
Ntrigger_time = 3;%1 ms, 5 ms, 10 ms
Nwifi_chan = 3;
Nuplink_mcs = 3;

uplink_mcs = [6, 18, 54];
uplink_mcs_id = [1,3,7];
wifi_chan = [1,14,48];
trigger_times = [1,5,10]*1e3;% in microseconds

chan_curr = 2;
trigg_curr = 2;
uplink_mcs_iter = 2;


% 802.11-based contention approach
load WARP_MEASURES/FIRST_ROUND_WITHOUT_RETX/FORMATTED_DATA/80211_VLC_LU_performance_metrics_alt.mat
res_del_80211 = response_delay;
wifi_tput_deg_80211 = legacy_wifi_tput_deg;

%LiRa - Night
load WARP_MEASURES/FIRST_ROUND_WITHOUT_RETX/FORMATTED_DATA/LiRa_performance_metrics.mat
res_del_lira = response_delay;
wifi_tput_deg_lira = legacy_wifi_tput_deg;

%LiRa - 1 Gbps
load WARP_MEASURES/FIRST_ROUND_WITHOUT_RETX/FORMATTED_DATA/LiRa_1Gbps_performance_metrics.mat;
res_del_lira_1Gbps = response_delay;
wifi_tput_deg_lira_1Gbps = legacy_wifi_tput_deg;

%LiRa - 10 Mbps
load WARP_MEASURES/FIRST_ROUND_WITHOUT_RETX/FORMATTED_DATA/LiRa_10Mbps_performance_metrics.mat;
res_del_lira_10Mbps = response_delay;
wifi_tput_deg_lira_10Mbps = legacy_wifi_tput_deg;

%% PLOTS 
legend_trigg= {'1 ms','5 ms','10 ms'};
legend_lu= {'1 Legacy user - 6 Mbps', '1 Legacy User - 18 Mbps', '1 Legacy User - 54 Mbps', '2 Legacy Users - 18 Mbps', '3 Legacy Users - 18 Mbps'};
legend_dt = {'Variable MCS', '1 Gbps', '10 Mbps'};

% %Sub-section: Response Delay Evaluation
% %Graph 1: Trigger Time Evaluation
% comp=[1 2 3];
% %cc = hsv(max(size(comp)));
% figure;
% colormap inferno;
% for t=1:1:max(size(comp))
%      errorbar(1:Nclients_max,0.001*squeeze(median(res_del_lira(:,1,:,t,3,2,1),3)),0.25*0.001*squeeze(median(res_del_lira(:,1,:,t,3,2,2),3)));%,'color',cc(t,:));
%      %errorbar(1:Nclient_locs,squeeze(tr_oh_res(:,comp(t),1)),squeeze(tr_oh_res(:,comp(t),2)));%,'color',cc(t,:));
%      hold all;
% end
% grid on;
% xlabel('NO. OF LIRA CLIENTS --->');
% ylabel('RESPONSE DELAY (ms)');
% legend(legend_trigg);
% set(gca,'FontSize',24,'fontWeight','bold');
% set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
% 
% %Graph 2: Legacy User Performance Evaluation
% comp=[1 2 3 4 5];
% %cc = hsv(max(size(comp)));
% figure;
% colormap inferno;
% for t=1:1:max(size(comp))
%      if(t < 4)
%          errorbar(1:Nclients_max,0.001*squeeze(median(res_del_lira(:,1,:,2,3,t,1),3)),0*0.001*squeeze(median(res_del_lira(:,1,:,2,3,t,2),3)));%,'color',cc(t,:));
%      else
%          errorbar(1:Nclients_max,0.001*squeeze(median(res_del_lira(:,t-2,:,2,3,2,1),3)),0*0.001*squeeze(median(res_del_lira(:,t-2,:,2,3,2,2),3)));%,'color',cc(t,:));
%      end
%      %errorbar(1:Nclient_locs,squeeze(tr_oh_res(:,comp(t),1)),squeeze(tr_oh_res(:,comp(t),2)));%,'color',cc(t,:));
%      hold all;
% end
% grid on;
% xlabel('NO. OF LIRA CLIENTS --->');
% ylabel('RESPONSE DELAY (ms)');
% legend(legend_lu);
% set(gca,'FontSize',24,'fontWeight','bold');
% set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
% 
% %Sub-section: Legacy Wi-Fi throughput Degradation Evaluation
% %Graph 1: Trigger Time Evaluation
% comp=[1 2 3];
% %cc = hsv(max(size(comp)));
% figure;
% colormap inferno;
% for t=1:1:max(size(comp))
%      errorbar(1:Nclients_max,squeeze(median(wifi_tput_deg_lira(:,1,:,t,3,2),3)),0.25*squeeze(median(wifi_tput_deg_lira(:,1,:,t,3,2),3)));%,'color',cc(t,:));
%      %errorbar(1:Nclient_locs,squeeze(tr_oh_res(:,comp(t),1)),squeeze(tr_oh_res(:,comp(t),2)));%,'color',cc(t,:));
%      hold all;
% end
% grid on;
% xlabel('NO. OF LIRA CLIENTS --->');
% ylabel('WIFI THROUGHPUT DEGRADATION --->');
% legend(legend_trigg);
% set(gca,'FontSize',24,'fontWeight','bold');
% set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
% 
% %Graph 2: Downlink Transmission Impact
% comp=[1 2 3 4];
% %cc = hsv(max(size(comp)));
% figure;
% colormap inferno;
% errorbar(1:Nclients_max,squeeze(median(wifi_tput_deg_lira(:,3,:,2,3,2),3)),0.25*squeeze(median(wifi_tput_deg_lira(:,3,:,2,3,2),3)));%,'color',cc(t,:));
% hold on
% errorbar(1:Nclients_max,squeeze(median(wifi_tput_deg_lira_1Gbps(:,3,:,2,3,2),3)),0.25*squeeze(median(wifi_tput_deg_lira_1Gbps(:,3,:,2,3,2),3)));%,'color',cc(t,:));
% hold on
% errorbar(1:Nclients_max,squeeze(median(wifi_tput_deg_lira_10Mbps(:,3,:,2,3,2),3)),0.25*squeeze(median(wifi_tput_deg_lira_10Mbps(:,3,:,2,3,2),3)));%,'color',cc(t,:));
% 
% grid on;
% xlabel('NO. OF LIRA CLIENTS --->');
% ylabel('WIFI THROUGHPUT DEGRADATION ---> ');
% legend(legend_dt);
% set(gca,'FontSize',24,'fontWeight','bold');
% set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

%Sub-section 3: Per-Client Contention
%VLC-LU: 1-1, 1-2, 1-3, 1-4, 2-2, 2-3, 3-2

%% PLOTS 
legend_clients = {'1 Client', '5 Clients', '10 Clients'};
legend_trigg= {'1 ms','5 ms','10 ms'};
legend_lu= {'1 Legacy user - 6 Mbps', '1 Legacy User - 18 Mbps', '1 Legacy User - 54 Mbps', '2 Legacy Users - 18 Mbps', '3 Legacy Users - 18 Mbps'};
legend_dt = {'Variable MCS', '1 Gbps', '10 Mbps'};
legend_wifi = {'Channel 1', 'Channel 14', 'Channel 48'};
legend_pcc = {'LiRa - 1 ms trigger', 'LiRa - 4 ms trigger', 'LiRa - 7 ms trigger' , '802.11 Per-Client Contention'};

% Response Delay with Trigger time
%Constants: 4 LU, 18 Mbps, Channel 48
%Bar graph
%-> X-axis: trigger times: 1, 4, 7, 10
%-> Y-axis: 1, 5, 10, 15 clients

% comp=[1 2 3 4];
% figure;
% colormap inferno;
% y = 0.001*[median(res_del_lira(1,4,:,1,3,2,1),3) median(res_del_lira(5,4,:,1,3,2,1),3) median(res_del_lira(10,4,:,1,3,2,1),3);
%     median(res_del_lira(1,4,:,2,3,2,1),3) median(res_del_lira(5,4,:,2,3,2,1),3) median(res_del_lira(10,4,:,2,3,2,1),3);
%     median(res_del_lira(1,4,:,3,3,2,1),3) median(res_del_lira(5,4,:,3,3,2,1),3) median(res_del_lira(10,4,:,3,3,2,1),3);
%     ];
% bar(y)
% grid on;
% xlabel('FEEDBACK TRIGGER TIME (ms)');
% ylabel('RESPONSE DELAY (ms)');
% legend(legend_clients);
% set(gca,'FontSize',24,'fontWeight','bold');
% set(gca,'XTickLabel',{'1 ms', '5 ms', '10 ms'})
% set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

%  Feedback Channel Access Delay:
% Bar graph:
% Constants: 10 clients
% X-axis: 1 LU - 6 Mbps, 1 LU - 18 Mbps, 4 LU - 6 Mbps,  4 LU - 54 Mbps
% Trigger time: 4 ms
% Y-axis: Channel 1, Channel 14, Channel 48
% Inter-cell interference

% comp=[1 2 3 4];
% figure;
% colormap inferno;
% trigg_ind = 2;
% y = 0.001*[median(res_del_lira(10,1,:,trigg_ind,1,1,1),3) median(res_del_lira(10,1,:,trigg_ind,2,1,1),3) median(res_del_lira(10,1,:,trigg_ind,3,1,1),3);
%     median(res_del_lira(10,1,:,trigg_ind,1,3,1),3) median(res_del_lira(10,1,:,trigg_ind,2,3,1),3) median(res_del_lira(10,1,:,trigg_ind,3,3,1),3);
%     median(res_del_lira(10,3,:,trigg_ind,1,1,1),3) median(res_del_lira(10,3,:,trigg_ind,2,1,1),3) median(res_del_lira(10,3,:,trigg_ind,3,1,1),3);
%     median(res_del_lira(10,3,:,trigg_ind,1,3,1),3) median(res_del_lira(10,3,:,trigg_ind,2,3,1),3) median(res_del_lira(10,3,:,trigg_ind,3,3,1),3);
%     ];
% bar(y)
% grid on;
% xlabel('LEGACY RF TRAFFIC FLOWS - MCS');
% ylabel('RESPONSE DELAY (ms)');
% set(gca,'XTickLabel',{'1 FLOW - 6 Mbps', '1 FLOW - 54 Mbps', '3 FLOWS - 6 Mbps', '3 FLOWS - 54 Mbps'})
% legend(legend_wifi);
% set(gca,'FontSize',24,'fontWeight','bold');
% set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

comp=[1 2 3 4];
figure;
colormap inferno;
trigg_ind = 2;
y = 0.001*[median(res_del_lira(10,1,:,trigg_ind,1,1,1),3) median(res_del_lira(10,1,:,trigg_ind,2,1,1),3) median(res_del_lira(10,1,:,trigg_ind,3,1,1),3);
    median(res_del_lira(10,1,:,trigg_ind,1,3,1),3) median(res_del_lira(10,1,:,trigg_ind,2,3,1),3) median(res_del_lira(10,1,:,trigg_ind,3,3,1),3);
    ];
bar(y)
grid on;
xlabel('PER-FLOW DATA RATE - 1 FLOW');
ylabel('RESPONSE DELAY (ms)');
legend(legend_wifi);
set(gca,'XTickLabel',{'6 Mbps', '54 Mbps'})
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

comp=[1 2 3 4];
figure;
colormap inferno;
trigg_ind = 2;
y = 0.001*[
    median(res_del_lira(10,3,:,trigg_ind,1,1,1),3) median(res_del_lira(10,3,:,trigg_ind,2,1,1),3) median(res_del_lira(10,3,:,trigg_ind,3,1,1),3);
    median(res_del_lira(10,3,:,trigg_ind,1,3,1),3) median(res_del_lira(10,3,:,trigg_ind,2,3,1),3) median(res_del_lira(10,3,:,trigg_ind,3,3,1),3);
    ];
bar(y)
grid on;
xlabel('PER-FLOW DATA RATE - 3 FLOWS');
ylabel('RESPONSE DELAY (ms)');
legend(legend_wifi);
set(gca,'XTickLabel',{'6 Mbps', '54 Mbps'})
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

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

% %Response Delay
% y = 0.001*[median(res_del_lira(1,1,:,1,3,2,1),3) median(res_del_lira(1,1,:,2,3,2,1),3) median(res_del_lira(1,1,:,3,3,2,1),3) median(res_del_80211(1,:,3,2,1),2); 
%     median(res_del_lira(1,2,:,1,3,2,1),3) median(res_del_lira(1,2,:,2,3,2,1),3) median(res_del_lira(1,2,:,3,3,2,1),3) median(res_del_80211(2,:,3,2,1),2);
%     median(res_del_lira(1,3,:,1,3,2,1),3) median(res_del_lira(1,3,:,2,3,2,1),3) median(res_del_lira(1,3,:,3,3,2,1),3) median(res_del_80211(3,:,3,2,1),2);
%     median(res_del_lira(1,4,:,1,3,2,1),3) median(res_del_lira(1,4,:,2,3,2,1),3) median(res_del_lira(1,4,:,3,3,2,1),3) median(res_del_80211(4,:,3,2,1),2);
%     ];
% figure
% bar(y)
% 
% %Wi-Fi Throughput Degradation
% z = [median(wifi_tput_deg_lira(1,1,:,1,3,2),3) median(wifi_tput_deg_lira(1,1,:,2,3,2),3) median(wifi_tput_deg_lira(1,1,:,3,3,2),3) median(wifi_tput_deg_80211(1,:,3,2),2); 
%     median(wifi_tput_deg_lira(1,2,:,1,3,2),3) median(wifi_tput_deg_lira(1,2,:,2,3,2),3) median(wifi_tput_deg_lira(1,2,:,3,3,2),3) median(wifi_tput_deg_80211(2,:,3,2),2)
%     median(wifi_tput_deg_lira(1,3,:,1,3,2),3) median(wifi_tput_deg_lira(1,3,:,2,3,2),3) median(wifi_tput_deg_lira(1,3,:,3,3,2),3) median(wifi_tput_deg_80211(3,:,3,2),2)
%     median(wifi_tput_deg_lira(1,4,:,1,3,2),3) median(wifi_tput_deg_lira(1,4,:,2,3,2),3) median(wifi_tput_deg_lira(1,4,:,3,3,2),3) median(wifi_tput_deg_80211(4,:,3,2),2)
%     ];
% figure
% bar(z)
% 
% %Inter-Cell Interference
% q = 0.001*[median(res_del_lira(1,1,:,2,1,2,1),3) median(res_del_lira(1,1,:,2,2,2,1),3) median(res_del_lira(1,1,:,2,3,2,1),3) median(res_del_80211(1,:,1,2,1),2) median(res_del_80211(1,:,2,2,1),2) median(res_del_80211(1,:,3,2,1),2);
%     median(res_del_lira(1,2,:,2,1,2,1),3) median(res_del_lira(1,2,:,2,2,2,1),3) median(res_del_lira(1,2,:,2,3,2,1),3) median(res_del_80211(2,:,1,2,1),2) median(res_del_80211(2,:,2,2,1),2) median(res_del_80211(2,:,3,2,1),2);
%     median(res_del_lira(1,3,:,2,1,2,1),3) median(res_del_lira(1,3,:,2,2,2,1),3) median(res_del_lira(1,3,:,2,3,2,1),3) median(res_del_80211(3,:,1,2,1),2) median(res_del_80211(3,:,2,2,1),2) median(res_del_80211(3,:,3,2,1),2);
%     median(res_del_lira(1,4,:,2,1,2,1),3) median(res_del_lira(1,4,:,2,2,2,1),3) median(res_del_lira(1,4,:,2,3,2,1),3) median(res_del_80211(4,:,1,2,1),2) median(res_del_80211(4,:,2,2,1),2) median(res_del_80211(4,:,3,2,1),2);
%     ];
% figure
% bar(q)
% 
% 
% f = [median(wifi_tput_deg_lira(1,1,:,2,1,2),3) median(wifi_tput_deg_lira(1,1,:,2,2,2),3) median(wifi_tput_deg_lira(1,1,:,2,3,2),3) median(wifi_tput_deg_80211(1,:,1,2),2) median(wifi_tput_deg_80211(1,:,2,2),2) median(wifi_tput_deg_80211(1,:,3,2),2);
%     median(wifi_tput_deg_lira(1,2,:,2,1,2),3) median(wifi_tput_deg_lira(1,2,:,2,2,2),3) median(wifi_tput_deg_lira(1,2,:,2,3,2),3) median(wifi_tput_deg_80211(2,:,1,2),2) median(wifi_tput_deg_80211(2,:,2,2),2) median(wifi_tput_deg_80211(2,:,3,2),2);
%     median(wifi_tput_deg_lira(1,3,:,2,1,2),3) median(wifi_tput_deg_lira(1,3,:,2,2,2),3) median(wifi_tput_deg_lira(1,3,:,2,3,2),3) median(wifi_tput_deg_80211(3,:,1,2),2) median(wifi_tput_deg_80211(3,:,2,2),2) median(wifi_tput_deg_80211(3,:,3,2),2);
%     median(wifi_tput_deg_lira(1,4,:,2,1,2),3) median(wifi_tput_deg_lira(1,4,:,2,2,2),3) median(wifi_tput_deg_lira(1,4,:,2,3,2),3) median(wifi_tput_deg_80211(4,:,1,2),2) median(wifi_tput_deg_80211(4,:,2,2),2) median(wifi_tput_deg_80211(4,:,3,2),2);
%     ];
% figure
% bar(f)

