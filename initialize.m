clear all;
close all;
clc;

%This code basically initializes all the variables used in the simulation
%framework

%Wi-Fi link Parameters
legacy_pkt_size = 1400*8; %payload in bits
vlc_pkt_size = 100*8; %payload
running_time = 30; %WARP experiment running time

%WARP Parameters
Ntrigg_intervals_max = 100;
Ntrigg_interval_offset = 1;
Ntrigg_intervals_sep = 1;

%Location params
Nlocs = 42;
Nors = 13;

%MAC Parameters
T_overhead = 34;
PIFS = 10;
SIFS = 10;
ACK_80211 = 30;
SLOT = 20;
delta = 0.1;
t_CTS = 34;
CCrate = 6;
bits_per_symbol = 24;
vlc_pkt_size = 1*1024*8; %bytes;4KB,1 KB, 32 KB


%PHY Parameters
phy_mode = 'OOK';%OOK, CSK
P_RX_min = -72;

%RECEIVED POWER TO MCS MAP FOR PHY II Operating Mode
sense_thresh_OOK = [-72,-70,-68,-66,-65,-64,-62,-63,-62,-61,-59,-55,-54,-53];
mcsIndex_OOK = [16,17,18,19,20,21,22,23,24,25,26,27,28,29];
mcsMap_OOK = containers.Map(sense_thresh_OOK,mcsIndex_OOK);
rates_OOK = [1.25,2,2.5,4,5,6,9.6,12,19.2,24,38.4,48,76.8,96]*10;
mcsOOKMap = containers.Map(rates_OOK,sense_thresh_OOK);

%RECEIVED POWER TO MCS MAP FOR PHY III Operating Mode
sense_thresh_CSK = [-63,-62,-60,-58,-56,-54,-53];
mcsIndex_CSK = [32,33,34,35,36,37,38];
mcsMap_CSK = containers.Map(sense_thresh_CSK,mcsIndex_CSK);

mcsIndex = [0,16,17,18,19,20,21,22,23,24,25,26,27,28,29,32,33,34,35,36,37,38];
rates = [0.1,1.25,2,2.5,4,5,6,9.6,12,19.2,24,38.4,48,76.8,96,12,18,24,36,48,72,96]*10; % Bits/microsecond
mcsRateMap = containers.Map(mcsIndex,rates);

save('global_params.mat');

