function [airtime, Nack_bits_total, wifi_deg] = compute_asma_deg(trigger,Nclients,rate,del)

    load global_params.mat;
    sweep_time = vlc_pkt_size./(Nclients*rate)

    Nrounds = ceil((trigger + del)/sweep_time);

    
    Nack_bits = bits_per_symbol*ceil(Nrounds/bits_per_symbol);
    Nack_bits_total = Nack_bits*Nclients;
    ack_tx_time = T_overhead + (Nack_bits/CCrate);
    airtime = PIFS + t_CTS + SIFS + Nclients*ack_tx_time;

    wifi_deg = 100*(airtime)/(airtime + del + trigger);
end

