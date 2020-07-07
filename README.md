# ibeacon_ros
beacon_data_topic_publisher

## Preparations
##### download
``` bash
cd \your catkin workspace
git clone https://www.github.com/YeongJunKim/ibeacon_ros
```
##### pre-install
``` bash
sudo apt-get install libbluetooth-dev
sudo apt-get install python-pip
```
##### pip module
``` bash
sudo pip install bluepy
```
##### other application
https://github.com/jm-szlendak/robot-ble-localization.git
##### &
iBeacon-Scanner-
##### permission
``` bash
sudo setcap 'cap_net_raw,cap_net_admin+eip' file
sudo setcap 'cap_net_raw,cap_net_admin+eip' `which hcitool`
sudo setcap 'cap_net_raw,cap_net_admin+eip' /usr/local/lib/python2.7/dist-packages/bluepy/bluepy-helper
```
##### python pip localtion
``` bash
pip show bluepy
```
### Genertate Matlab Message
Run message_gen.m in ./matlab. Then follow up custom meesage guild in Command Window.



## Execution
### Beacon scanner
Get Beacon data from hci & publish.
``` bash
rosrun ibeacon_ros bluepy_scan.py
```
Message.
``` bash
factory_id: "4c000215"
ibeacon_id: "74278bdab64445208f0c720e00000003"
major: "0091"
minor: "0091"
mac: "50:51:a9:ff:8f:18"
txpower: "c5"
RSSI: -54
factory_id: "4c000215"
ibeacon_id: "74278bdab64445208f0c720e00000002"
major: "0001"
minor: "0091"
mac: "b4:52:a9:1b:56:a7"
txpower: "c5"
RSSI: -55
factory_id: "4c000215"
ibeacon_id: "74278bdab64445208f0c720e00000001"
major: "0001"
minor: "0001"
mac: "b4:52:a9:1b:55:20"
txpower: "c5"
RSSI: -58
factory_id: "4c000215"
ibeacon_id: "74278bdab64445208f0c720e00000002"
major: "0001"
minor: "0091"
mac: "b4:52:a9:1b:56:a7"
txpower: "c5"
RSSI: -58
...
```


### Curve fitting beacon rssi - tx power model
If you want to curve fitting for your own beacon device, Then follow up this section.
##### 1. Excute ROS node.
``` bash
rosrun ibeacon_ros bluepy_scan.py
```
##### 2. Run fitting in matlab environment.
Run matlab file: ./matlab/curve fitting/fitting_main.m
###### tip. You need to change beacon information in 'fitting_main.m'
``` matlab
- in ./matlab/curve fitting/fitting_main.m
- You need to change beacon_addr{:}.
app.beacon_num = 4;
app.beacon_addr= cell(app.beacon_num,1);
app.beacon_addr{1} = "11:22:33:44:55:66";
app.beacon_addr{2} = "b4:52:a9:1b:56:11";
app.beacon_addr{3} = "50:55:a9:11:8f:33";
app.beacon_addr{4} = "b4:52:a9:1a:33:f2";
```
##### 3. Run fitting.
Run matlab file: ./matlab/curve fitting/fitting.m
