
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

for i = 1:app.beacon_num
   app.fittingtable{2,i,step} = BEACONS.data(i).rssi;
   app.fittingtable{3,i,step} = BEACONS.data(i).txpower;
   app.fittingtable{4,i,step} = app.const_distance(i);
end

step = step + 1;
end



