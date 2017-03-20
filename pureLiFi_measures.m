clc;

%pureLiFi measurements

clear all
raw_up = [0,9.91,0;0,10.6,0.129;0,9.29,0.0667;0,10.2,9.38;0,9.97,10.7;0,0,10.2];
raw_down = [0,8.08,0;0,8.43,0;0,9.23,0;0,5.56,4.82;0,4.78,5.35;0,0,7.51];
distance_to_AP_transmitter = (63-2-3/16-((1:6) -1)*6.125)*2.54;
distance_to_AP_receiver = (64-2-3/16-((1:6) -1)*6.125)*2.54;

for i=1:6
    for j=1:3
        result(i,j).distance_to_AP_transmitter = distance_to_AP_transmitter(i);
        result(i,j).distance_to_AP_receiver = distance_to_AP_receiver(i);
        result(i,j).uplink_bandwidth = raw_up(i,j);
        result(i,j).downlink_bandwidth = raw_down(i,j);
        result(i,j).rotation_angle = (2-j)*20;
    end
end
%%%'result' is a 6*3 struct storing experiment data;
%%%distance_to_AP_transmitter/receiver stores the distance (cm) from user to
%%%the transmitter(light bulb) and receiver of the AP;
%%%uplink/downlink_bandwidth stores the bandwidth (Mbits/sec) for
%%%uplink/downlink iperf transmission; rotation_angle records the angle of
%%%rotation; results(1-6,:) stores measurements with decreasing distance
%%%from AP, results(:,1:3) stores measurements at 20,0,-20 degrees of
%%%rotation

legend_or = {'+20 degrees' , '0 degrees', '-20 degrees'};

%Sub-section: Response Delay Evaluation
%Graph 1: Trigger Time Evaluation
comp=[1 2 3];
%cc = hsv(max(size(comp)));
figure;
colormap inferno;
for t=1:1:max(size(comp))
     plot(distance_to_AP_transmitter,raw_down(:,t))
     hold all;
end
grid on;
xlabel('DISTANCE BETWEEN LIGHT BULB AND CLIENT RECEIVER (cm) --->');
ylabel('Downlink Throughput (Mbps)');
legend(legend_or);
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');

%Sub-section: Response Delay Evaluation
%Graph 1: Trigger Time Evaluation
comp=[1 2 3];
%cc = hsv(max(size(comp)));
figure;
colormap inferno;
for t=1:1:max(size(comp))
     plot(distance_to_AP_receiver,raw_up(:,t))
     hold all;
end
grid on;
xlabel('DISTANCE BETWEEN LIGHT BULB AND CLIENT RECEIVER (cm) --->');
ylabel('Uplink Throughput (Mbps)');
legend(legend_or);
set(gca,'FontSize',24,'fontWeight','bold');
set(findall(gcf,'type','text'),'FontSize',24,'fontWeight','bold');