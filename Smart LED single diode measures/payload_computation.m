clear all;
close all;
clc;

initialize;
load LED_measures.mat;

Nclients_max = 10;
Ndistr = 50; %No. of distributions of VLC clients
Ntrigger_time = 3;%1 ms, 5 ms, 10 ms

payload_res = zeros(Ntrigger_time,Nclients_max,Ndistr); 
client_loc = ceil(

for distr = 1:1:Ndistr
    
    
    
    for n=1:1:Nclient
    
    
    [T_w_high, payload_h] = lira_trigger_adaptation(vlc_data_rate_high,vlc_pkt_size_high, delta_deg, n,0); %milliseconds
    trigger_time_high(n) = 0.001*T_w_high;
    payload_high(n) = payload_h;
end