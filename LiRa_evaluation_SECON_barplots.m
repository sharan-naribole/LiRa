clear all;
close all;
clc;

addpath('barrwitherr/');

%THIS program will be the comprehensive file on LiRa evaluation

%Figure 1
%ASMA's Radio Trigger Evaluation
load global_params.mat;

Nclients_max = 10;
Nlu_max = 4;
Ndistr = 20; %No. of distributions of VLC clients

cmu_colors = @cmu.colors;
symbols = ['v','o','x', 's'];

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
wifi_deg_lira = legacy_wifi_tput_deg;

%% PLOTS 
legend_clients = {'1 Client', '5 Clients', '10 Clients'};
legend_trigg= {'1 ms','5 ms','10 ms'};
legend_lu= {'1 Legacy user - 6 Mbps', '1 Legacy User - 18 Mbps', '1 Legacy User - 54 Mbps', '2 Legacy Users - 18 Mbps', '3 Legacy Users - 18 Mbps'};
legend_dt = {'Variable MCS', '1 Gbps', '10 Mbps'};
legend_wifi = {'Channel 1', 'Channel 14', 'Channel 48'};
legend_pcc = {'LiRa - 1 ms trigger', 'LiRa - 5 ms trigger', 'LiRa - 10 ms trigger' , '802.11 Per-Client Contention'};

 %% LiRa: Response Delay


% Plot 1: Clean Channel Delay
%Constants: 4 LU, 18 Mbps, Channel 48
%Bar graph
%-> X-axis: trigger times: 1, 4, 7, 10
%-> Y-axis: 1, 5, 10, 15 clients

wifi_chan = 1;
uplink_mcs = 1;

figure;
colormap inferno;
data = 0.001*[median(res_del_lira(1,1,:,1,wifi_chan,uplink_mcs)) median(res_del_lira(5,1,:,1,wifi_chan,uplink_mcs)) median(res_del_lira(10,1,:,1,wifi_chan,uplink_mcs));
    median(res_del_lira(1,1,:,2,wifi_chan,uplink_mcs)) median(res_del_lira(5,1,:,2,wifi_chan,uplink_mcs)) median(res_del_lira(10,1,:,2,wifi_chan,uplink_mcs));
    median(res_del_lira(1,1,:,3,wifi_chan,uplink_mcs)) median(res_del_lira(5,1,:,3,wifi_chan,uplink_mcs)) median(res_del_lira(10,1,:,3,wifi_chan,uplink_mcs))];
errors = 0.001*[std(res_del_lira(1,1,:,1,wifi_chan,uplink_mcs)) std(res_del_lira(5,1,:,1,wifi_chan,uplink_mcs)) std(res_del_lira(10,1,:,1,wifi_chan,uplink_mcs));
    std(res_del_lira(1,1,:,2,wifi_chan,uplink_mcs)) std(res_del_lira(5,1,:,2,wifi_chan,uplink_mcs)) std(res_del_lira(10,1,:,2,wifi_chan,uplink_mcs));
    std(res_del_lira(1,1,:,3,wifi_chan,uplink_mcs)) std(res_del_lira(5,1,:,3,wifi_chan,uplink_mcs)) std(res_del_lira(10,1,:,3,wifi_chan,uplink_mcs))];
barwitherr(errors,data);
grid on;
legend(legend_clients);
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('FEEDBACK TRIGGER TIME (ms)');
ylabel('RESPONSE DELAY (ms)');
set(gca,'xticklabel',{'1 ms','5 ms', ' 10 ms'});

% Plot 2: Congested Channel Delay

figure;
colormap inferno;
data = 0.001*[median(res_del_lira(1,1,:,2,1)) median(res_del_lira(1,1,:,2,2)) median(res_del_lira(1,1,:,2,3));
    median(res_del_lira(1,3,:,2,1)) median(res_del_lira(5,1,:,2,2)) median(res_del_lira(10,1,:,2,3))];
errors = 0.001*[std(res_del_lira(1,1,:,2,1)) std(res_del_lira(1,1,:,2,2)) std(res_del_lira(1,1,:,2,3));
    std(res_del_lira(1,3,:,2,1)) std(res_del_lira(5,1,:,2,2)) std(res_del_lira(10,1,:,2,3))];
barwitherr(errors,data);
grid on;
legend(legend_wifi);
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('NO. OF LEGACY Wi-Fi TRAFFIC FLOWS');
ylabel('RESPONSE DELAY (ms)');
set(gca,'xticklabel',{'1 FLOW','3 FLOWS'});


%% LiRa: Wi-Fi Degradation Bar Plots

% Plot 3: Clean Channel Degradation

wifi_chan = 1;
uplink_mcs = 1;

figure;
colormap inferno;
data = [median(wifi_deg_lira(1,1,:,1,wifi_chan,uplink_mcs)) median(wifi_deg_lira(5,1,:,1,wifi_chan,uplink_mcs)) median(wifi_deg_lira(10,1,:,1,wifi_chan,uplink_mcs));
    median(wifi_deg_lira(1,1,:,2,wifi_chan,uplink_mcs)) median(wifi_deg_lira(5,1,:,2,wifi_chan,uplink_mcs)) median(wifi_deg_lira(10,1,:,2,wifi_chan,uplink_mcs)); 
    median(wifi_deg_lira(1,1,:,3,wifi_chan,uplink_mcs)) median(wifi_deg_lira(5,1,:,3,wifi_chan,uplink_mcs)) median(wifi_deg_lira(10,1,:,3,wifi_chan,uplink_mcs))];
errors = [std(wifi_deg_lira(1,1,:,1,wifi_chan,uplink_mcs)) std(wifi_deg_lira(5,1,:,1,wifi_chan,uplink_mcs)) std(wifi_deg_lira(10,1,:,1,wifi_chan,uplink_mcs));
    std(wifi_deg_lira(1,1,:,2,wifi_chan,uplink_mcs)) std(wifi_deg_lira(5,1,:,2,wifi_chan,uplink_mcs)) std(wifi_deg_lira(10,1,:,2,wifi_chan,uplink_mcs)); 
    std(wifi_deg_lira(1,1,:,3,wifi_chan,uplink_mcs)) std(wifi_deg_lira(5,1,:,3,wifi_chan,uplink_mcs)) std(wifi_deg_lira(10,1,:,3,wifi_chan,uplink_mcs))];
barwitherr(errors,data);
grid on;
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
legend(legend_clients);
xlabel('FEEDBACK TRIGGER TIME (ms)');
ylabel('Wi-Fi DEGRADATION (%)');
set(gca,'xticklabel',{'1 ms','5 ms', ' 10 ms'});

% Plot 3: Congested Channel
figure;
colormap inferno;
data = [median(wifi_deg_lira(1,1,:,2,1,uplink_mcs)) median(wifi_deg_lira(1,1,:,2,2,uplink_mcs)) median(wifi_deg_lira(1,1,:,2,3,uplink_mcs));
    median(wifi_deg_lira(1,3,:,2,1,uplink_mcs)) median(wifi_deg_lira(5,1,:,2,2,uplink_mcs)) median(wifi_deg_lira(10,1,:,2,3,uplink_mcs))];
errors = [std(wifi_deg_lira(1,1,:,2,1,uplink_mcs)) std(wifi_deg_lira(1,1,:,2,2,uplink_mcs)) std(wifi_deg_lira(1,1,:,2,3,uplink_mcs));
    std(wifi_deg_lira(1,3,:,2,1,uplink_mcs)) std(wifi_deg_lira(5,1,:,2,2,uplink_mcs)) std(wifi_deg_lira(10,1,:,2,3,uplink_mcs))];
barwitherr(errors,data);
grid on;
legend(legend_wifi);
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('NO. OF LEGACY Wi-Fi TRAFFIC FLOWS');
ylabel('Wi-Fi DEGRADATION (%)');
set(gca,'xticklabel',{'1 FLOW','3 FLOWS'});

%% Baseline PCC 

%RESPONSE DELAY
figure;
colormap inferno;

data = 0.001*[mean(res_del_80211(1,:,1,1)) mean(res_del_80211(1,:,1,2)) mean(res_del_80211(1,:,1,3));
    mean(res_del_80211(2,:,1,1)) mean(res_del_80211(2,:,1,2)) mean(res_del_80211(2,:,1,3));
    mean(res_del_80211(3,:,1,1)) mean(res_del_80211(3,:,1,2)) mean(res_del_80211(3,:,1,3));
    mean(res_del_80211(4,:,1,1)) mean(res_del_80211(4,:,1,2)) mean(res_del_80211(4,:,1,3))];
    %mean(res_del_80211(5,:,1,1)) mean(res_del_80211(5,:,1,2)) mean(res_del_80211(5,:,1,3))];
errors = 0.001*[std(res_del_80211(1,:,1,1)) std(res_del_80211(1,:,1,2)) std(res_del_80211(1,:,1,3));
    std(res_del_80211(2,:,1,1)) std(res_del_80211(2,:,1,2)) std(res_del_80211(2,:,1,3));
    std(res_del_80211(3,:,1,1)) std(res_del_80211(3,:,1,2)) std(res_del_80211(3,:,1,3));
    std(res_del_80211(4,:,1,1)) std(res_del_80211(4,:,1,2)) std(res_del_80211(4,:,1,3))];
    %std(res_del_80211(5,:,1,1)) std(res_del_80211(5,:,1,2)) std(res_del_80211(5,:,1,3))];
barwitherr(errors,data);
grid on;
set(gca,'FontSize',24,'fontWeight','bold');
legend(legend_wifi);
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('NUMBER OF VLC USERS');
ylabel('RESPONSE DELAY (ms)');
set(gca,'xticklabel',{'1','2', '3','4'});

%% Wi-Fi Degradation
figure;
colormap inferno;

data = [mean(wifi_tput_deg_80211(1,:,1,1,uplink_mcs)) mean(wifi_tput_deg_80211(1,:,1,3,uplink_mcs));
       mean(wifi_tput_deg_80211(2,:,1,1,uplink_mcs)) mean(wifi_tput_deg_80211(2,:,1,3,uplink_mcs));
       mean(wifi_tput_deg_80211(3,:,1,1,uplink_mcs)) mean(wifi_tput_deg_80211(3,:,1,3,uplink_mcs));
       mean(wifi_tput_deg_80211(4,:,1,1,uplink_mcs)) mean(wifi_tput_deg_80211(4,:,1,3,uplink_mcs))];
       %mean(wifi_tput_deg_80211(5,:,1,1,uplink_mcs)) mean(wifi_tput_deg_80211(5,:,1,3,uplink_mcs))];
errors = [std(wifi_tput_deg_80211(1,:,1,1,uplink_mcs)) std(wifi_tput_deg_80211(1,:,1,3,uplink_mcs));
       std(wifi_tput_deg_80211(2,:,1,1,uplink_mcs)) std(wifi_tput_deg_80211(2,:,1,3,uplink_mcs));
       std(wifi_tput_deg_80211(3,:,1,1,uplink_mcs)) std(wifi_tput_deg_80211(3,:,1,3,uplink_mcs));
       std(wifi_tput_deg_80211(4,:,1,1,uplink_mcs)) std(wifi_tput_deg_80211(4,:,1,3,uplink_mcs))];
       %std(wifi_tput_deg_80211(5,:,1,1,uplink_mcs)) std(wifi_tput_deg_80211(5,:,1,3,uplink_mcs))];   
barwitherr(errors,data);
grid on;
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('NUMBER OF VLC USERS');
ylabel('Wi-Fi DEGRADATION (%)');
legend(legend_wifi(1:2));
set(gca,'xticklabel',{'1','2', '3','4'});

% Wi-Fi Degradation Comparison 
wifi_chan = 1;
uplink_mcs = 1;
figure;colormap inferno;
data = [median(wifi_deg_lira(1,1,:,1,wifi_chan,uplink_mcs)) median(wifi_deg_lira(1,1,:,2,wifi_chan,uplink_mcs)) median(wifi_deg_lira(1,1,:,2,wifi_chan,uplink_mcs)) median(wifi_tput_deg_80211(1,:,1, wifi_chan,uplink_mcs));
    median(wifi_deg_lira(2,1,:,1,wifi_chan,uplink_mcs)) median(wifi_deg_lira(2,1,:,2,wifi_chan,uplink_mcs)) median(wifi_deg_lira(2,1,:,3,wifi_chan,uplink_mcs)) median(wifi_tput_deg_80211(2,:,1,wifi_chan,uplink_mcs));
    median(wifi_deg_lira(3,1,:,1,wifi_chan,uplink_mcs)) median(wifi_deg_lira(3,1,:,2,wifi_chan,uplink_mcs)) median(wifi_deg_lira(3,1,:,3,wifi_chan,uplink_mcs)) median(wifi_tput_deg_80211(3,:,1,wifi_chan,uplink_mcs));
    median(wifi_deg_lira(4,1,:,1,wifi_chan,uplink_mcs)) median(wifi_deg_lira(4,1,:,2,wifi_chan,uplink_mcs)) median(wifi_deg_lira(4,1,:,3,wifi_chan,uplink_mcs)) median(wifi_tput_deg_80211(4,:,1,wifi_chan,uplink_mcs))];
    %median(wifi_deg_lira(5,1,:,1,wifi_chan,uplink_mcs)) median(wifi_deg_lira(5,1,:,2,wifi_chan,uplink_mcs)) median(wifi_deg_lira(5,1,:,3,wifi_chan,uplink_mcs)) median(wifi_tput_deg_80211(5,:,1,wifi_chan,uplink_mcs))];
errors = [std(wifi_deg_lira(1,1,:,1,wifi_chan,uplink_mcs)) std(wifi_deg_lira(1,1,:,2,wifi_chan,uplink_mcs)) std(wifi_deg_lira(1,1,:,2,wifi_chan,uplink_mcs)) std(wifi_tput_deg_80211(1,:,1, wifi_chan,uplink_mcs)); 
    std(wifi_deg_lira(2,1,:,1,wifi_chan,uplink_mcs)) std(wifi_deg_lira(2,1,:,2,wifi_chan,uplink_mcs)) std(wifi_deg_lira(2,1,:,3,wifi_chan,uplink_mcs)) std(wifi_tput_deg_80211(2,:,1,wifi_chan,uplink_mcs)); 
    std(wifi_deg_lira(3,1,:,1,wifi_chan,uplink_mcs)) std(wifi_deg_lira(3,1,:,2,wifi_chan,uplink_mcs)) std(wifi_deg_lira(3,1,:,3,wifi_chan,uplink_mcs)) std(wifi_tput_deg_80211(3,:,1,wifi_chan,uplink_mcs));
    std(wifi_deg_lira(4,1,:,1,wifi_chan,uplink_mcs)) std(wifi_deg_lira(4,1,:,2,wifi_chan,uplink_mcs)) std(wifi_deg_lira(4,1,:,3,wifi_chan,uplink_mcs)) std(wifi_tput_deg_80211(4,:,1,wifi_chan,uplink_mcs))]; 
    %std(wifi_deg_lira(5,1,:,1,wifi_chan,uplink_mcs)) std(wifi_deg_lira(5,1,:,2,wifi_chan,uplink_mcs)) std(wifi_deg_lira(5,1,:,3,wifi_chan,uplink_mcs)) std(wifi_tput_deg_80211(5,:,1,wifi_chan,uplink_mcs))];
grid on;
barwitherr(errors,data);
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('NUMBER OF VLC USERS');
ylabel('Wi-Fi DEGRADATION (%)');
legend(legend_pcc);
set(gca,'xticklabel',{'1','2', '3','4'});