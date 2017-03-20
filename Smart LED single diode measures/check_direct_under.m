%% process data low
clear
load('direct_under_low_50mm_10degree.mat');
data = [result.raw_data];
rotation = [result.rotation_y];
distance = [result.distance];
std_check = [];

for i = 1:size(data,2)
    samples = data(:,i);
    samples = samples(find(samples < 5000));   
    samples = samples(1:end-3);     % kick out invalid values
    std_check = [std_check std(samples)];
end

% view std distribution
% std_check;
% plot(std_check,'-o');

check = std_check > 2.5;
check = reshape(check,size(distance,2)/36,[]);
x = [0 350];
y = 219.71 - [17.78 17.78+50];
subplot(3,1,3);
imagesc(x, y, check);
xlabel('Angle /degree');
title('Check for Outliers - Low');



%% process data high
clear
load('direct_under_high_50mm_10degree.mat');
data = [result.raw_data];
rotation = [result.rotation_y];
distance = [result.distance];
data = [result.raw_data];
rotation = [result.rotation_y];
distance = [result.distance];
std_check = [];

for i = 1:size(data,2)
    samples = data(:,i);
    samples = samples(find(samples < 5000));   
    samples = samples(1:end-3);     % kick out invalid values
    std_check = [std_check std(samples)];
end

% view std distribution
% std_check;
% plot(std_check,'-o');

check = std_check > 2.5;
check = reshape(check,size(distance,2)/36,[]);
x = [0 350];
y = 219.71 - [72.34 72.34+50];
subplot(3,1,2);
imagesc(x, y, check);
ylabel('Distance from Lightsource /cm');
title('Check for Outliers - High');

%% process data higher
clear
load('direct_under_higher_50mm_10degree.mat');
data = [result.raw_data];
rotation = [result.rotation_y];
distance = [result.distance];
data = [result.raw_data];
rotation = [result.rotation_y];
distance = [result.distance];
std_check = [];

for i = 1:size(data,2)
    samples = data(:,i);
    samples = samples(find(samples < 5000));   
    samples = samples(1:end-3);     % kick out invalid values
    std_check = [std_check std(samples)];
end

% view std distribution
% std_check;
% plot(std_check,'-o');

check = std_check > 2.5;
check = reshape(check,size(distance,2)/36,[]);
x = [0 350];
y = 219.71 - [124.46 124.46+45];
subplot(3,1,1);
imagesc(x, y, check);
title('Check for Outliers - Higher');
    

