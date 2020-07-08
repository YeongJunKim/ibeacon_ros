#!/usr/bin/env python
from bluepy.btle import Scanner, DefaultDelegate
from ibeacon_ros.msg import beacon_frame
import rospy
import array
import struct
import numpy as np

class ScanDelegate(DefaultDelegate):
    def __init__(self):
        DefaultDelegate.__init__(self)

    def handleDiscovery(self, dev, isNewDev, isNewData):
        dev.getScanData
        # if isNewDev:
        #     print "Discovered device", dev.addr
        # elif isNewData:
        #     print "Received new data from", dev.addr
  
if __name__ == '__main__':
    pub = rospy.Publisher('/beacon/info', beacon_frame, queue_size=1)
    print("ibeacon_bluepy")
    rospy.init_node('bluepy', anonymous=True)
    while(1):
        
        scanner = Scanner(iface=1).withDelegate(ScanDelegate())
        devices = scanner.scan(0.05)
        for dev in devices:
            #print "Device %s (%s), RSSI=%d dB" % (dev.addr, dev.addrType, dev.rssi)
            for (adtype, desc, value) in dev.getScanData():
                if desc == "Manufacturer":
                    value = value.encode('utf-8')
                    dev.addr = dev.addr.encode('utf-8')
                    if value[8:16] == "74278bda":
                        data = beacon_frame()
                        data.factory_id = value[0:8]
                        data.ibeacon_id = value[8:40]
                        data.major      = value[40:44]
                        data.minor      = value[44:48]
                        data.RSSI       = dev.rssi
                        data.txpower    = value[48:50]
                        data.mac        = dev.addr

                        print data
                        pub.publish(data)

            #print(dev.getScanData())
            # for (adtype, desc, value) in dev.getScanData():
            #     print "  %s = %s" % (desc, value)
            #     if desc == "Manufacturer":
            #         print value[8:14]
