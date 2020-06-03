clc;
close all;
clear all;
delete_timer;

disp("Wait until system are stable");
pause(2);

addpath_();

global app
global BEACONS
global FIR_FILTER EKF_FILTER PF_FILTER

addpath('/.');
addpath('/home/colson/catkin_ws/src/matlab_gen/msggen');
master_ip = "192.168.0.3";

rosshutdown();
rosinit(master_ip);




app.time_interval = 0.2;


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


BEACONS = beacon;
beacon_init(BEACONS, "", app.beacon_addr);

app.init_state1 = [0.45, -0.45, 0]';
app.tile_size = 0.45;
app.tile_num = 2;
app.dt = 0.2;

filter_init();



disp("Wait for full callback data");
pause(2);

tm = timer('BusyMode', 'drop', 'ExecutionMode', 'fixedRate', 'Period', app.time_interval, 'TimerFcn', {@timer_1});
start(tm);

