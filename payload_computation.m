clear all;
close all;
clc;

initialize;
load LED_measures.mat;

Nclients_max = 10;
Ndistr = 1; %No. of distributions of VLC clients
Ntrigger_time = 1;%1 ms, 5 ms, 10 ms

trigger_times = 5*1e3;% in microseconds

payload_res = zeros(Ntrigger_time,Nclients_max,Ndistr); 
client_loc = ceil(Nlocs*rand(Nclients_max,Ndistr));
client_or = ceil(Nors*rand(Nclients_max,Ndistr));
client_rates = zeros(Nclients_max,Ndistr);

for distr = 1:1:Ndistr  
    distr
    %Data Rate for each client in each distribution
    for n=1:1:Nclients_max
        rx_pow = P_RX_min + 10*log10(process_mean_data(client_loc(n,distr),client_or(n,distr))/min(process_mean_data(:)));
        client_rates(n,distr) = 10;%DataRate(rx_pow);
    end
    
    for n=1:1:Nclients_max
        for trigg = 1:1:Ntrigger_time
            payload_tmp = payload(squeeze(client_rates(1:n,distr)),trigger_times(trigg));
            payload_res(trigg,n,distr) = payload_tmp;
        end
    end
end