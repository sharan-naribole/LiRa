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
load WARP_MEASURES/FINAL_ROUND_TRIGGER_XAXIS/FORMATTED_DATA/80211_PCC_performance_metrics_payload_100.mat
res_del_80211 = response_delay;
wifi_tput_deg_80211 = legacy_wifi_tput_deg;

%LiRa - Night
load WARP_MEASURES/FINAL_ROUND_TRIGGER_XAXIS/FORMATTED_DATA/LiRa_performance_metrics_payload_100_old_wifi_deg_tech.mat
res_del_lira = response_delay;
wifi_tput_deg_lira = legacy_wifi_tput_deg;

%LiRa - 1 Gbps
load WARP_MEASURES/FINAL_ROUND_TRIGGER_XAXIS/FORMATTED_DATA/LiRa_1Gbps_performance_metrics_payload_100.mat
res_del_lira_1Gbps = response_delay;
wifi_tput_deg_lira_1Gbps = legacy_wifi_tput_deg;

%LiRa - 10 Mbps
load WARP_MEASURES/FINAL_ROUND_TRIGGER_XAXIS/FORMATTED_DATA/LiRa_10Mbps_performance_metrics_payload_100.mat
res_del_lira_10Mbps = response_delay;
wifi_tput_deg_lira_10Mbps = legacy_wifi_tput_deg;

%LiRa - 15 clients
load WARP_MEASURES/FINAL_ROUND_TRIGGER_XAXIS/FORMATTED_DATA/LiRa_Nclients_15_performance_metrics_payload_100.mat;
res_del_lira_15_clients = response_delay;
wifi_tput_deg_lira_15_clients = legacy_wifi_tput_deg;

%% PLOTS 
legend_clients = {'1 Client', '5 Clients', '10 Clients', '15 Clients'};
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

comp=[1 2 3 4];
figure;
colormap inferno;
y = 0.001*[median(res_del_lira(1,4,:,1,3,2,1),3) median(res_del_lira(5,4,:,1,3,2,1),3) median(res_del_lira(10,4,:,1,3,2,1),3) median(res_del_lira_15_clients(15,4,:,1,3,2,1),3);
    median(res_del_lira(1,4,:,3,3,2,1),3) median(res_del_lira(5,4,:,3,3,2,1),3) median(res_del_lira(10,4,:,3,3,2,1),3) median(res_del_lira_15_clients(15,4,:,3,3,2,1),3);
    median(res_del_lira(1,4,:,5,3,2,1),3) median(res_del_lira(5,4,:,5,3,2,1),3) median(res_del_lira(10,4,:,5,3,2,1),3) median(res_del_lira_15_clients(15,4,:,5,3,2,1),3);
    median(res_del_lira(1,4,:,7,3,2,1),3) median(res_del_lira(5,4,:,7,3,2,1),3) median(res_del_lira(10,4,:,7,3,2,1),3) median(res_del_lira_15_clients(15,4,:,7,3,2,1),3);
    ];
bar(y)
grid on;
xlabel('FEEDBACK TRIGGER TIME (ms)');
ylabel('RESPONSE DELAY (ms)');
legend(legend_clients);
set(gca,'FontSize',24,'fontWeight','bold');
set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

%  Feedback Channel Access Delay:
% Bar graph:
% Constants: 10 clients
% X-axis: 1 LU - 6 Mbps, 1 LU - 18 Mbps, 4 LU - 6 Mbps,  4 LU - 54 Mbps
% Trigger time: 4 ms
% Y-axis: Channel 1, Channel 14, Channel 48
% Inter-cell interference

comp=[1 2 3 4];
figure;
colormap inferno;
trigg_ind = 1;
y = 0.001*[median(res_del_lira(10,1,:,trigg_ind,1,1,1),3) median(res_del_lira(10,1,:,trigg_ind,2,1,1),3) median(res_del_lira(10,1,:,trigg_ind,3,1,1),3);
    median(res_del_lira(10,1,:,trigg_ind,1,3,1),3) median(res_del_lira(10,1,:,trigg_ind,2,3,1),3) median(res_del_lira(10,1,:,trigg_ind,3,3,1),3);
    median(res_del_lira(10,4,:,trigg_ind,1,1,1),3) median(res_del_lira(10,4,:,trigg_ind,2,1,1),3) median(res_del_lira(10,4,:,trigg_ind,3,1,1),3);
    median(res_del_lira(10,4,:,trigg_ind,1,3,1),3) median(res_del_lira(10,4,:,trigg_ind,2,3,1),3) median(res_del_lira(10,4,:,trigg_ind,3,3,1),3);
    ];
barwitherr(errors,y)
grid on;
xlabel('LEGACY RF TRAFFIC FLOWS - MCS');
ylabel('RESPONSE DELAY (ms)');
legend(legend_wifi);
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

%Legacy Wi-Fi Degradation with Trigger Time
comp=[1 2 3 4];
figure;
colormap inferno;
y = [median(wifi_tput_deg_lira(1,4,:,1,3,2),3) median(wifi_tput_deg_lira(5,4,:,1,3,2),3) median(wifi_tput_deg_lira(10,4,:,1,3,2),3) median(wifi_tput_deg_lira_15_clients(15,4,:,1,3,2),3);
    median(wifi_tput_deg_lira(1,4,:,3,3,2),3) median(wifi_tput_deg_lira(5,4,:,3,3,2),3) median(wifi_tput_deg_lira(10,4,:,3,3,2),3) median(wifi_tput_deg_lira_15_clients(15,4,:,3,3,2),3);
    median(wifi_tput_deg_lira(1,4,:,5,3,2),3) median(wifi_tput_deg_lira(5,4,:,5,3,2),3) median(wifi_tput_deg_lira(10,4,:,5,3,2),3) median(wifi_tput_deg_lira_15_clients(15,4,:,5,3,2),3);
    median(wifi_tput_deg_lira(1,4,:,7,3,2),3) median(wifi_tput_deg_lira(5,4,:,7,3,2),3) median(wifi_tput_deg_lira(10,4,:,7,3,2),3) median(wifi_tput_deg_lira_15_clients(15,4,:,7,3,2),3);
    ];
bar(y)
grid on;
xlabel('FEEDBACK TRIGGER TIME (ms)');
ylabel('WIFI THROUGHPUT DEGRADATION (%)');
legend(legend_clients);
set(gca,'FontSize',24,'fontWeight','bold');
set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

PCC Comparison - Response Delay
No. of LiRa clients - x-axis
LiRa triggers vs PCC

wifi_chan = 2;
uplink_mcs = 1;

figure;
y = 0.001*[median(res_del_lira(1,1,:,1,wifi_chan,uplink_mcs,1),3) median(res_del_lira(1,1,:,3,wifi_chan,uplink_mcs,1),3) median(res_del_lira(1,1,:,5,wifi_chan,uplink_mcs,1),3) median(res_del_80211(1,:,wifi_chan,uplink_mcs,1),2); 
    median(res_del_lira(2,1,:,1,wifi_chan,uplink_mcs,1),3) median(res_del_lira(2,1,:,3,wifi_chan,uplink_mcs,1),3) median(res_del_lira(2,1,:,5,wifi_chan,uplink_mcs,1),3) median(res_del_80211(2,:,wifi_chan,uplink_mcs,1),2);
    median(res_del_lira(3,1,:,1,wifi_chan,uplink_mcs,1),3) median(res_del_lira(3,1,:,3,wifi_chan,uplink_mcs,1),3) median(res_del_lira(3,1,:,5,wifi_chan,uplink_mcs,1),3) median(res_del_80211(3,:,wifi_chan,uplink_mcs,1),2);
    median(res_del_lira(4,1,:,1,wifi_chan,uplink_mcs,1),3) median(res_del_lira(4,1,:,3,wifi_chan,uplink_mcs,1),3) median(res_del_lira(4,1,:,5,wifi_chan,uplink_mcs,1),3) median(res_del_80211(4,:,wifi_chan,uplink_mcs,1),2);
    ];
bar(y)

grid on;
xlabel('NO. OF VLC CLIENTS');
ylabel('RESPONSE DELAY (ms)');
legend(legend_pcc);
set(gca,'FontSize',24,'fontWeight','bold');
%set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

wifi_chan = 3;
uplink_mcs = 2;

% PCC Comparison - WiFi Degradation
figure;
f = [median(wifi_tput_deg_lira(1,1,:,1,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(1,1,:,3,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(1,1,:,5,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_80211(1,:,wifi_chan,uplink_mcs),2);
    median(wifi_tput_deg_lira(2,1,:,1,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(2,1,:,3,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(2,1,:,5,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_80211(2,:,wifi_chan,uplink_mcs),2);
    median(wifi_tput_deg_lira(3,1,:,1,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(3,1,:,3,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(3,1,:,5,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_80211(3,:,wifi_chan,uplink_mcs),2);
    median(wifi_tput_deg_lira(4,1,:,1,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(4,1,:,3,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_lira(4,1,:,5,wifi_chan,uplink_mcs),3) median(wifi_tput_deg_80211(4,:,wifi_chan,uplink_mcs),2);
    ];
bar(f)
grid on;
xlabel('NO. OF VLC CLIENTS');
ylabel('WIFI THROUGHPUT DEGRADATION (%)');
legend(legend_pcc);
set(gca,'FontSize',24,'fontWeight','bold');
%set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

% MOBILITY EVALUATION
load('WARP_MEASURES\CORRECT_RESULTS\FORMATTED_DATA\LiRa_mobility_throughput.mat')
lira_tput = throughput;

load('WARP_MEASURES\CORRECT_RESULTS\FORMATTED_DATA\80211_mobility_throughput.mat')
dot11_tput = throughput;

figure;
colormap inferno;
f = [median(lira_tput(1,1,:),3) median(lira_tput(1,2,:),3) median(lira_tput(1,3,:),3) median(dot11_tput(1,:),2);
    median(lira_tput(2,1,:),3) median(lira_tput(2,2,:),3) median(lira_tput(2,3,:),3) median(dot11_tput(2,:),2);
    median(lira_tput(3,1,:),3) median(lira_tput(3,2,:),3) median(lira_tput(3,3,:),3) median(dot11_tput(2,:),2);
    ];
bar(f)
grid on;
xlabel('NO. OF VLC CLIENTS');
ylabel('VLC Downlink Throughput (Mbps)');
legend(legend_pcc);
set(gca,'FontSize',24,'fontWeight','bold');
%set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
                                                                         

