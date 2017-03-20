function [res_del_vec, vlc_airtime] = compute_response_delay_80211_single_client(client_rate, tx_offset, num_tx,payload_offset)
%Computation of Response Delay using mixture of WARP and VLC measurements
%  tx_offset = tx_done.mat of the AP in the WARP measurements

load global_params.mat;
Nclients = size(client_rate,1);
Ntrigg_intervals = max(size(tx_offset));

tx_time = vlc_pkt_size/client_rate;

pkt_counter = 0;
res_del_vec(1) = 0;

%Trigger Time Interval Iterator
interval_iter = Ntrigg_interval_offset;
interval_count = 0;

vlc_time = 0;
total_time = 0;


while(interval_count < min(Ntrigg_intervals,Ntrigg_intervals_max) && interval_iter < Ntrigg_intervals)
    %interval_count
    Nrounds = ceil((tx_offset(interval_iter) - payload_offset)/tx_time);
    
    Nack_bits = bits_per_symbol*ceil(Nrounds/bits_per_symbol);
    ack_tx_time = T_overhead + (Nack_bits/CCrate);
    floor_rounds = floor((tx_offset(interval_iter) - payload_offset)/tx_time);
    frac_rounds = (tx_offset(interval_iter) - payload_offset)/tx_time;
     
    vlc_airtime = ack_tx_time; %In the future, as I know tx_attempts for this packet and the timestamps, I can accordingly calculate the appropriate degradation caused
    total_time = total_time + ack_tx_time + SIFS + ACK_80211;
    
    Npkts = Nrounds-1;
    % 1 to Final-1 rounds
    for k=1:1:Npkts
        pkt_counter = pkt_counter + 1;
        res_del_curr = tx_offset(interval_iter) + (ack_tx_time) - (k*tx_time);
        res_del_vec(pkt_counter) = res_del_curr;
    end 

    
    interval_iter = interval_iter + Ntrigg_intervals_sep;
    interval_count = interval_count + 1;
    
end

wifi_tput_deg = 1 - (vlc_airtime/total_time);

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
    

