function [T_w, payload] = lira_trigger_adaptation(vlc_data_rate, vlc_pkt_size, delta_deg, Nclients, initial_offset)

%INPUTS:
%vlc_data_rate -> units: Mbps
%vlc_pkt_size -> bits
%initial_offset -> offset from packets of previous triggr cycle

%All times in microseconds

T_overhead = 34;
SIFS = 10;
SLOT = 20;
delta = 0.1;
t_CTS = 34;
CCrate = 6;
bits_per_symbol = 24;

%INITIALIZATION
triggered = 0;
T_w = ((1/delta_deg)-1)*(SIFS + SLOT + t_CTS + T_overhead + SIFS + (1/CCrate));
time_incr = vlc_pkt_size/vlc_data_rate + 3 + 3;
time = time_incr;
payload = t_CTS + T_overhead + SIFS + (1/CCrate); %The data rate will be multiplied at the end of the function


%Initial packet to all clients
for n=2:1:Nclients
    T_w = T_w + (((1/delta_deg) - 1)*(T_overhead + SIFS + (1/CCrate)));
    time = time + time_incr;
    payload = payload + T_overhead + SIFS + (1/CCrate);
    if(time > T_w)
        triggered = 1;
        break;
    end
end

while(triggered == 0)
    %Entering the steady state
    T_w = T_w + (((1/delta_deg)- 1)*(1/CCrate));
    time = time + time_incr;
    
    payload = payload + (1/CCrate);
    
    if(time > T_w)
        triggered = 1;
        break;
    end
    
end

payload = payload*CCrate/8; %bytes

end



