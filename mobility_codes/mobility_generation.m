clear all;
close all;
clc;

%This code is for mobility generation
%Basically, it will give the current_bulb strength value and the point at
%which the bulb transfer needs to happen

load global_params.mat;

%Basically we consider two bulbs across whom the client is oscillating
% Stays stationary at a given location for 2 seconds before jumping to
% another location
% Current Bulb X strength S_X -> goes down to thresh then increases as gets closer to bulb Y -> Bulb Y with S_Y

Nclients = 4;
bulb_curr = 1; % 1 or 2 always
total_time = 10000; %ms
time_step = 1; %ms
Nsteps = ceil(total_time/time_step);
drop_rate = 0.01; %dBm/msec
time_to_stop = 1000; %msec; time to stop on reaching destination
Nbulbs = 2;
Ndistr = 50;

min_rx = min(sense_thresh_OOK);
max_rx = max(sense_thresh_OOK);

rx_pow = NaN(Nclients,Nsteps,Ndistr);
bulb_alloc_ideal = NaN(Nclients, Nsteps,Ndistr);
data_rate_ideal = NaN(Nclients, Nsteps, Ndistr);

for distr = 1:1:Ndistr 
    for n=1:1:Nclients  
        rx_pow(n,1,distr) = sense_thresh_OOK(ceil(max(size(sense_thresh_OOK))*rand));
        data_rate_ideal(n,1,distr) = DataRate(rx_pow(n,1,distr));
        bulb_alloc_ideal(n,1,distr) = 0;
        static_timer = 0;
        step = 2;

        while(step < Nsteps)
            curr_rx = rx_pow(n,step - 1);
            if(static_timer < time_to_stop)
                rx_pow(n,step:min(Nsteps,step + time_to_stop),distr) = curr_rx;
                bulb_alloc_ideal(n,step:min(Nsteps,step + time_to_stop),distr) = bulb_alloc_ideal(n,step - 1,distr);
                data_rate_ideal(n,step:min(Nsteps,step + time_to_stop),distr) = DataRate(curr_rx);
                dec_slope = 1;
                step = min(Nsteps,step + time_to_stop - static_timer);
                static_timer = time_to_stop;
                dest_rx = sense_thresh_OOK(ceil(max(size(sense_thresh_OOK))*rand));
            else
                if(rx_pow(n,step - 1) <= min_rx)
                    dec_slope = 0;
                    bulb_alloc_ideal(n,step,distr) = mod(bulb_alloc_ideal(n,step -1,distr) + 1,Nbulbs);
                    
                elseif(dec_slope ==0 && rx_pow(n,step - 1) > dest_rx)
                    bulb_alloc_ideal(n,step,distr)= bulb_alloc_ideal(n,step - 1,distr);
                    data_rate_ideal(n,step,distr)= data_rate_ideal(n,step - 1,distr);
                    static_timer = 0;  
                    continue;
                end

                if(dec_slope)
                    rx_pow(n,step,distr) = rx_pow(n,step-1,distr) - drop_rate;
                else
                    rx_pow(n,step,distr) = rx_pow(n,step-1,distr) + drop_rate;
                end           
                step = step + 1;
            end
            bulb_alloc_ideal(n,step,distr)= bulb_alloc_ideal(n,step - 1,distr);
            data_rate_ideal(n,step,distr)= data_rate_ideal(n,step - 1,distr);
        end
    
    %     figure
    %     h = plot(bulb_alloc_ideal(n,:));
    %     title(['Client ' num2str(n)]);
    %     set(h,'linewidth',2);
    %     grid on;
    %     xlabel('Time');
    %     ylabel('RSSI (dBm)');
    %     
    %     set(gca,'FontSize',24,'fontWeight','bold');
    %     %set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
    %     set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');
    end
end

save('mobility_distributions.mat','rx_pow','bulb_alloc_ideal','data_rate_ideal','total_time','drop_rate','time_to_stop','time_step','Nsteps');

            
                
    

