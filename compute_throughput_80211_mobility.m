function [ throughput ] = compute_throughput_80211_mobility(rx_pow,bulb_alloc_ideal,data_rate_ideal,tx_done_cum, payload_off, total_time)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

load global_params.mat;
Nclients = size(rx_pow,1);

%Trigger Time Interval Iterator
interval_iter = Ntrigg_interval_offset;
interval_count = 0;

Ntrigg_intervals = NaN(Nclients,1);
next_trigger = NaN(Nclients,1);
trigger_interval_id = ones(Nclients,1);

for n=1:1:Nclients
    Ntrigg_intervals(n) = max(size(tx_done_cum(n).tx_done));
    tmp = tx_done_cum(n).tx_done;
    next_trigger(n) = 0.001*double(tmp(1));
end

curr_order = 1:Nclients; % order of transmission to clients - will keep changing as only fraction is reached

packets_tx = 0;
packets_ack = 0;
time = 0;
client_curr = 1;
data_rate_curr = data_rate_ideal(:,1);
bulb_alloc_curr = bulb_alloc_ideal(:,1);

while(time < total_time && (sum(trigger_interval_id < Ntrigg_intervals)== Nclients))
    %time
    %client_curr
    %dd = next_trigger(client_curr)
    
    if(time < next_trigger(client_curr))
        % Current packet transmission
        tx_time = 0.001*(vlc_pkt_size/data_rate_curr(client_curr));
        time  = time + tx_time;
        if(time > total_time)
            break;
        end
        packets_tx = packets_tx + 1;

        %Check if packet reception was successful or not
%         rx_pow(client_curr,ceil(time))
%         mcsOOKMap(data_rate_curr(client_curr))
%         bulb_alloc_curr(client_curr)
%         bulb_alloc_ideal(client_curr,ceil(time))
        if(rx_pow(client_curr,ceil(time)) >= mcsOOKMap(data_rate_curr(client_curr)) && (bulb_alloc_curr(client_curr)==bulb_alloc_ideal(client_curr,ceil(time))))
            packets_ack = packets_ack + 1;
        end
    else
        bulb_alloc_curr(client_curr) = bulb_alloc_ideal(client_curr,ceil(time));
        data_rate_curr(client_curr) = data_rate_ideal(client_curr,ceil(time));
        trigger_interval_id(client_curr) = trigger_interval_id(client_curr) + 1;
        tmp = tx_done_cum(client_curr).tx_done;
        next_trigger(client_curr) = time + (0.001*tmp(trigger_interval_id(client_curr)));
    end
    
    client_curr = mod(client_curr + 1,Nclients);
    if(client_curr == 0)
        client_curr = Nclients;
    end
    
end

throughput = packets_ack*vlc_pkt_size/(time*1000); %Mbps

