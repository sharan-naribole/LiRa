clear all;
close all;
clc;

%THIS WILL THE FUNDAMENTAL CODE FOR OUTPUTTING LIRA'S PERFORMANCE METRICS

%Loading key files
initialize;

%Ndistr = max(size(mcsIndex_OOK)) + 1; %No. of distributions of VLC clients
Nlu_max = 1;
Nclients_max = 1;
Nwifi_chan = 3;
Nuplink_mcs = 3;

uplink_mcs = [18];
uplink_mcs_id = [3];
wifi_chan = [1,14,48];

legacy_only_tput = NaN(Nlu_max,Nwifi_chan,Nuplink_mcs);

for n=1:1:Nlu_max
% Wi-Fi Channel Loop
    for chan_iter = 1:1:Nwifi_chan
        CHANNEL = wifi_chan(chan_iter)

        %Uplink MCS Loop
        for uplink_mcs_iter = 1:1:Nuplink_mcs

            UPLINK_MCS = uplink_mcs(uplink_mcs_iter);
            UPLINK_MCS_ID = uplink_mcs_id(uplink_mcs_iter);
            %Actual Experiment begins here for 30 seconds

            tput_curr = 0;
            
            for k=1:1:n
                filename = ['WARP_MEASURES/ULTIMATE_ROUND_PAYLOAD_1024/RAW_DATA/80211_LU_' num2str(n) '/MAT_Files/80211_LU_' num2str(n) '_UMCS_' num2str(UPLINK_MCS_ID) '_CH_' num2str(CHANNEL) '_legacy_user' num2str(k) '_tput.mat'];
                load(filename);
                tput_curr = tput_curr + eval(['LegacyUser' num2str(k) '_xput']);
            end
            
            legacy_only_tput(n,chan_iter,uplink_mcs_iter) = tput_curr;
        end
    end
end


save(['WARP_MEASURES/ULTIMATE_ROUND_PAYLOAD_1024/FORMATTED_DATA/80211_LU_ONLY_xput.mat'], 'legacy_only_tput');