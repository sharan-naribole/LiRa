clear all;
close all;
clc;

initialize;

trigger_times = [1,2.5,4,5.5,7,8.5,10]*1e3;% in microseconds
clients = [1,10];
data_rates = [10, 100];
delay = [0, 1024*8/6];

Ntrigger_time = max(size(trigger_times));%1 ms, 5 ms, 10 ms
Ncl = max(size(clients));
Nrates = max(size(data_rates));
Ndel = max(size(delay));

airtime = NaN(Ntrigger_time,Ncl,Nrates,Ndel);
Nack_bits = NaN(Ntrigger_time,Ncl,Nrates,Ndel);
wifi_deg = NaN(Ntrigger_time,Ncl,Nrates,Ndel);
for trigg_iter = 1:1:Ntrigger_time
    trigger = trigger_times(trigg_iter);
    for cl = 1:1:Ncl
        Nclients = clients(cl);
        for rate_iter =1:1:Nrates
            rate = data_rates(rate_iter);
            for delay_iter = 1:1:Ndel
                del_curr = delay(delay_iter);
                [airtime_curr,nack_bits_curr,wifi_deg_curr] = compute_asma_deg(trigger,Nclients,rate,del_curr);
                airtime(trigg_iter,cl,rate_iter,delay_iter) = airtime_curr;
                Nack_bits(trigg_iter,cl,rate_iter,delay_iter) = nack_bits_curr;
                wifi_deg(trigg_iter,cl,rate_iter,delay_iter) = wifi_deg_curr;
            end
        end
    end
end

%Overhead value: Airtime in actual numbers
%X-axis: trigger times (7)
%Y-axis: Data rate: 1 Gbps - 1 client , 1 Gbps - 10 clients,  10 Mbps - 10 clients
%The variance is caused by trigger delay being either 0 to TXOP

figure;
colormap inferno;
comp=[1 2 3];
%cc = hsv(max(size(comp)));

y = [mean(wifi_deg(1,1,1,1)) mean(wifi_deg(1,2,1,1)) mean(wifi_deg(1,1,2,1)) mean(wifi_deg(1,2,2,1));
     mean(wifi_deg(3,1,1,1)) mean(wifi_deg(3,2,1,1)) mean(wifi_deg(3,1,2,1)) mean(wifi_deg(3,2,2,1));
     mean(wifi_deg(5,1,1,1)) mean(wifi_deg(5,2,1,1)) mean(wifi_deg(5,1,2,1)) mean(wifi_deg(5,2,2,1));
     mean(wifi_deg(7,1,1,1)) mean(wifi_deg(7,2,1,1)) mean(wifi_deg(7,1,2,1)) mean(wifi_deg(7,2,2,1));
     ];
 bar(y);    
     
legend_pairings = {'1 Client - 10 Mbps', '10 Clients - 10 Mbps', '1 Client - 100 Mbps', '10 Clients - 100 Mbps'};
grid on;
xlabel('FEEDBACK TRIGGER TIME (ms)');
ylabel('Wi-Fi THROUGHPUT DEGRADATION (%)');
legend(legend_pairings);
set(gca,'FontSize',24,'fontWeight','bold');
set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');        
        

figure;
colormap inferno;
comp=[1 2 3];
%cc = hsv(max(size(comp)));

y = [mean(wifi_deg(1,1,1,2)) mean(wifi_deg(1,2,1,2)) mean(wifi_deg(1,1,2,2)) mean(wifi_deg(1,2,2,2));
     mean(wifi_deg(3,1,1,2)) mean(wifi_deg(3,2,1,2)) mean(wifi_deg(3,1,2,2)) mean(wifi_deg(3,2,2,2));
     mean(wifi_deg(5,1,1,2)) mean(wifi_deg(5,2,1,2)) mean(wifi_deg(5,1,2,2)) mean(wifi_deg(5,2,2,2));
     mean(wifi_deg(7,1,1,2)) mean(wifi_deg(7,2,1,2)) mean(wifi_deg(7,1,2,2)) mean(wifi_deg(7,2,2,2));
     ];
 bar(y);    
     
legend_pairings = {'1 Client - 10 Mbps', '10 Clients - 100 Mbps', '1 Client - 100 Mbps', '10 Clients - 100 Mbps'};
grid on;
xlabel('FEEDBACK TRIGGER TIME (ms)');
ylabel('Wi-Fi THROUGHPUT DEGRADATION (%)');
legend(legend_pairings);
set(gca,'FontSize',24,'fontWeight','bold');
set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

figure;
colormap inferno;
grid on;
y = 0.001*[mean(airtime(1,1,1,1)) mean(airtime(1,2,1,1)) mean(airtime(1,1,2,1)) mean(airtime(1,2,2,1));
     mean(airtime(3,1,1,1)) mean(airtime(3,2,1,1)) mean(airtime(3,1,2,1)) mean(airtime(3,2,2,1));
     mean(airtime(5,1,1,1)) mean(airtime(5,2,1,1)) mean(airtime(5,1,2,1)) mean(airtime(5,2,2,1));
     mean(airtime(7,1,1,1)) mean(airtime(7,2,1,1)) mean(airtime(7,1,2,1)) mean(airtime(7,2,2,1));
     ];
 bar(y);    
      
% for cl=1:1:Ncl
%     for rate_iter = 1:1:Nrates
%          p = 0.001*squeeze(mean(airtime(:,cl,rate_iter,:),4));
%          p = p';
%          %q = 0.001*squeeze(std(airtime(:,cl,rate_iter,:),4));
%          %q = q';
%          semilogy(trigger_times,p);%,'color',cc(t,:));
%          %errorbar(1:Nclient_locs,squeeze(tr_oh_res(:,comp(t),1)),squeeze(tr_oh_res(:,comp(t),2)));%,'color',cc(t,:));
%          hold all;
%     end
% end
legend_pairings = {'1 Client - 1 Mbps', '10 Clients - 1 Mbps', '1 Client - 100 Mbps', '10 Clients - 100 Mbps'};
grid on;
xlabel('FEEDBACK TRIGGER TIME (ms)');
ylabel('AIRTIME (ms)');
legend(legend_pairings);
set(gca,'FontSize',24,'fontWeight','bold');
set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');        

figure;
colormap inferno;
grid on;
y = 0.001*[mean(airtime(1,1,1,2)) mean(airtime(1,2,1,2)) mean(airtime(1,1,2,2)) mean(airtime(1,2,2,2));
     mean(airtime(3,1,1,2)) mean(airtime(3,2,1,2)) mean(airtime(3,1,2,2)) mean(airtime(3,2,2,2));
     mean(airtime(5,1,1,2)) mean(airtime(5,2,1,2)) mean(airtime(5,1,2,2)) mean(airtime(5,2,2,2));
     mean(airtime(7,1,1,2)) mean(airtime(7,2,1,2)) mean(airtime(7,1,2,2)) mean(airtime(7,2,2,2));
     ];
 bar(y);    
      
% for cl=1:1:Ncl
%     for rate_iter = 1:1:Nrates
%          p = 0.001*squeeze(mean(airtime(:,cl,rate_iter,:),4));
%          p = p';
%          %q = 0.001*squeeze(std(airtime(:,cl,rate_iter,:),4));
%          %q = q';
%          semilogy(trigger_times,p);%,'color',cc(t,:));
%          %errorbar(1:Nclient_locs,squeeze(tr_oh_res(:,comp(t),1)),squeeze(tr_oh_res(:,comp(t),2)));%,'color',cc(t,:));
%          hold all;
%     end
% end
legend_pairings = {'1 Client - 1 Mbps', '10 Clients - 1 Mbps', '1 Client - 100 Mbps', '10 Clients - 100 Mbps'};
grid on;
xlabel('FEEDBACK TRIGGER TIME (ms)');
ylabel('AIRTIME (ms)');
legend(legend_pairings);
set(gca,'FontSize',24,'fontWeight','bold');
set(gca,'XTickLabel',{'1 ms', '4 ms', '7 ms', '10 ms'})
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');     
            