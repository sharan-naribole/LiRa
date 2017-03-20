clear all;
close all;
clc;

initialize;

trigger_times = [1,4,7,10]*1e3;% in microseconds
clients = [1,10];
data_rates = [10,1000];
delay = [0, 8192];

Ntrigger_time = max(size(trigger_times));%1 ms, 5 ms, 10 ms
Ncl = max(size(clients));
Nrates = max(size(data_rates));
Ndel = max(size(delay));

airtime = NaN(Ntrigger_time,Ncl,Nrates,Ndel);
Nack_bits = NaN(Ntrigger_time,Ncl,Nrates,Ndel);

for trigg_iter = 1:1:Ntrigger_time
    trigger = trigger_times(trigg_iter);
    for cl = 1:1:Ncl
        Nclients = clients(cl);
        for rate_iter =1:1:Nrates
            rate = data_rates(rate_iter);
            for delay_iter = 1:1:Ndel
                del_curr = delay(delay_iter);
                [airtime_curr,nack_bits_curr] = compute_asma_deg(trigger,Nclients,rate,del_curr);
                airtime(trigg_iter,cl,rate_iter,delay_iter) = airtime_curr;
                Nack_bits(trigg_iter,cl,rate_iter,delay_iter) = nack_bits_curr;
            end
        end
    end
end


        
        
            