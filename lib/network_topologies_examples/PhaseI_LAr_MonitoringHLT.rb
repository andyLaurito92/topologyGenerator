# topology plotted here: https://docs.google.com/presentation/d/1N5GnG82JvsASUJ6sl-gmuMBRjMWG6OWtybIjOMikb-M/edit#slide=id.p

module NetworkTopology 
    # constants
    K = 1000  # Kilo=10³
    M = 1000 * K  # Megas=10⁶
    G = 1000 * M  # Megas=10⁶
    
    TCP_MTU_bytes = 1500 # (in bytes)
    
    # parameters
    NUMBER_OF_FELIX_SERVERS = 13 # this generates 1:1 connections with sw_rod, so NUMBER_OF_FELIX_SERVERS=numberOfSWRODServers
    #NUMBER_OF_FELIX_SERVERS = 3 # this generates 1:1 connections with sw_rod, so NUMBER_OF_FELIX_SERVERS=numberOfSWRODServers
    NUMBER_OF_MONITORING_SERVERS = 5
    LINK_BW_40G_BITS_S =   40  * G # 40 Gbps
    LINK_BW_10G_BITS_S =   1  * G # 10 Gbps
    FELIX_FLOW_PRIORITY = 0    
    FELIX_GBT_ELINKS = 10 # #GBT e-links in each felix server. There will be one flow created per e-link (because there will be 1 thread, one connection per e-link)
    
    # felix data-flow distributions (one per GBT)
    FELIX_GBT_PERIOD_sec = ExponentialDistribution.new 1.0 / (100*K) # distribution period in seconds
    #FELIX_GBT_PERIOD_sec = ExponentialDistribution.new 1.0 / (100) #TODO: this is just for testing quick simulations. Normal rate should be 100*k
    FELIX_GBT_SIZE_bytes = NormalDistribution.new 4.0*K, 1.0*K  # (in bytes)
    FELIX_GBT_BUFFER_bytes = 1*M  # (in bytes)
    FELIX_GBT_TIME_OUT_sec = 2  # (in seconds)
    FELIX_GBT_OUT_SIZE_bytes =  TCP_MTU_bytes # (in bytes)
    
    #FELIX_GENERATION_PERIOD = ExponentialDistribution.new (1.0 * FELIX_GBT_ELINKS) / (70*M)     # distribution period in seconds
    #FELIX_GENERATION_PERIOD = ExponentialDistribution.new (1.0 * FELIX_GBT_ELINKS) / (1*M)      # distribution period in seconds
    #FELIX_GENERATION_SIZE = ConstantDistribution.new 1.0*K                                 #distribution size in bits
    FELIX_GENERATION_PERIOD = FelixDistribution.new FELIX_GBT_PERIOD_sec, 
                                                    FelixDistribution::FELIX_MODE_HIGH_THROUGHOUT,
                                                    FELIX_GBT_SIZE_bytes,
                                                    FELIX_GBT_BUFFER_bytes,
                                                    FELIX_GBT_TIME_OUT_sec,
                                                    FELIX_GBT_OUT_SIZE_bytes
    FELIX_GENERATION_SIZE = ConstantDistribution.new TCP_MTU_bytes*8  #distribution size in bits
    
    # monitoring flows (one per GBT)
    FELIX_MONITORING_PRIORITY = 0
    MONITORING_SIZE_bits = (TCP_MTU_bytes - 300)*8  
    TOTAL_MONITORING_PER_SERVER_bits = 0.8 * G
    MONITORING_GENERATION_PERIOD = ExponentialDistribution.new 1.0 / (TOTAL_MONITORING_PER_SERVER_bits /  (MONITORING_SIZE_bits * FELIX_GBT_ELINKS))
    MONITORING_GENERATION_SIZE = NormalDistribution.new MONITORING_SIZE_bits, 300*8  #distribution size in bits
      
    def get_topology 
      return @topology.topology_elements if @topology.topology_elements.size != 0 
      
      @felix_servers = [] 
      @sw_rod_servers = []
      @routers = [] 
      @links = []
      @monitoring_servers = []  
      

      # switches & routers 
      @routers.push @topology.add_router "lar_switch_01", [1] 
      @routers.push @topology.add_router "lar_switch_02", [1] 
      @routers.push @topology.add_router "felix_core_01", [1]  # core_01 router in the felix network (connection out of USA15) 
      @routers.push @topology.add_router "felix_core_02", [1]  # core_01 router in the felix network (connection out of USA15)
      @routers.push @topology.add_router "hlt_core_01", [1]  # core_01 router in the HLT network (connection into of SDX1) 
      @routers.push @topology.add_router "hlt_core_02", [1]  # core_02 router in the HLT network (connection into of SDX1)
            
      # Felix servers
      for i in 0..NUMBER_OF_FELIX_SERVERS-1
        @felix_servers.push @topology.add_host "lar_felix_#{i}"     
        
        # connected to both switches
        @links.push @topology.add_link "link_felix#{i}_switch1", @felix_servers[i], 0, @routers[0], i+1, LINK_BW_40G_BITS_S  # lar_felix_{i} --> lar_switch_01
        @links.push @topology.add_link "link_felix#{i}_switch2", @felix_servers[i], 1, @routers[1], i+1, LINK_BW_40G_BITS_S  # lar_felix_{i} --> lar_switch_02
      end
      
      # SWROD servers
      for i in 0..NUMBER_OF_FELIX_SERVERS-1
        @sw_rod_servers.push @topology.add_host "lar_swrod_#{i}"     
        
        # connected to both switches
        @links.push @topology.add_link "link_switch1_swrod#{i}", @routers[0], i+1, @sw_rod_servers[i], 0, LINK_BW_40G_BITS_S # lar_switch_01 --> lar_swrod_{i}
        @links.push @topology.add_link "link_switch2_swrod#{i}", @routers[1], i+1, @sw_rod_servers[i], 1, LINK_BW_40G_BITS_S # lar_switch_02 --> lar_swrod_{i}        
      end
      
      # links between the switches and routers (only 1 link as they will be active-backup: there will be physically 2 links but only one active)
      @links.push @topology.add_link "link_sw1_core1", @routers[0], 0, @routers[2], 0, LINK_BW_40G_BITS_S  # lar_switch_1 --> lar_core_1
      @links.push @topology.add_link "link_sw2_core2", @routers[1], 0, @routers[3], 0, LINK_BW_40G_BITS_S  # lar_switch_2 --> lar_core_2      
      @links.push @topology.add_link "link_core1_hltcore1", @routers[2], 0, @routers[4], 0, LINK_BW_40G_BITS_S  # lar_core_1 --> hlt_core_1
      @links.push @topology.add_link "link_core2_hltcore2", @routers[3], 0, @routers[5], 0, LINK_BW_40G_BITS_S  # lar_core_2 --> hlt_core_2 
      
      # Monitoring servers      
      for i in 0..NUMBER_OF_MONITORING_SERVERS-1
        @monitoring_servers.push @topology.add_host "lar_mon_#{i}"     
        
        # connected to 1 hlt_core (the other link will be backup (inactive) )       
        #if i % 2 == 0 then hlt_core_index = 1 else hlt_core_index = 2 end # half the monitoring servers will be connected to one core (hltcore_1), the others will be connected to the other (hltcore_2)
        #TODO: we add both links, but only 1 will be used (see flow definitions)  
        @links.push @topology.add_link "link_htlcore1_mon#{i}", @routers[4], i, @monitoring_servers[i], 0, LINK_BW_10G_BITS_S   # hlt_core1 --> mon_{i}
        @links.push @topology.add_link "link_htlcore2_mon#{i}", @routers[5], i, @monitoring_servers[i], 1, LINK_BW_10G_BITS_S   # hlt_core2 --> mon_{i}
      end
      
           
      # flow 1Felix:1ROD
      add_flows_oneFelix_to_oneSWROD
      
      print ("finished the topology specification \n")
      @topology.topology_elements 
    end 
    
    def add_flows_oneFelix_to_oneSWROD
      # data-flow Flows for each felix server
      @felix_servers.each_with_index do |felix,index|
         # NFelix:1mon: A group of N felix servers will always talk with the same mon server. N=#felix/#mon
         monServer_index = index % NUMBER_OF_MONITORING_SERVERS # first N will all go to different mon. Then, with n+1, it starts again.
                 
         # each felix will have 1 data-flow and 1 monitoring-flow per e-link
         for eLinkIndex in 0..FELIX_GBT_ELINKS-1
           # Data-Flow path
           path = Path.new felix, @sw_rod_servers[index]
           if eLinkIndex % 2 == 0 then switchIndex = 1 else switchIndex = 2 end # half the flows with go one path (switch_1), the other will go the other path (switch_2) 
           path.add_link @topology.get_element_by_id "link_felix#{index}_switch#{switchIndex}"  # felix{i} -> switch_{1/2}
           path.add_link @topology.get_element_by_id "link_switch#{switchIndex}_swrod#{index}"  # switch_1 --> lar_swrod{i}
           
           @topology.add_flow "Flow#{index}_#{eLinkIndex}", FELIX_FLOW_PRIORITY, [path], FELIX_GENERATION_PERIOD, FELIX_GENERATION_SIZE
           
           # Monitoring-flow path will go always to same monServer, but half by switch_1 and half by switch_2
           path = Path.new felix, @sw_rod_servers[index]            
           path.add_link @topology.get_element_by_id "link_felix#{index}_switch#{switchIndex}"  # felix{i} -> switch_{1/2}
           path.add_link @topology.get_element_by_id "link_sw#{switchIndex}_core#{switchIndex}"  # switch_{1/2} --> lar_core{1/2}
           path.add_link @topology.get_element_by_id "link_core#{switchIndex}_hltcore#{switchIndex}"  # lar_core{1/2} --> hlt_core{1/2}
           path.add_link @topology.get_element_by_id "link_htlcore#{switchIndex}_mon#{monServer_index}"  # hlt_core{1/2} --> mon{monServer_index}
                    
           @topology.add_flow "FlowMon#{index}_#{eLinkIndex}", FELIX_MONITORING_PRIORITY, [path], MONITORING_GENERATION_PERIOD, MONITORING_GENERATION_SIZE
         end
     end
    end

    def get_path_between(source, destination) 
      raise NotImplementedError, "NetworkTopology: This method is not implemented (¿does it ever get called?)"      
   end 
end