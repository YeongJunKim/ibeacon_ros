
function timer_1(obj, event)

global BEACONS
global FIR_FILTER
global app

persistent firstRun;
persistent step;

if isempty(firstRun)
    disp("init timer");
    
    disp("Wait for stable");
    firstRun = 1;
    step = 1;
    pause(1);
end

disp(step);

if step <= 100
    for i = 1:app.beacon_num
        app.fittingtable{2,i,step} = app.const_distance(i);
        app.fittingtable{3,i,step} = BEACONS.data(i).rssi;
        app.fittingtable{4,i,step} = BEACONS.data(i).txpower;
    end
    
else
    file_name = string(datetime('now'))
    file_name = strcat(file_name, "_");
    if(app.beacon_num > 1)
        file_name = strcat(file_name, 'multiple beacon');
    else
        file_name = strcat(file_name, app.fittingtable{1,1,1});
    end
    file_name = strcat(file_name, "_raw data.mat");
    
    save(file_name, 'app');
    
    
    delete_timer;
end





step = step + 1;
end



