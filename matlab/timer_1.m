
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
   plot(0,0, 'o'); hold on;
   plot(0,0.9, 'o'); hold on;
   plot(0.9,0.9, 'o'); hold on;
   plot(0.9,0, 'o'); hold on;
end

disp(step);



BEACONS.data.rssi;


for i = 1:app.beacon_num
     distance(i) = calculateDistance(double(BEACONS.data(i).rssi));
     app.distance(i) = calculateDistance2(-59, double(BEACONS.data(i).rssi));
    app.distance(i) = beacon_getdistance_index(BEACONS, i);
end

app.filtered_distance = (0.5) * app.filtered_distance + (1-0.5) * app.distance;

% app.filtered_distance
    
z = [app.filtered_distance' 0]';
% state = FIR_PEFFME_run(FIR_FILTER(1).filter, 0, 1);

if(app.filteringflag == 1)
app.trajectory(:,step) = FIR_PEFFME_run(FIR_FILTER(1).filter, 0, [0,0]', z, 1);
disp(app.trajectory(:,step))
plot(app.trajectory(1,step), app.trajectory(2,step), 'o');
xlim([-2, 2]);
ylim([-2, 2]);
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
        accuracy = (1.39976)*ratio^(2.3095) + 0.061;  
        r = accuracy;  
    end

end

