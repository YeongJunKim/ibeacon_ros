
function timer_1(obj, event)

global BEACONS
global FIR_FILTER
global app

persistent firstRun;
persistent step;

if isempty(firstRun)
   disp("init timer");
   
   app.distance = zeros(app.beacon_num,1);
   app.filtered_distance = zeros(app.beacon_num,1);
   app.trajectory = zeros(3,1000);
   step = 1;
   firstRun = 1; 

   figure(1);    
   clf;
   edge = app.tile_num * app.tile_size;
   plot(0,0, 'o', 'MarkerSize', 10); hold on;
   plot(0,edge, 'o', 'MarkerSize', 10); hold on;
   plot(edge,edge, 'o', 'MarkerSize', 10); hold on;
   plot(edge,0, 'o', 'MarkerSize', 10); hold on;
end

disp(step);



BEACONS.data.rssi;


for i = 1:app.beacon_num
%      distance(i) = calculateDistance(double(BEACONS.data(i).rssi));
%      app.distance(i) = calculateDistance2(-59, double(BEACONS.data(i).rssi));
    app.distance(i) = beacon_getdistance_index(BEACONS, i);
end
fprintf("distance : %f,%f,%f,%f\n",app.distance(1),app.distance(2), app.distance(3), app.distance(4));


app.filtered_distance = (0.5) * app.filtered_distance + (1-0.5) * app.distance;

% app.filtered_distance
    
z = [app.filtered_distance' 0]';
% state = FIR_PEFFME_run(FIR_FILTER(1).filter, 0, 1);

if(app.filteringflag == 1)
app.trajectory(:,step) = FIR_PEFFME_run(FIR_FILTER(1).filter, 0, [0,0]', z, 1);
disp(app.trajectory(:,step));
plot(app.trajectory(1,step), app.trajectory(2,step), 'o');
xlim([-0.2, 5]);
ylim([-0.2, 5]);
drawnow;
end

% disp(app.distance);



step = step + 1;
end


function r = calculateDistance(rssi) 
  
  txPower = -72;
  
  if (rssi == 0) 
    r = -1.0;
    return;
  
  end
  ratio = rssi*1.0/txPower;
  if (ratio < 1.0) 
    r =ratio^(10);
    return;
  
  else
    distance = (0.89976)*ratio^(7.7095) + 0.111;    
    r = distance;
  
  end
end

function r = calculateDistance2(txPower, rssi)
    if rssi == 0
        r = -1;
        return;
    end
    ratio =rssi * 1.0 / txPower;
     
    if ratio < 0.5
       r = ratio^10;
       disp("1");
    else
        accuracy = (3.4)*ratio^(7) + 0.11;  
        r = accuracy;  
    end

end

