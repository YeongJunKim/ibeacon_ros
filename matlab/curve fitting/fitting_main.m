clc;
close all;
clear all;
addpath('./..');
addpath('/home/colson/catkin_ws/src/matlab_gen/msggen');
delete_timer;

disp("Wait until system are stable");
pause(2);

addpath_();

global app
global BEACONS
global FIR_FILTER EKF_FILTER PF_FILTER

master_ip = "http://192.168.0.18:11311";

rosshutdown();
rosinit(master_ip);





app.beacon_num = 4;
app.beacon_addr= cell(app.beacon_num,1);
app.beacon_addr{1} = "b4:52:a9:1b:55:20";
app.beacon_addr{2} = "b4:52:a9:1b:56:a7";
app.beacon_addr{3} = "50:51:a9:ff:8f:18";
app.beacon_addr{4} = "b4:52:a9:1a:a5:fc";


app.beacon_namespace = cell(app.beacon_num,1);
app.beacon_namespace{1} = "/beacon1";
app.beacon_namespace{2} = "/beacon2";
app.beacon_namespace{3} = "/beacon3";
app.beacon_namespace{4} = "/beacon4";

app.const_distance = zeros(app.beacon_num ,1);

app.const_distance(1) = sqrt((0.45*1)^2 + (0.45*12)^2);
app.const_distance(2) = sqrt((0.45*1)^2 + (0.45*13)^2);
app.const_distance(3) = sqrt((0.45*1)^2 + (0.45*14)^2);
app.const_distance(4) = sqrt((0.45*1)^2 + (0.45*15)^2);

app.savenumber = 10000;
app.fittingtable = cell(4, app.beacon_num, app.savenumber);

% mac adress  {["b4:52:a9:1b:55:20"]}    {["b4:52:a9:1b:56:a7"]}    {["50:51:a9:ff:8f:18"]}    {["b4:52:a9:1a:a5:fc"]}
% distance    {0×0 double           }    {0×0 double           }    {0×0 double           }    {0×0 double           }
% rssi        {0×0 double           }    {0×0 double           }    {0×0 double           }    {0×0 double           }
% txpower     {0×0 double           }    {0×0 double           }    {0×0 double           }    {0×0 double           }


for i = 1:app.beacon_num
    for j = 1:app.savenumber
        app.fittingtable{1,i,j} = app.beacon_addr{i};
    end
end






BEACONS = beacon;

beacon_init(BEACONS, "", app.beacon_addr);

disp("Wait for full callback data");
pause(2);

app.time_interval = 0.2;
tm = timer('BusyMode', 'drop', 'ExecutionMode', 'fixedRate', 'Period', app.time_interval, 'TimerFcn', {@fitting_timer});
start(tm);

