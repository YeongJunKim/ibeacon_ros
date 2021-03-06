%% reference
%Improving BLE Distance Estimation and Classification Using TX Power and Machine Learning: A Comparative Analysis


%% Collect data from sampled data
clear all;
clf;
addpath("./2020-07-08-sampled_data/");
listdir = dir("2020-07-08-sampled_data/");

data_size_s = 3;
data_size_t = size(listdir);
load(listdir(3).name);
data_arr = zeros(3,4,100000);
k = zeros(4,1);

graph3d = zeros(200,200,4);

for i = data_size_s:data_size_t
    count = 1;
    load(listdir(i).name);
    disp(listdir(i).name);
    for u = 1:app.beacon_num
        for j = 1:100
            k(u) = k(u) + 1;
            data_arr(1,u,k(u)) = app.fittingtable{2,u,j};
            data_arr(2,u,k(u)) = app.fittingtable{3,u,j};
            data_arr(3,u,k(u)) = -59;
        end
    end
end


%% type rssi txpower distance
myfittype=fittype('a*(rssi/txpower)^b + c',...
'dependent', {'y'}, 'independent',{'rssi', 'txpower'},...
'coefficients', {'a','b','c'});

figure(1);
clf
title_name = [app.fittingtable(1,1,1), app.fittingtable(1,2,1), app.fittingtable(1,3,1), app.fittingtable(1,4,1)];
for i = 1:app.beacon_num
    subplot(2,2,i);
    
    rssi = zeros(1, k(i));
    txpower = zeros(1, k(i));
    y = zeros(1, k(i));
    
    rssi(:) = data_arr(2,i,1:k(i));
    txpower(:) = data_arr(3,i,1:k(i));
    y(:) = data_arr(1,i,1:k(i));
    
    % rssi = [1 2 3 4 5 6 7 8 9 1 5 3 2]
    % txpower = [1 2 3 4 5 6 7 8 9 1 5 3 2]
    % y = [2 3 3 3 4 5 6 10 23 100 2 3 20] 

    myfit=fit([rssi' txpower'],y',myfittype,'StartPoint',[3 0 0.05],'Lower', [0.1 5 0.05], 'Upper', [5 8 0.11]);

    disp(myfit);

    interval = -80:1:-30;
    z = myfit.a * (interval / -59).^myfit.b + (myfit.c);
    zz = 0.89976 * (interval / -59).^7.7095 + (0.111);
    
    plot(interval,z, 'b-*'); hold on;
    plot(interval,zz, 'c-*'); hold on;
    plot(rssi,y, 'o');
    xlim([-80,-30]);
    ylim([0,8]);
    title(title_name(i));
    description = strcat("coefficients: a, b, c = ",num2str(myfit.a));
    description = strcat(description,", ");
    description = strcat(description,num2str(myfit.b));
    description = strcat(description,", ");
    description = strcat(description,num2str(myfit.c));
    description = strcat(description,", ");   
    xlabel(description);
    legend('get', 'ref', 'collected');
end




% rssi = [-115 -84 -81 -77 -72 -69 -65 -59]
% txpower = [0 1 2 3 4 5 6 7]
% y = [2 4 10 20 30 40 60 70] 
%plot(myfit)