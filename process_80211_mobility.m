clear all;
%close all;
clc;

%THIS WILL THE FUNDAMENTAL CODE FOR OUTPUTTING LIRA'S PERFORMANCE METRICS

%Loading key files
initialize;
load LED_measures.mat;
load WARP_MEASURES\FINAL_ROUND_TRIGGER_XAXIS\FORMATTED_DATA\80211_LU_ONLY_xput_payload_100.mat;
load mobility_distributions.mat;

Nclients_max = 3;
Nlu_max = 1;
Ndistr = 50; %No. of distributions of VLC clients

total_time = 10000;

uplink_mcs = [18];
uplink_mcs_id = [3];
wifi_chan = [48];
Nwifi_chan = max(size(wifi_chan));
Nuplink_mcs = max(size(uplink_mcs));

throughput = NaN(Nclients_max,Ndistr);
payload_length = 100;
payload_off = (28 + payload_length)*8/CCrate;

path = 'WARP_MEASURES/FINAL_ROUND_TRIGGER_XAXIS/RAW_DATA/80211_LU_';
tx_done_cum = [];

for n=1:1:Nclients_max
    n
    %tx_done_cum = NaN(1,n);
    
    for n_vlc = 1:1:n
        %
        filename = [path num2str(n+1) '/MAT_FILES/LegacyUser' num2str(n_vlc+1) '_80211_LU_' num2str(n+1) '_UMCS_3_CH_48_tx_done.mat'];
        load(filename);

        tx_done_cum(n_vlc).tx_done = tx_done;
    end
    
    for distr = 1:1:Ndistr  
        distr
        [throughput_curr] = compute_throughput_80211_mobility(squeeze(rx_pow(1:n,:,distr)),squeeze(bulb_alloc_ideal(1:n,:,distr)),squeeze(data_rate_ideal(1:n,:,distr)),tx_done_cum, payload_off, total_time);
        throughput(n,distr) = throughput_curr;
    end
    save(['WARP_MEASURES/CORRECT_RESULTS/FORMATTED_DATA/80211_Nclients_' num2str(n)  '_mobility_throughput.mat'], 'throughput','rx_pow','data_rate_ideal','bulb_alloc_ideal');
end

