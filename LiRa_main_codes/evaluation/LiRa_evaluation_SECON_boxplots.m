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
legend_clients = {'1 Client', '5 Clients', '10 Clients', '15 Clients'};
legend_trigg= {'1 ms','5 ms','10 ms'};
legend_lu= {'1 Legacy user - 6 Mbps', '1 Legacy User - 18 Mbps', '1 Legacy User - 54 Mbps', '2 Legacy Users - 18 Mbps', '3 Legacy Users - 18 Mbps'};
legend_dt = {'Variable MCS', '1 Gbps', '10 Mbps'};
legend_wifi = {'Channel 1', 'Channel 14', 'Channel 48'};
legend_pcc = {'LiRa - 1 ms trigger', 'LiRa - 4 ms trigger', 'LiRa - 7 ms trigger' , '802.11 Per-Client Contention'};

 %% LiRa: Response Delay


% Plot 1: Clean Channel Delay
%Constants: 4 LU, 18 Mbps, Channel 48
%Bar graph
%-> X-axis: trigger times: 1, 4, 7, 10
%-> Y-axis: 1, 5, 10, 15 clients

wifi_chan = 1;
uplink_mcs = 1;

figure;
data = 0.001*[squeeze(res_del_lira(1,1,:,1,wifi_chan,uplink_mcs)); squeeze(res_del_lira(5,1,:,1,wifi_chan,uplink_mcs)); squeeze(res_del_lira(10,1,:,1,wifi_chan,uplink_mcs));
    squeeze(res_del_lira(1,1,:,2,wifi_chan,uplink_mcs)); squeeze(res_del_lira(5,1,:,2,wifi_chan,uplink_mcs)); squeeze(res_del_lira(10,1,:,2,wifi_chan,uplink_mcs)); ...
    squeeze(res_del_lira(1,1,:,3,wifi_chan,uplink_mcs)); squeeze(res_del_lira(5,1,:,3,wifi_chan,uplink_mcs)); squeeze(res_del_lira(10,1,:,3,wifi_chan,uplink_mcs))];
grouping = [ones(1,Ndistr), 2*ones(1,Ndistr), 3*ones(1,Ndistr), 4*ones(1,Ndistr), 5*ones(1,Ndistr), 6*ones(1,Ndistr), 7*ones(1,Ndistr), 8*ones(1,Ndistr), 9*ones(1,Ndistr)]';
positions = [1 1.25 1.5 2 2.25 2.5 3 3.25 3.5];
boxplot(data,grouping,'positions',positions);
grid on;
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('FEEDBACK TRIGGER TIME (ms)');
ylabel('RESPONSE DELAY (ms)');
set(gca,'xtick',[mean(positions(1:3)) mean(positions(4:6)) mean(positions(7:9))]);
set(gca,'xticklabel',{'1 ms','5 ms', ' 10 ms'});

%color = ['c','k','y'];
colorss = [cmu_colors('dark brown'); cmu_colors('sunglow'); cmu_colors('pearl')]';
color_set = repmat(colorss,1,3);
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   p = patch(get(h(j),'XData'),get(h(j),'YData'),[color_set(1,j) color_set(2,j) color_set(3,j)], 'FaceAlpha',0.95);
   p.LineWidth = 3;
   p.MarkerSize = 20;
   p.Marker = symbols(3 - mod(j,3));
   %p.FaceColor = [color(j,1) color(j,2) color(j,3)];
end

c = get(gca, 'Children');
hleg1 = legend(c(1:3), '1 CLIENT', '5 CLIENTS', '10 CLIENTS', 'Location','northwest');
%print(gcf, '-dpdf', '80211_res_del_SECON.pdf');
clear c; clear h, clear hleg1, clear colorss;

'DONE'

% Plot 2: Congested Channel Delay
figure;
data = 0.001*[squeeze(res_del_lira(1,1,:,2,1)); squeeze(res_del_lira(1,1,:,2,2)); squeeze(res_del_lira(1,1,:,2,3)); ...
    squeeze(res_del_lira(1,3,:,2,1)); squeeze(res_del_lira(5,1,:,2,2)); squeeze(res_del_lira(10,1,:,2,3))];
grouping = [ones(1,Ndistr), 2*ones(1,Ndistr), 3*ones(1,Ndistr), 4*ones(1,Ndistr), 5*ones(1,Ndistr), 6*ones(1,Ndistr)]';
positions = [1 1.25 1.5 2 2.25 2.5];
boxplot(data,grouping,'positions',positions);
grid on;
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('NO. OF LEGACY Wi-Fi TRAFFIC FLOWS');
ylabel('RESPONSE DELAY (ms)');
set(gca,'xtick',[mean(positions(1:3)) mean(positions(4:6))]);
set(gca,'xticklabel',{'1 FLOW','3 FLOWS'});

%color = ['c','k','y'];
colorss = [cmu_colors('dark brown'); cmu_colors('sunglow'); cmu_colors('pearl')]';
color_set = repmat(colorss,1,2);
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   p = patch(get(h(j),'XData'),get(h(j),'YData'),[color_set(1,j) color_set(2,j) color_set(3,j)],'FaceAlpha',0.95);
   p.LineWidth = 3;
   p.MarkerSize = 20;
   p.Marker = symbols(3 - mod(j,3));
end

c = get(gca, 'Children');
hleg1 = legend(c(1:3),'CHANNEL 1', 'CHANNEL 14', 'CHANNEL 48', 'Location','northwest');


%% LiRa: Wi-Fi Degradation Box Plots

% Plot 1: Clean Channel Degradation

wifi_chan = 1;
uplink_mcs = 1;

figure;
data = [squeeze(wifi_deg_lira(1,1,:,1,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(5,1,:,1,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(10,1,:,1,wifi_chan,uplink_mcs)); ...
    squeeze(wifi_deg_lira(1,1,:,2,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(5,1,:,2,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(10,1,:,2,wifi_chan,uplink_mcs)); ...
    squeeze(wifi_deg_lira(1,1,:,3,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(5,1,:,3,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(10,1,:,3,wifi_chan,uplink_mcs))];
grouping = [ones(1,Ndistr), 2*ones(1,Ndistr), 3*ones(1,Ndistr), 4*ones(1,Ndistr), 5*ones(1,Ndistr), 6*ones(1,Ndistr), 7*ones(1,Ndistr), 8*ones(1,Ndistr), 9*ones(1,Ndistr)]';
positions = [1 1.25 1.5 2 2.25 2.5 3 3.25 3.5];
boxplot(data,grouping,'positions',positions);
grid on;
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('FEEDBACK TRIGGER TIME (ms)');
ylabel('Wi-Fi Degradation (%)');
set(gca,'xtick',[mean(positions(1:3)) mean(positions(4:6)) mean(positions(7:9))]);
set(gca,'xticklabel',{'1 ms','5 ms', ' 10 ms'});

%color = ['c','k','y'];
colorss = [cmu_colors('dark brown'); cmu_colors('sunglow'); cmu_colors('pearl')]';
color_set = repmat(colorss,1,3);
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   p = patch(get(h(j),'XData'),get(h(j),'YData'),[color_set(1,j) color_set(2,j) color_set(3,j)], 'FaceAlpha',0.95);
   p.LineWidth = 3;
   p.MarkerSize = 20;
   p.Marker = symbols(3 - mod(j,3));
   %p.FaceColor = [color(j,1) color(j,2) color(j,3)];
end

c = get(gca, 'Children');
hleg1 = legend(c(1:3), '1 CLIENT', '5 CLIENTS', '10 CLIENTS', 'Location','northeast');
%print(gcf, '-dpdf', '80211_res_del_SECON.pdf');
clear c; clear h, clear hleg1, clear colorss;

% % Plot 2: Congested Channel Degradation
figure;
data = [squeeze(wifi_deg_lira(1,1,:,2,1,uplink_mcs)); squeeze(wifi_deg_lira(1,1,:,2,2,uplink_mcs)); squeeze(wifi_deg_lira(1,1,:,2,3,uplink_mcs)); ...
    squeeze(wifi_deg_lira(1,3,:,2,1,uplink_mcs)); squeeze(wifi_deg_lira(5,1,:,2,2,uplink_mcs)); squeeze(wifi_deg_lira(10,1,:,2,3,uplink_mcs))];
grouping = [ones(1,Ndistr), 2*ones(1,Ndistr), 3*ones(1,Ndistr), 4*ones(1,Ndistr), 5*ones(1,Ndistr), 6*ones(1,Ndistr)]';
positions = [1 1.25 1.5 2 2.25 2.5];
boxplot(data,grouping,'positions',positions,'notch','on');
grid on;
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('NO. OF LEGACY Wi-Fi TRAFFIC FLOWS');
ylabel('Wi-Fi Degradation (%)');
set(gca,'xtick',[mean(positions(1:3)) mean(positions(4:6))]);
set(gca,'xticklabel',{'1 FLOW','3 FLOWS'});

%color = ['c','k','y'];
colorss = [cmu_colors('dark brown'); cmu_colors('sunglow'); cmu_colors('pearl')]';
color_set = repmat(colorss,1,2);
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   p = patch(get(h(j),'XData'),get(h(j),'YData'),[color_set(1,j) color_set(2,j) color_set(3,j)],'FaceAlpha',0.95);
   p.LineWidth = 3;
   p.MarkerSize = 20;
   p.Marker = symbols(3 - mod(j,3));
end

c = get(gca, 'Children');
hleg1 = legend(c(1:3),'CHANNEL 1', 'CHANNEL 14', 'CHANNEL 48', 'Location','northeast');

%% Baseline PCC 

%RESPONSE DELAY
figure;
data = 0.001*[res_del_80211(1,:,1,1), res_del_80211(1,:,1,2), res_del_80211(1,:,1,3), ...
    res_del_80211(2,:,1,1), res_del_80211(2,:,1,2), res_del_80211(2,:,1,3), ...
    res_del_80211(3,:,1,1), res_del_80211(3,:,1,2), res_del_80211(3,:,1,3), ...
    res_del_80211(4,:,1,1), res_del_80211(4,:,1,2), res_del_80211(4,:,1,3), ...
    res_del_80211(5,:,1,1), res_del_80211(5,:,1,2), res_del_80211(5,:,1,3)];
grouping = [ones(1,Ndistr), 2*ones(1,Ndistr), 3*ones(1,Ndistr), 4*ones(1,Ndistr), 5*ones(1,Ndistr), 6*ones(1,Ndistr), 7*ones(1,Ndistr), 8*ones(1,Ndistr), 9*ones(1,Ndistr), 10*ones(1,Ndistr) 11*ones(1,Ndistr), 12*ones(1,Ndistr), 13*ones(1,Ndistr), 14*ones(1,Ndistr), 15*ones(1,Ndistr)];
positions = [1 1.25 1.5 2 2.25 2.5 3 3.25 3.5 4 4.25 4.5 5 5.25 5.5];
boxplot(data,grouping,'positions',positions);
grid on;
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('NUMBER OF VLC USERS');
ylabel('RESPONSE DELAY (ms)');
set(gca,'xtick',[mean(positions(1:3)) mean(positions(4:6)) mean(positions(7:9)) mean(positions(10:12)) mean(positions(13:15))]);
set(gca,'xticklabel',{'1','2', '3','4','5'});

colorss = [cmu_colors('dark brown'); cmu_colors('sunglow'); cmu_colors('pearl')]';
color_set = repmat(colorss,1,5);
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   p = patch(get(h(j),'XData'),get(h(j),'YData'),[color_set(1,j) color_set(2,j) color_set(3,j)],'FaceAlpha',0.95);
   p.LineWidth = 3;
   p.MarkerSize = 20;
   p.Marker = symbols(3 - mod(j,3));
end

c = get(gca, 'Children');
hleg1 = legend(c(1:3), 'CHANNEL 1 - 2.4 GHz', 'CHANNEL 14 - 2.4 GHz', 'CHANNEL 48 -  5 GHz', 'Location','northwest');
%print(gcf, '-dpdf', '80211_res_del_SECON.pdf'); 

'done'

%Wi-Fi Degradation

figure;
data = [wifi_tput_deg_80211(1,:,1,1,uplink_mcs), wifi_tput_deg_80211(1,:,1,3,uplink_mcs), wifi_tput_deg_80211(2,:,1,1,uplink_mcs), wifi_tput_deg_80211(2,:,1,3,uplink_mcs), wifi_tput_deg_80211(3,:,1,1,uplink_mcs), wifi_tput_deg_80211(3,:,1,3,uplink_mcs), wifi_tput_deg_80211(4,:,1,1,uplink_mcs), wifi_tput_deg_80211(4,:,1,3,uplink_mcs), wifi_tput_deg_80211(5,:,1,1,uplink_mcs), wifi_tput_deg_80211(5,:,1,3,uplink_mcs)];
grouping = [ones(1,Ndistr), 2*ones(1,Ndistr), 3*ones(1,Ndistr), 4*ones(1,Ndistr), 5*ones(1,Ndistr), 6*ones(1,Ndistr), 7*ones(1,Ndistr), 8*ones(1,Ndistr), 9*ones(1,Ndistr), 10*ones(1,Ndistr)];
positions = [1 1.25 2 2.25 3 3.25 4 4.25 5 5.25];
boxplot(data,grouping,'positions',positions);
grid on;
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('NUMBER OF VLC USERS');
ylabel('Wi-Fi DEGRADATION (%)');
set(gca,'xtick',[mean(positions(1:2)) mean(positions(3:4)) mean(positions(5:6)) mean(positions(7:8)) mean(positions(9:10))]);
set(gca,'xticklabel',{'1','2', '3','4','5'});

colorss = [cmu_colors('dark brown'); cmu_colors('pearl')]';
color_set = repmat(colorss,1,5);
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   p = patch(get(h(j),'XData'),get(h(j),'YData'),[color_set(1,j) color_set(2,j) color_set(3,j)],'FaceAlpha',0.95);
   p.LineWidth = 3;
   p.MarkerSize = 20;
   p.Marker = symbols(2 - mod(j,2));
end

c = get(gca, 'Children');
hleg1 = legend(c(1:2), 'CHANNEL 1 - 2.4 GHz','CHANNEL 48 -  5 GHz', 'Location','northwest');
%print(gcf, '-dpdf', '80211_wifi_deg_SECON.pdf');


%% Wi-Fi Degradation Comparison 
wifi_chan = 1;
uplink_mcs = 1;
figure;
data = [squeeze(wifi_deg_lira(1,1,:,1,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(1,1,:,2,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(1,1,:,2,wifi_chan,uplink_mcs)); squeeze(wifi_tput_deg_80211(1,:,1, wifi_chan,uplink_mcs))';  ...
    squeeze(wifi_deg_lira(2,1,:,1,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(2,1,:,2,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(2,1,:,3,wifi_chan,uplink_mcs)); squeeze(wifi_tput_deg_80211(2,:,1,wifi_chan,uplink_mcs))'; ...
    squeeze(wifi_deg_lira(3,1,:,1,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(3,1,:,2,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(3,1,:,3,wifi_chan,uplink_mcs)); squeeze(wifi_tput_deg_80211(3,:,1,wifi_chan,uplink_mcs))'; ...
    squeeze(wifi_deg_lira(4,1,:,1,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(4,1,:,2,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(4,1,:,3,wifi_chan,uplink_mcs)); squeeze(wifi_tput_deg_80211(4,:,1,wifi_chan,uplink_mcs))'; ...
    squeeze(wifi_deg_lira(5,1,:,1,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(5,1,:,2,wifi_chan,uplink_mcs)); squeeze(wifi_deg_lira(5,1,:,3,wifi_chan,uplink_mcs)); squeeze(wifi_tput_deg_80211(5,:,1,wifi_chan,uplink_mcs))']';
grouping = ones(1,length(data));
for k=1:1:ceil(length(data)/Ndistr)
    start = (k-1)*Ndistr + 1;
    fin = k*Ndistr;
    grouping(start:fin) = k;
end
grouping = grouping(1:length(data));
positions = [1 1.2 1.4 1.6 2.6 2.8 3.0 3.2 4.2 4.4 4.6 4.8 5.8 6.0 6.2 6.4 7.4 7.6 7.8 8.0];
boxplot(data,grouping,'positions',positions);
grid on;
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
xlabel('NUMBER OF VLC USERS');
ylabel('Wi-Fi DEGRADATION (%)');
set(gca,'xtick',[mean(positions(1:4)) mean(positions(5:8)) mean(positions(9:12)) mean(positions(13:16)) mean(positions(17:20))]);
set(gca,'xticklabel',{'1','2', '3','4','5'});

colorss = [cmu_colors('sunglow');cmu_colors('dark brown'); cmu_colors('pearl'); cmu_colors('bondi blue')]';
color_set = repmat(colorss,1,5);
h = findobj(gca,'Tag','Box');
for j=1:length(h)
   p = patch(get(h(j),'XData'),get(h(j),'YData'),[color_set(1,j) color_set(2,j) color_set(3,j)],'FaceAlpha',0.95);
   p.LineWidth = 3;
   p.MarkerSize = 20;
   p.Marker = symbols(4 - mod(j,4));
end

c = get(gca, 'Children');
hleg1 = legend(c(1:4), 'LiRa ASMA - 1 ms Trigger','LiRa ASMA - 5 ms Trigger', 'LiRa ASMA - 10 ms Trigger', 'Per-Client Contention','Location','northwest');

