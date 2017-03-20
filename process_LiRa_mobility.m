clear all;
%close all;
clc;

%THIS WILL THE FUNDAMENTAL CODE FOR OUTPUTTING LIRA'S PERFORMANCE METRICS

%Loading key files
initialize;
load LED_measures.mat;
load WARP_MEASURES\FINAL_ROUND_TRIGGER_XAXIS\FORMATTED_DATA\80211_LU_ONLY_xput_payload_100.mat;
load mobility_distributions.mat;

Nclients_max = 4;
Nlu_max = 1;
Ndistr = 50; %No. of distributions of VLC clients

total_time = 10000;

uplink_mcs = [18];
uplink_mcs_id = [3];
wifi_chan = [48];
trigger_times = [1,4,7]*1e3;% in microseconds
Ntrigger_time = max(size(trigger_times));%1 ms, 5 ms, 10 ms
Nwifi_chan = max(size(wifi_chan));
Nuplink_mcs = max(size(uplink_mcs));

throughput = NaN(Nclients_max,Ntrigger_time,Ndistr);
payload_length = 100;
payload_off = (28 + payload_length)*8/CCrate;

path = 'WARP_MEASURES/FINAL_ROUND_TRIGGER_XAXIS/RAW_DATA/LiRa_LU_1/';

for n=1:1:Nclients_max
    n
    for trigg = 1:1:Ntrigger_time
        TRIGGER_TIME = trigger_times(trigg)
        
        %Downlink Throughput Calculation
        filename = [path 'MAT_Files/AP_LiRa_LU_1_TRIGG_' num2str(TRIGGER_TIME)  '_UMCS_3_CH_48_tx_done.mat'];
        load(filename);
        
        %Client Location and Orientation distribution loop
        for distr = 1:1:Ndistr  
            distr
            [throughput_curr] = compute_throughput_LiRa_mobility(squeeze(rx_pow(1:n,:,distr)),TRIGGER_TIME,squeeze(bulb_alloc_ideal(1:n,:,distr)),squeeze(data_rate_ideal(1:n,:,distr)),tx_done, payload_off, total_time);
            throughput(n,trigg,distr) = throughput_curr;
        end            
    end
    save(['WARP_MEASURES/CORRECT_RESULTS/FORMATTED_DATA/LiRa_Nclients_' num2str(n)  '_mobility_throughput.mat'], 'throughput','rx_pow','data_rate_ideal','bulb_alloc_ideal');
end

clear;
clc;
