function [res_del_vec, wifi_tput_deg] = compute_metrics_LiRa(client_rates, trigg_time, tx_offset, payload_offset)
%Computation of Response Delay using mixture of WARP and VLC measurements
%  tx_offset = tx_done.mat of the AP in the WARP measurements

load global_params.mat;
Nclients = size(client_rates,1);
Ntrigg_intervals = max(size(tx_offset));

tx_time = vlc_pkt_size./client_rates;
sweep_time = sum(tx_time);

pkt_counter = 0;
res_del_vec(1) = 0;

%Trigger Time Interval Iterator
interval_iter = Ntrigg_interval_offset;
interval_count = 0;

curr_order = 1:Nclients; % order of transmission to clients - will keep changing as only fraction is reached

LiRa_time = 0;
total_time = 0;

while(interval_count <=min(Ntrigg_intervals,Ntrigg_intervals_max) && interval_iter <=Ntrigg_intervals)
    
    curr_order = randperm(Nclients);
    
    for n=1:1:Nclients
        sweep_client(n) = sum(tx_time(curr_order(1:n)));
    end
    
    %interval_count
    Nrounds = ceil((trigg_time + tx_offset(interval_iter) - payload_offset)/sweep_time);
    floor_rounds = floor((trigg_time + tx_offset(interval_iter) - payload_offset)/sweep_time);
    frac_rounds = (trigg_time + tx_offset(interval_iter) - payload_offset)/sweep_time;
    Nfinal = ceil(Nclients*(frac_rounds - floor_rounds));
    
    Nack_bits = bits_per_symbol*ceil(Nrounds/bits_per_symbol);
    ack_tx_time = T_overhead + (Nack_bits/CCrate);
    
    for n= 1:1:Nclients       
        Npkts = Nrounds;
         if(n >= Nfinal)
             Npkts = Nrounds - 1;
         end
        
        % 1 to Final-1 rounds
        for k=1:1:Npkts
            pkt_counter = pkt_counter + 1;
            res_del_curr = ((Nrounds - 1)*sweep_time) - ((k-1)*sweep_time) - sweep_client(n) + ((frac_rounds  - floor_rounds)*sweep_time) + t_CTS + SIFS + (ack_tx_time*n);
            res_del_vec(pkt_counter) = res_del_curr;
        end 
    end
    
    interval_iter = interval_iter + Ntrigg_intervals_sep;
    interval_count = interval_count + 1;
   
end

end





% client_pointer = 1; %Client to which the current TX takes place
% time = 0; %Overall time counter
% trigger_timer = 0; %starts when a VLC ACK transmission ends
% trigger_phase = 0; %0 when normal TX; 1 when ASMA in action(Trigger message and uplink VLC ACK transmissions taking place)
% trigger_off = 0;

% while(trigg_interval_counter < Ntrigg_intervals)
%         
%     trigger_off = tx_offset(trigger_interval_counter);
%     if(trigger_timer < trigg_time + trigger_off)
%         trigger_phase = 0;
%     else
%         trigger_phase = 1;
%     end
%     
%     if(trigger_phase == 0)
%         pkt_counter = pkt_counter + 1;
%         client_pointer = mod(client_pointer + 1, Nclients);
%         if(client_pointer == 0)
%             client_pointer = Nclients;
%         end
% 
%         %Timing stats
%         time = time + tx_time(client_pointer);
%         trigg_timer = trigg_timer + tx_time(client_pointer);
% 
%         %Packet stats
%         packet(pkt_counter).status = 0; % 0 = not ACKed; 1 = ACKed 
%         packet(pkt_counter).client = client_pointer;
%         packet(pkt_counter).res_delay = NaN;
%         packet(pkt_counter).tx_timestamp = time;
%         %packet(pkt_counter).ID = pkt_counter;
%         
%         %Client stats
%         client_count(client_pointer) = client_count(client_pointer) + 1;
%         
%     else
%         %For simplicity I do not consider the packets being transmitted
%         %during the ASMA active period
%         client_tx_time 
%         
%     
% end
    

