close all;
clear all;
clc;

load global_params.mat;

Nclients_max = 5;
Nlu_max = 4;

uplink_mcs = [18];
uplink_mcs_id = [3];
wifi_chan = [1,14,48];
Nwifi_chan = max(size(wifi_chan));
Nuplink_mcs = max(size(uplink_mcs));




% PCC Comparison - WiFi Channel Analysis
wifi_chan = 3;
uplink_mcs = 2;
figure;
colormap inferno;
 ppp = [median(wifi_tput_deg_80211(1,:,1,uplink_mcs),2) median(wifi_tput_deg_80211(1,:,2,uplink_mcs),2) median(wifi_tput_deg_80211(1,:,3,uplink_mcs),2);
    median(wifi_tput_deg_80211(2,:,1,uplink_mcs),2) median(wifi_tput_deg_80211(2,:,2,uplink_mcs),2) median(wifi_tput_deg_80211(2,:,3,uplink_mcs),2);
    mean(wifi_tput_deg_80211(3,:,1,uplink_mcs),2) median(wifi_tput_deg_80211(3,:,2,uplink_mcs),2) median(wifi_tput_deg_80211(3,:,3,uplink_mcs),2);
    median(wifi_tput_deg_80211(4,:,1,uplink_mcs),2) median(wifi_tput_deg_80211(4,:,2,uplink_mcs),2) median(wifi_tput_deg_80211(4,:,3,uplink_mcs),2);
    ];
bar(ppp)
grid on;
xlabel('NO. OF VLC CLIENTS');
ylabel('WIFI THROUGHPUT DEGRADATION (%)');
legend(legend_wifi);
set(gca,'FontSize',24,'fontWeight','bold');
set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
                                                                    

figure;
colormap inferno;
ddd = 0.001*[median(res_del_80211(1,:,1,uplink_mcs,1),2) median(res_del_80211(1,:,2,uplink_mcs,1),2) median(res_del_80211(1,:,3,uplink_mcs,1),2); 
    median(res_del_80211(2,:,1,uplink_mcs,1),2) median(res_del_80211(2,:,2,uplink_mcs,1),2) median(res_del_80211(2,:,3,uplink_mcs,1),2);
    median(res_del_80211(3,:,1,uplink_mcs,1),2) median(res_del_80211(3,:,2,uplink_mcs,1),2) median(res_del_80211(3,:,3,uplink_mcs,1),2);
    median(res_del_80211(4,:,1,uplink_mcs,1),2) median(res_del_80211(4,:,2,uplink_mcs,1),2) median(res_del_80211(4,:,3,uplink_mcs,1),2);
    ];
bar(ddd)

grid on;
xlabel('NO. OF VLC CLIENTS');
ylabel('RESPONSE DELAY (ms)');
legend(legend_wifi);
set(gca,'FontSize',24,'fontWeight','bold');
%set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');