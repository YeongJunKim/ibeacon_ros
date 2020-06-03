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
        
        
        
        %% USER DATA
        FactoryID = [];
        IbeaconID = [];
        Major = [];
        Minor = [];
        Mac = [];
        Txpower = [];
        RSSI = [];
        
        data = [];
        
    end
    methods
        %% function area
        function obj = beacon_init(obj, namespace, addrs)
            %% args
            % namespace  : each beacon's ROS namespace ex) (ROS_NAMESPACE=colsonbot roslaunch ~)
            
            %subscriber
            obj.namespace = namespace;
            obj.addrs = addrs;
            s = size(addrs,1);
            obj.sub_beacon = rossubscriber(strcat(namespace,'/beacon/info'), {@beacon_callback, obj});
        end
        function obj = beacon_addSubscrier(obj, topic, callback)
            obj.sub_type(obj.addcount).data = rossubscriber(topic, {callback, obj});
            obj.sub_added(obj.addcount).data = obj.sub_type;
            obj.addcount = obj.addcount + 1;
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










