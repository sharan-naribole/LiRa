clear all;
close all;
clc;

%This is a code to determine the payload lengths for the WARP
%measurements of LiRa protocol. This payload is determined by the following factors:
% a) Number of VLC clients
% b) VLC data packet size
% c) Downlink VLC data rate
% d) Trigger time

%Our strategy is to fix the VLC packet size to 32 KB for high rate (1 Gbps) links
%and 1 KB for the 10 Mbps links.
%Case 1: 1 Gbps downlink, 32 KB, 1-10 VLC clients
%     a) Fixed trigger time of 1 ms
%     b) Fixed trigger time of 10 ms
%     c) Adaptive trigger 

%Case 2: 10 Mbps downlink, 1 KB, 1-10 VLC clients
%     a) Fixed trigger time of 1 ms
%     b) Fixed trigger time of 10 ms
%     c) Adaptive trigger

Nclients_max = 10;
delta_deg = 0.1; %LiRa's degradation-constrained adaptation
CCrate = 6; %Mbps

%Case 1: 1 Gbps downlink, 32 KB, 1-10 VLC clients
vlc_pkt_size_high = 32*1024*8;
vlc_data_rate_high = 1000; %Mbps
trigger_time_high = zeros(Nclients_max,1);
payload_high = zeros(Nclients_max,1);

vlc_pkt_size_low = 1*1024*8;
vlc_data_rate_low = 40;
trigger_time_low = zeros(Nclients_max,1);
payload_low = zeros(Nclients_max,1);

for n = 1:1:Nclients_max
    [T_w_high, payload_h] = lira_trigger_adaptation(vlc_data_rate_high,vlc_pkt_size_high, delta_deg, n,0); %milliseconds
    trigger_time_high(n) = 0.001*T_w_high;
    payload_high(n) = payload_h;
    
    T_w_high
    payload_h
    
    [T_w_low, payload_l] = lira_trigger_adaptation(vlc_data_rate_low,vlc_pkt_size_low, delta_deg, n,0); %milliseconds
    trigger_time_low(n) = 0.001*T_w_low;
    payload_low(n) = payload_l;

    T_w_low
    payload_l
    
end
