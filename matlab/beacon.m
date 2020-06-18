%% KOREA UNIVERCITY
%% author : colson@korea.ac.kr(dud3722000@naver.com)

classdef beacon < handle
    properties
        %% variable area
        %% TOPIC
        namespace = "";
        addrs = [];
        
        
        sub_beacon = [];
        
        sub_added = [];
        sub_type = [];
        sub_data = [];
        
        sub_imu_data;
        sub_scan_data;
        sub_beacon_data;
        
        
        %% gain
        
        
        %% USER DATA
        s;
        FactoryID = [];
        IbeaconID = [];
        Major = [];
        Minor = [];
        Mac = [];
        Txpower = [];
        RSSI = [];
        
        data = [];
        
        distance = [];
        
        alpha = [];
        beta = [];
        gamma = [];
        
    end
    methods
        %% function area
        function obj = beacon_init(obj, namespace, addrs)
            %% args
            % namespace  : each beacon's ROS namespace ex) (ROS_NAMESPACE=colsonbot roslaunch ~)
            
            %subscriber
            obj.namespace = namespace;
            obj.addrs = addrs;
            obj.s = size(addrs,1);
            obj.data(1).factoryid = 0;
            obj.distance = zeros(obj.s, 1);
            obj.sub_beacon = rossubscriber(strcat(namespace,'/beacon/info'), {@beacon_callback, obj});
        end
        
        function obj = beacon_addSubscrier(obj, topic, callback)
            obj.sub_type(obj.addcount).data = rossubscriber(topic, {callback, obj});
            obj.sub_added(obj.addcount).data = obj.sub_type;
            obj.addcount = obj.addcount + 1;
        end
        
        function r = beacon_getdistance_addr(obj, addr)
            for i = 1:obj.s
               if strcmp(obj.addrs{i}, addr)
                    obj.distance(i) = beacon_distance(-59, double(obj.data(i).rssi));
                    r = obj.distance(i);
               else
                   r = -1;
               end
            end
        end
        function r = beacon_getdistance_index(obj, index)
           obj.distance(index) = beacon_distance(-59, double(obj.data(index).rssi));
           r = obj.distance(index);
        end
    end
end

%% callback
function beacon_callback(src, msg, obj)
obj.sub_beacon_data = msg;
obj.sub_beacon_data;
it = size(obj.addrs,1) + 1;
for i = 1:it
   if strcmp(msg.Mac, obj.addrs{i})
%        disp("matched");
%        disp(i);
       break;
   end
end
if i == 5
    disp("there is no maching Mac addrs");
   return; 
end
% disp(i);
% obj.FactoryID(i) = msg.FactoryId;
obj.data(i).factoryid = msg.FactoryId;
obj.data(i).ibeaconid = msg.IbeaconId;
obj.data(i).major = msg.Major;
obj.data(i).minor = msg.Minor;
obj.data(i).mac = msg.Mac;
obj.data(i).txpower = msg.Txpower;
obj.data(i).rssi = msg.RSSI;

end






function r = beacon_distance(txPower, rssi)
    if rssi == 0
        r = -1;
        return;
    end
    ratio =rssi * 1.0 / txPower;
     
    if ratio < 0.5
       r = ratio^10;
       disp("1");
    else
        accuracy = (1.39976)*ratio^(2.8095) + 0.11;  
        r = accuracy;  
    end

end



