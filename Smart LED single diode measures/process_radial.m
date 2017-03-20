clear all
clc
%%retrieve raw data and put into 4-d matrix
plot_mean=zeros(1,1);
y=1;
for i=1:5
   filename = sprintf('radial_%d_100mm_2degree.mat',i); 
   temp = importdata(filename); 
   raw_data = temp.result;
   for j=1:6
       for k=1:46
           col = zeros(1,1);
           x=1;
           for l=1:35
              if raw_data(j,1,k).raw_data(l) < 200
                 col(x,1)=raw_data(j,1,k).raw_data(l);
                 x=x+1;
              end
           end
           data(i,j,k,:)=raw_data(j,1,k).raw_data;
           data_mean(i,j,k)=mean(col);
           %% plot_mean is the mean received intensity at all y(distance) and k(angle)
           plot_mean(y,k)=mean(col);
       end
       y=y+1;
   end
end

distance1=[0:10:50];
distance2=[87.9475:10:137.9475];
distance3= [176.53:10:226.53];
distance4= [264.795:10:314.795];
distance5= [353.06:10:403.06];
%%% distance is the x-axis vector
distance = [distance1,distance2,distance3,distance4,distance5]';
%distance(1,1)=10^(-20);
%% max_mean is the maximum received intensity at every distance.
[max_mean,max_idx] = max(plot_mean(:,3:46),[],2);
% distance_inv = distance.^(-2);
% for i=1:30
%     for j=1:46
%         phi = (270+(j-1)*2)/360*2*pi;
%         distance_para(i,j) = distance_inv(i,1)*cos(phi)/4/pi;
%     end
% end
% f = fittype({'x'});
% fit1 = fit(distance,max_mean,f);
% fdata = feval(fit1,distance);
% I = abs(fdata - max_mean) > 1.5*std(max_mean);
% outliers = excludedata(distance,max_mean,'indices',I);
% outliers(1,1)=1;
% outliers(8,1)=1;
% I = logical(outliers);
% fit2 = fit(distance,max_mean,f,'Exclude',outliers);
% fit3 = fit(distance,max_mean,f,'Robust','on');
scatter(distance,max_mean*408/2500)
xlabel('horizontal distance /cm')
ylabel('received power /lux')
title('received power vs horizontal distance at optimal angles')

plot(distance,plot_mean(:,1))

% hold on
% plot(fit2,'c--')
% plot(fit3,'b:')
% hold off

figure
rotate_idx = 270:2:360;
hold on
for i=10
   plot(rotate_idx,plot_mean(i,:)); 
end
hold off