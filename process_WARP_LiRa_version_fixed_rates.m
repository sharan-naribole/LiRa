clear all;
%close all;
clc;

%THIS WILL THE FUNDAMENTAL CODE FOR OUTPUTTING LIRA'S PERFORMANCE METRICS

%Loading key files
initialize;

Nclients_max = 10;
Nlu_max = 2;
Ndistr = 1; %No. of distributions of VLC clients


uplink_mcs = [6 18 54];
uplink_mcs_id = [1 3 7];
wifi_chan = [1 14 48];
trigger_times = [1 5 10]*1e3;% in microseconds
Ntrigger_time = max(size(trigger_times));%1 ms, 5 ms, 10 ms
Nwifi_chan = max(size(wifi_chan));
Nuplink_mcs = max(size(uplink_mcs));

payload_res = zeros(Ntrigger_time,Nclients_max,Ndistr); 
client_loc = ceil(Nlocs*rand(Nclients_max,Ndistr));
client_or = ceil(Nors*rand(Nclients_max,Ndistr));
client_rates = zeros(Nclients_max,Ndistr);

response_delay = NaN(Nclients_max,Nlu_max,Ndistr,Ntrigger_time,Nwifi_chan,Nuplink_mcs,4);
legacy_wifi_tput_deg = NaN(Nclients_max,Nlu_max,Ndistr,Ntrigger_time,Nwifi_chan,Nuplink_mcs);

for distr = 1:1:Ndistr  
    distr
    %Data Rate for each client in each distribution
    for n=1:1:Nclients_max
        rx_pow = P_RX_min + 10*log10(process_mean_data(client_loc(n,distr),client_or(n,distr))/min(process_mean_data(:)));
        client_rates(n,distr) = 1000;%DataRate(rx_pow);
    end
end

for n_lu = 1:1:Nlu_max    
    path = ['WARP_MEASURES/RAW_DATA/LiRa_LU_' num2str(n_lu) '_NIGHT/']
    
    %Client Size Loop
    for n=1:1:Nclients_max
        n
        for trigg = 1:1:Ntrigger_time      
            TRIGGER_TIME = trigger_times(trigg)

            payload_off = (28 + payload_measures(10*(trigg-1) + 1))*8/CCrate;

            %Payload_computation - but do I really need this now?
            %payload_tmp = payload(squeeze(client_rates(1:n,distr)),trigger_times(trigg));
            %payload_res(trigg,n,distr) = payload_tmp;

            % Wi-Fi Channel Loop
            for chan_iter = 1:1:Nwifi_chan
                CHANNEL = wifi_chan(chan_iter)

                %Uplink MCS Loop
                for uplink_mcs_iter = 1:1:Nuplink_mcs

                    UPLINK_MCS = uplink_mcs(uplink_mcs_iter)
                    UPLINK_MCS_ID = uplink_mcs_id(uplink_mcs_iter);
                    %Actual Experiment begins here for 30 seconds

                    %Response Delay Calculation
                    filename = [path 'MAT_Files/LiRa_AP_TRIGG_' num2str(TRIGGER_TIME)  '_VLCU_' num2str(10*(trigg-1) + n) '_UMCS_'  num2str(UPLINK_MCS_ID)  '_CH_'  num2str(CHANNEL) '_tx_done.mat'];
                    if(exist(filename,'file') == 2)
                        load(filename);
                    else
                        continue;
                    end

                    %Client Location and Orientation distribution loop
                    for distr = 1:1:Ndistr  
                        [res_del_vec, wifi_tput_deg] = compute_metrics_LiRa(client_rates(1:n),TRIGGER_TIME, tx_done,payload_off);
                        response_delay(n,n_lu,distr,trigg,chan_iter,uplink_mcs_iter,1) = mean(res_del_vec);
                        response_delay(n,n_lu,distr,trigg,chan_iter,uplink_mcs_iter,2) = std(res_del_vec);
                        response_delay(n,n_lu,distr,trigg,chan_iter,uplink_mcs_iter,3) = median(res_del_vec);
                        response_delay(n,n_lu,distr,trigg,chan_iter,uplink_mcs_iter,4) = mad(res_del_vec,1);
                        legacy_wifi_tput_deg(n,n_lu,distr,trigg,chan_iter,uplink_mcs_iter) = wifi_tput_deg;
                    end    
                end
            end
        end
        save(['WARP_MEASURES/FORMATTED_DATA/LiRa_NIGHT_Nclients_' num2str(n) '_LU_' num2str(n_lu) '_1Gbps_performance_metrics.mat'], 'response_delay', 'legacy_wifi_tput_deg');

    end  
end

