%% reference
%Improving BLE Distance Estimation and Classification Using TX Power and Machine Learning: A Comparative Analysis
%% type rssi txpower distance
myfittype=fittype('a*(rssi*d/txpower)^b + c',...
'dependent', {'y'}, 'independent',{'rssi', 'txpower'},...
'coefficients', {'a','b','c','d'});
rssi = [1 2 3 4 5 6 7 8 9 1 5 3 2]
txpower = [1 2 3 4 5 6 7 8 9 1 5 3 2]
y = [2 3 3 3 4 5 6 10 23 100 2 3 20] 
myfit=fit([rssi' txpower'],y',myfittype,'StartPoint',[1 1 1 1])

% rssi = [-115 -84 -81 -77 -72 -69 -65 -59]
% txpower = [0 1 2 3 4 5 6 7]
% y = [2 4 10 20 30 40 60 70] 
plot(myfit)
%% type test
myfittype=fittype('a +b*log(x)',...
'dependent', {'y'}, 'independent',{'x'},...
'coefficients', {'a','b'});
x = [1 2 3 4 5 6 7 8 9 1 5 3 2]
y = [2 3 3 3 4 5 6 10 23 100 2 3 20] 
myfit=fit(x',y',myfittype,'StartPoint',[1 1])

plot(myfit)