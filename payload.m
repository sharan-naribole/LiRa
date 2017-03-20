function [payload_length] = payload(client_rates, trigger_time)

%INPUTS:
%vlc_data_rate -> units: bits/msec
%vlc_pkt_size -> bits
%initial_offset -> offset from packets of previous triggr cycle

load global_params.mat;
Nclients = size(client_rates,1);

%No. of downlink packets transmitted within trigger time interval
sweep_time = 0;
for n=1:1:Nclients
    sweep_time = sweep_time + (vlc_pkt_size/client_rates(n));
end

Nrounds = trigger_time/sweep_time;
Nack_bits = bits_per_symbol*ceil(Nrounds*Nclients/bits_per_symbol);

if(Nrounds < 1)
    payload_length = t_CTS + (ceil(Nrounds*Nclients)*(T_overhead + SIFS)) + (Nack_bits/CCrate);
else
    payload_length = t_CTS + Nclients*(T_overhead + SIFS) + (Nack_bits/CCrate);
end

payload_length = payload_length*CCrate/8; %bytes

end

