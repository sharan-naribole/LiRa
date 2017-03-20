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
Nuplink_mcs = 1;
Nreruns = 21

uplink_mcs = [18];
uplink_mcs_id = [3];
wifi_chan = [1,14,48];

legacy_only_tput = NaN(Nwifi_chan,4);


for chan_iter = 1:1:Nwifi_chan
    CHANNEL = wifi_chan(chan_iter)

    %Uplink MCS Loop
    for uplink_mcs_iter = 1:1:Nuplink_mcs

        UPLINK_MCS = uplink_mcs(uplink_mcs_iter)
        UPLINK_MCS_ID = uplink_mcs_id(uplink_mcs_iter);
        %Actual Experiment begins here for 30 seconds

        tput_curr = NaN(Nreruns,1);

        for rerun=1:1:Nreruns
            rerun
            filename = ['WARP_MEASURES_SECON_2017/FINAL_ROUND/80211_VLC_0/MAT_Files/80211_LU_1_WP_0_UMCS_' num2str(UPLINK_MCS_ID) '_CH_' num2str(CHANNEL) '_RERUN_' num2str(rerun-1) '_legacy_user1_tput.mat'];
            load(filename);
            tput_curr(rerun) = eval(['LegacyUser1_xput']);
        end

        legacy_only_tput(chan_iter,1) = mean(tput_curr);
        legacy_only_tput(chan_iter,2) = std(tput_curr);
        legacy_only_tput(chan_iter,3) = median(tput_curr);
        legacy_only_tput(chan_iter,4) = mad(tput_curr);
    end
end

save(['WARP_PROCESSED_DATA/80211_LU_ONLY_xput.mat'], 'legacy_only_tput');