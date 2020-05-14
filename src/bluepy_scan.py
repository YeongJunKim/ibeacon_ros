#!/usr/bin/env python
from bluepy.btle import Scanner, DefaultDelegate


class ScanDelegate(DefaultDelegate):
    def __init__(self):
        DefaultDelegate.__init__(self)

    def handleDiscovery(self, dev, isNewDev, isNewData):
        dev.getScanData
        # if isNewDev:
        #     print "Discovered device", dev.addr
        # elif isNewData:
        #     print "Received new data from", dev.addr

while(1):
    scanner = Scanner().withDelegate(ScanDelegate())
    devices = scanner.scan(0.05)
    for dev in devices:
        #print "Device %s (%s), RSSI=%d dB" % (dev.addr, dev.addrType, dev.rssi)
        for (adtype, desc, value) in dev.getScanData():
            if desc == "Manufacturer":
                if value[8:14] == "74278b":
                    print value
                    print dev.addr
                    print dev.rssi

        #print(dev.getScanData())
        
        
        # for (adtype, desc, value) in dev.getScanData():
        #     print "  %s = %s" % (desc, value)
        #     if desc == "Manufacturer":
        #         print value[8:14]

        