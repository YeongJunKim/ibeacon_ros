# ibeacon_ros
beacon_data_topic_publisher


##### pre-install
```
sudo apt-get install libbluetooth-dev
sudo apt-get install python-pip
```

##### pip module
```
sudo pip install bluepy
```



##### other application
https://github.com/jm-szlendak/robot-ble-localization.git


##### &
iBeacon-Scanner-


##### permission
```
sudo setcap 'cap_net_raw,cap_net_admin+eip' file
sudo setcap 'cap_net_raw,cap_net_admin+eip' `which hcitool`
sudo setcap 'cap_net_raw,cap_net_admin+eip' /usr/local/lib/python2.7/dist-packages/bluepy/bluepy-helper
```

##### python pip localtion
```
pip show bluepy
```