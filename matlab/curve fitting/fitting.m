%% reference
%Improving BLE Distance Estimation and Classification Using TX Power and Machine Learning: A Comparative Analysis


%% Collect data from sampled data
clear all;
addpath("./sampled_data/");
listdir = dir("sampled_data/");

data_size_s = 3;
data_size_t = size(listdir);

data_arr = zeros(3,10000);
k = 0;
for i = data_size_s:data_size_t
    load(listdir(i).name);
    disp(listdir(i).name);
    for u = 1:app.beacon_num
        for j = 1:100
            k = k + 1;
            data_arr(1,k) = app.fittingtable{2,u,j};
            data_arr(2,k) = app.fittingtable{3,u,j};
            data_arr(3,k) = -59;
        end
    end
end


%% type rssi txpower distance
myfittype=fittype('a*(rssi/txpower)^b + c',...
'dependent', {'y'}, 'independent',{'rssi', 'txpower'},...
'coefficients', {'a','b','c'});

rssi = zeros(1, k);
txpower = zeros(1, k);
y = zeros(1, k);
rssi(:) = data_arr(2,1:k);
txpower(:) = data_arr(3,1:k);
y(:) = data_arr(1,1:k);

% rssi = [1 2 3 4 5 6 7 8 9 1 5 3 2]
% txpower = [1 2 3 4 5 6 7 8 9 1 5 3 2]
% y = [2 3 3 3 4 5 6 10 23 100 2 3 20] 

myfit=fit([rssi' txpower'],y',myfittype,'StartPoint',[0.3 3.5 0.08],'Lower', [0.1 1.5 0.04]);

disp(myfit);

interval = -80:1:-30
z = myfit.a * (interval / -59).^myfit.b + (myfit.c);
zz = 0.89976 * (interval / -59).^7.7095 + (0.111);

plot(interval,z, 'b-*'); hold on;
plot(interval,zz, 'c-*'); hold on;
plot(rssi,y, 'o');
legend('get', 'ref', 'collected');


% rssi = [-115 -84 -81 -77 -72 -69 -65 -59]
% txpower = [0 1 2 3 4 5 6 7]
% y = [2 4 10 20 30 40 60 70] 
%plot(myfit)