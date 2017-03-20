% process data low
clear

addpath('raw_data/');

load('direct_under_low_50mm_10degree.mat');
data = [result.raw_data]* 408/2500;     % convert raw data to lux
rotation = [result.rotation_y];
distance = [result.distance];
mean_data = [];
std_data = [];

for i = 1:size(data,2)
    samples = data(:,i);    % take all 168 samples
%     samples = data(1:10,i);   % only take the first 10 samples
    samples = samples(find(samples < 5000));
    samples = samples(find(samples > 2));
    mean_data = [mean_data mean(samples)];
    std_data = [std_data std(samples)];
end

process_mean_data_low = reshape(mean_data,size(distance,2)/36,[]);
process_std_data_low = reshape(std_data,size(distance,2)/36,[]);
% save('direct_under_process_data_low.mat','process_data_low');

% process data high
load('direct_under_high_50mm_10degree.mat');
data = [result.raw_data]* 408/2500;     % convert raw data to lux
rotation = [result.rotation_y];
distance = [result.distance];
mean_data = [];
std_data = [];

for i = 1:size(data,2)
    samples = data(:,i);    % take all 168 samples
%     samples = data(1:10,i);   % only take the first 10 samples
    samples = samples(find(samples < 5000));
    samples = samples(find(samples > 2));
    mean_data = [mean_data mean(samples)];
    std_data = [std_data std(samples)];
end

process_mean_data_high = reshape(mean_data,size(distance,2)/36,[]);
process_std_data_high = reshape(std_data,size(distance,2)/36,[]);
% save('direct_under_process_data_high.mat','process_data_high');

% process data higher
load('direct_under_higher_50mm_10degree.mat');
data = [result.raw_data]* 408/2500;     % convert raw data to lux
rotation = [result.rotation_y];
distance = [result.distance];
mean_data = [];
std_data = [];

for i = 1:size(data,2)
    samples = data(:,i);    % take all 168 samples
%     samples = data(1:10,i);   % only take the first 10 samples
    samples = samples(find(samples < 5000));
    samples = samples(find(samples > 2));
    mean_data = [mean_data mean(samples)];
    std_data = [std_data std(samples)];
end

process_mean_data_higher = reshape(mean_data,size(distance,2)/36,[]);
process_std_data_higher = reshape(std_data,size(distance,2)/36,[]);
% save('direct_under_process_data_higher.mat','process_data_higher');


% all means saved to this matrix: columns - degrees, rows - distances
process_mean_data = [process_mean_data_low;process_mean_data_high;process_mean_data_higher];
% all standard deviations saved to this matrix: columns - degrees, rows - distances
process_std_data = [process_std_data_low;process_std_data_high;process_std_data_higher];

%% process data fix
%89 cm from the lightbulb
%clear
% load('fix_distance_1degree.mat');
% data = [];
% 
% for j = 1:360
% data_temp = result(j).raw_data;
% data = [data_temp(1:33) data];
% end
% 
% rotation = [result(:).rotation_y];
% mean_data = [];
% std_data = [];
% 
% for i = 1:size(data,2)
%     samples = data(:,i);    % take all 33 samples
%     samples = samples(find(samples < 5000));
%     samples = samples(find(samples > 10));
%     std_data = [std_data std(samples)];
%     mean_data = [mean_data mean(samples)];
% end
% 
% process_data_fix = mean_data * 408/2500;     % convert to lux;
% % save('direct_under_process_data_fix.mat','process_data_fix');
    

