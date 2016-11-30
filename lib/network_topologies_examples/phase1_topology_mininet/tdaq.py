#!/usr/bin/env python

from mininet.topo import Topo
from mininet.cli import CLI
from mininet.net import Mininet
from mininet.node import RemoteController, OVSKernelSwitch
from mininet.log import setLogLevel


class TdaqTopo( Topo ):
    """Create a leaf spine topology"""
	
    def build( self, roSeg=2, roSegHosts=2, sdxHostCount=2 ):
        SWDPID    = 1000000000000000
        HSWDPID   = 2000000000000000
        SEGMOD    = 100
        LOCMOD    = 10000
        ROSEGMENT = 1
        USA15DEV  = 2
        SDXDEV    = 3
        roSegment = []
        roSegmentHosts = []
        usa15Spines = []
        sdxSpines = []
        sdxHostSwitch = []

        # Create the spine switches
        usa15Spines.append(self.addSwitch('usa15s1', dpid='%d' % (SWDPID + LOCMOD*USA15DEV + 1)))
        usa15Spines.append(self.addSwitch('usa15s2', dpid='%d' % (SWDPID + LOCMOD*USA15DEV + 2)))
        sdxSpines.append(self.addSwitch('sdxs1', dpid='%d' % (SWDPID + LOCMOD*SDXDEV + 1)))
        sdxSpines.append(self.addSwitch('sdxs2', dpid='%d' % (SWDPID + LOCMOD*SDXDEV + 2)))
        
        self.addLink(usa15Spines[0], sdxSpines[0])
        self.addLink(usa15Spines[0], sdxSpines[1])
        self.addLink(usa15Spines[1], sdxSpines[0])
        self.addLink(usa15Spines[1], sdxSpines[1])

        # Create roSegments
        for i in range(1, roSeg+1):
            roSwitch = []
            roHostSwitch = []
            print SWDPID
            roSwitch.append(self.addSwitch('seg%dsw%d' % (i, 1), dpid='%d' % (SWDPID + LOCMOD*ROSEGMENT + i*SEGMOD + 1)))
            roSwitch.append(self.addSwitch('seg%dsw%d' % (i, 2), dpid='%d' % (SWDPID + LOCMOD*ROSEGMENT + i*SEGMOD + 2)))
            self.addLink(roSwitch[0], roSwitch[1])
            self.addLink(roSwitch[0], usa15Spines[0])
            self.addLink(roSwitch[1], usa15Spines[1])
            for j in range(1, roSegHosts+1):
                roHostSwitch.append(self.addSwitch('swhseg%dh%d' % (i, j), dpid='%d' % (HSWDPID + LOCMOD*ROSEGMENT + SEGMOD*i + j)))
                host = self.addHost('seg%dh%d' % (i, j), ip='10.%d.%d.%d' % (ROSEGMENT, i, j))
                self.addLink(roHostSwitch[j-1], host)
                self.addLink(roHostSwitch[j-1], roSwitch[0])
                self.addLink(roHostSwitch[j-1], roSwitch[1])
        
        # Create the SDX hosts
        for i in range(1, sdxHostCount +1):
            sdxHostSwitch.append(self.addSwitch('swhsdx%d' % i, dpid='%d' % (HSWDPID + LOCMOD*SDXDEV + i)))
            host = self.addHost('sdxh%d' % (i), ip='10.%d.0.%d' % (SDXDEV, i))
            self.addLink(sdxHostSwitch[i-1], host)
            self.addLink(sdxHostSwitch[i-1], sdxSpines[0])
            self.addLink(sdxHostSwitch[i-1], sdxSpines[1])
        

        # Create two links between the spine switches
        #self.addLink(spines[0], spines[1])
        #TODO add second link between spines when multi-link topos are supported
        #self.addLink(spines[0], spines[1])
        
        # Now create the leaf switches, their hosts and connect them together
        #i = 1
        #c = 0
       # while i <= k:
       #     leaves.append(self.addSwitch('s1%d' % i))
       #     for spine in spines:
       #         self.addLink(leaves[i-1], spine)

       #     j = 1
       #     while j <= h:
       #         hosts.append(self.addHost('h%d%d' % (i, j), ip='192.168.%d.%d' %(i, j)))
       #         self.addLink(hosts[c], leaves[i-1])
       #         j+=1
       #         c+=1

       #     i+=1

topos = { 'tdaq': TdaqTopo }



def run():
    topo = TdaqTopo()
    net = Mininet( topo=topo, controller=RemoteController, autoSetMacs=True )
    net.start()
    CLI( net )
    net.stop()

if __name__ == '__main__':
    setLogLevel( 'info' )
    run()
