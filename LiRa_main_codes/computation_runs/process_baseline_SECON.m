clear all;
close all;
clc;

%THIS WILL THE FUNDAMENTAL CODE FOR OUTPUTTING LIRA'S PERFORMANCE METRICS

%Loading key files
load global_params.mat;
load LED_measures.mat;
load WARP_PROCESSED_DATA/80211_LU_ONLY_xput.mat;

Nvlc_max = 5;
Nwifi_chan = 3;
Nuplink_mcs = 1;
N_wp = 1; %waiting periods
n_lu = 1;
Nreruns = 20

uplink_mcs = [18];
uplink_mcs_id = [3];
wifi_chan = [1,14,48];
waiting_periods = [0];

legacy_wifi_tput_deg_ota = NaN(Nvlc_max,Nreruns,N_wp,Nwifi_chan,Nuplink_mcs);
response_delay = NaN(Nvlc_max,Nreruns,N_wp,Nwifi_chan,Nuplink_mcs);

payload_off = 100*8/CCrate;

%Data Rate for each client in each distribution
for n=1:1:Nvlc_max
    %rx_pow = P_RX_min + 10*log10(process_mean_data(client_loc(n,distr),client_or(n,distr))/min(process_mean_data(:)));
    client_rates(n) = max(rates);%DataRate(rx_pow);
end 

for n_vlc=1:1:Nvlc_max
    path = ['WARP_MEASURES_SECON_2017/FINAL_ROUND/80211_VLC_' num2str(n_vlc) '/MAT_FILES/'];
    
% Wi-Fi Channel Loop
    for chan_iter = 1:1:Nwifi_chan
        CHANNEL = wifi_chan(chan_iter)

        %Uplink MCS Loop
        for uplink_mcs_iter = 1:1:Nuplink_mcs

            UPLINK_MCS = uplink_mcs(uplink_mcs_iter);
            UPLINK_MCS_ID = uplink_mcs_id(uplink_mcs_iter);
            %Actual Experiment begins here for 30 seconds

            wifi_only_tput = legacy_only_tput(n_lu,chan_iter,uplink_mcs_iter);

            
            %Client Location and Orientation distribution loop
            for wp = 1:1:N_wp
                WAITING_PERIOD = waiting_periods(wp)
                wifi_ratio_cum = NaN(Nreruns,1);
              
                for rerun=1:1:Nreruns
                    %Finding the legacy Wi-Fi throughput degradation
                    
                    res_del_vec_cum = [];
                    
                    kk = n_vlc;
                    if(n_vlc== Nvlc_max)
                        kk = kk -1;
                    end
                    filename = [path '80211_LU_1_VLC_' num2str(kk) '_WP_' num2str(WAITING_PERIOD) '_UMCS_' num2str(UPLINK_MCS_ID) '_CH_' num2str(CHANNEL) '_RERUN_' num2str(rerun-1) '_legacy_user1_tput.mat'];
                    load(filename);
                    tput_curr = eval(['LegacyUser1_xput']);
                    wifi_ratio_initial = tput_curr/wifi_only_tput;
                    wifi_ratio_cum = min(1,wifi_ratio_initial);
                    wifi_deg_sum = 0;
                   
                    for n_l = 1:1:n_vlc
                        %Response Delay Calculation
                        filename = [path 'VlcClient' num2str(n_l) '_80211_LU_1_VLC_' num2str(n_vlc) '_WP_' num2str(WAITING_PERIOD) '_UMCS_' num2str(UPLINK_MCS_ID) '_CH_' num2str(CHANNEL) '_RERUN_' num2str(rerun-1) '_tx_done.mat'];
                        load(filename);

                        filename = [path 'VlcClient' num2str(n_l) '_80211_LU_1_VLC_' num2str(n_vlc) '_WP_' num2str(WAITING_PERIOD) '_UMCS_' num2str(UPLINK_MCS_ID) '_CH_' num2str(CHANNEL) '_RERUN_' num2str(rerun-1)  '_num_tx.mat'];
                        load(filename);

                        [res_del_vec, wifi_deg_curr,deg_extra_curr] = compute_metrics_80211_single_client(client_rates(n_l),tx_done,num_tx,payload_off);

                        res_del_vec_cum = [res_del_vec_cum(:); res_del_vec(:)];
                        
                        wifi_deg_sum = wifi_deg_sum + wifi_deg_curr;
                    end
                    
                    response_delay(n_vlc,rerun,wp,chan_iter,uplink_mcs_iter) = mean(res_del_vec_cum(:));
                    legacy_wifi_tput_deg_ota(n_vlc,rerun,wp,chan_iter,uplink_mcs_iter) =  1 - wifi_ratio_cum;
                    
                end
               

%                 response_delay(n_vlc,wp,chan_iter,uplink_mcs_iter,1) = mean(res_del_vec_cum(:));
%                 response_delay(n_vlc,wp,chan_iter,uplink_mcs_iter,2) = std(res_del_vec_cum(:));
%                 response_delay(n_vlc,wp,chan_iter,uplink_mcs_iter,3) = median(res_del_vec_cum(:));
%                 response_delay(n_vlc,wp,chan_iter,uplink_mcs_iter,4) = mad(res_del_vec_cum(:),1);
%                 
%                 From WARP measurements of Legacy User Throughput
%                 legacy_wifi_tput_deg_ota(n_vlc,wp,chan_iter,uplink_mcs_iter,1) =  1 - mean(wifi_ratio_cum);
%                 legacy_wifi_tput_deg_ota(n_vlc,wp,chan_iter,uplink_mcs_iter,2) =  std(wifi_ratio_cum);
%                 legacy_wifi_tput_deg_ota(n_vlc,wp,chan_iter,uplink_mcs_iter,3) =  1 - median(wifi_ratio_cum);
%                 legacy_wifi_tput_deg_ota(n_vlc,wp,chan_iter,uplink_mcs_iter,4) =  mad(wifi_ratio_cum);
%                 
%                 From WARP measures of VLC user collisions and
%                 transmissions
%                 legacy_wifi_tput_deg_vlc(n_vlc,wp,chan_iter,uplink_mcs_iter,1) =  mean(wifi_deg_sum);
%                 legacy_wifi_tput_deg_vlc(n_vlc,wp,chan_iter,uplink_mcs_iter,2) =  std(wifi_deg_sum);
%                 legacy_wifi_tput_deg_vlc(n_vlc,wp,chan_iter,uplink_mcs_iter,3) =  median(wifi_deg_sum);
%                 legacy_wifi_tput_deg_vlc(n_vlc,wp,chan_iter,uplink_mcs_iter,4) =  mad(wifi_deg_sum);
            end
        end
    end
    %save(['WARP_PROCESSED_DATA/SECON_80211_' num2str(n_vlc) '_performance_metrics.mat'], 'response_delay','legacy_wifi_tput_deg');
end
save(['WARP_PROCESSED_DATA/SECON_80211_performance_metrics.mat'], 'response_delay','legacy_wifi_tput_deg_ota');
