module NetworkTopology 
    # constants
    K = 1000  # Kilo=10³
    M = 1000 * K  # Megas=10⁶
    G = 1000 * M  # Megas=10⁶
    
    # parameters
    NUMBER_OF_FELIX_SERVERS = 2 # this generates 1:1 connections with sw_rod, so NUMBER_OF_FELIX_SERVERS=numberOfSWRODServers
    LINK_BW_BITS_S =   40  * G # 40 Gbps
    FELIX_GENERATION_PERIOD = ExponentialDistribution.new 1/10.0 # distribution period in seconds
    FELIX_GENERATION_SIZE = ConstantDistribution.new 1.0*K  #distribution size in bits
    FELIX_MONITORING_GENERATION_PERIOD = ExponentialDistribution.new 1/20.0 # distribution period in seconds
    FELIX_MONITORING_GENERATION_SIZE = ConstantDistribution.new 500  #distribution size in bits
    FELIX_CONTROL_GENERATION_PERIOD = ExponentialDistribution.new 1/15.0 # distribution period in seconds
    FELIX_CONTROL_GENERATION_SIZE = ConstantDistribution.new 100  #distribution size in bits
    FELIX_FLOW_PRIORITY = 0
    
      
    def get_topology 
      return @topology.topology_elements if @topology.topology_elements.size != 0 
      
      @felix_servers = [] 
      @sw_rod_servers = []
      @routers = [] 
      @links = []
      

      # switches & routers 
      @routers.push @topology.add_router "lar_switch_01", [1] 
      @routers.push @topology.add_router "lar_switch_02", [1] 
      @routers.push @topology.add_router "felix_core_01", [1]  # core_01 router in the felix network (connection out of USA15) 
      @routers.push @topology.add_router "felix_core_02", [1]  # core_01 router in the felix network (connection out of USA15)
            
      # Felix servers
      for i in 0..NUMBER_OF_FELIX_SERVERS-1
        @felix_servers.push @topology.add_host "lar_felix_#{i}"     
        
        # connected to both switches
        @links.push @topology.add_link "link_felix#{i}_switch1", @felix_servers[i], 0, @routers[0], i+2, LINK_BW_BITS_S  # lar_felix_{i} --> lar_switch_01
        @links.push @topology.add_link "link_felix#{i}_switch2", @felix_servers[i], 1, @routers[1], i+2, LINK_BW_BITS_S  # lar_felix_{i} --> lar_switch_02
      end
      
      # SWROD servers
      for i in 0..NUMBER_OF_FELIX_SERVERS-1
        @sw_rod_servers.push @topology.add_host "lar_swrod_#{i}"     
        
        # connected to both switches
        @links.push @topology.add_link "link_switch1_swrod#{i}", @routers[0], i+2, @sw_rod_servers[i], 0, LINK_BW_BITS_S # lar_switch_01 --> lar_swrod_{i}
        @links.push @topology.add_link "link_switch2_swrod#{i}", @routers[1], i+2, @sw_rod_servers[i], 1, LINK_BW_BITS_S # lar_switch_02 --> lar_swrod_{i}        
      end
      
      # links between the switches and routers
      @links.push @topology.add_full_duplex_link "core_link#{@links.size}", @routers[0], 0, @routers[2], 0, LINK_BW_BITS_S  # lar_switch_1 --> core_1  
      @links.push @topology.add_full_duplex_link "core_link#{@links.size}", @routers[0], 1, @routers[3], 0, LINK_BW_BITS_S  # lar_switch_1 --> core_2 
      @links.push @topology.add_full_duplex_link "core_link#{@links.size}", @routers[1], 0, @routers[2], 1, LINK_BW_BITS_S  # lar_switch_2 --> core_1 
      @links.push @topology.add_full_duplex_link "core_link#{@links.size}", @routers[1], 1, @routers[3], 1, LINK_BW_BITS_S  # lar_switch_2 --> core_2 
           
      # flow 1Felix:1ROD
      add_flows_oneFelix_to_oneSWROD
      
      @topology.topology_elements 
    end 
    
    def add_flows_oneFelix_to_oneSWROD
      # Felix flow
      @felix_servers.each_with_index do |felix,index|
         paths = []
           
         # path using switch 1  
         path1 = Path.new felix, @sw_rod_servers[index]
         path1.add_link @topology.get_element_by_id "link_felix#{index}_switch1"  # felix{i} -> switch_1
         path1.add_link @topology.get_element_by_id "link_switch1_swrod#{index}"  # switch_1 --> lar_swrod{i}
         
         paths.push path1
         
         # path using switch 2
         path2 = Path.new felix, @sw_rod_servers[index]
         path2.add_link @topology.get_element_by_id "link_felix#{index}_switch2"  # felix{i} -> switch_2
         path2.add_link @topology.get_element_by_id "link_switch2_swrod#{index}"  # switch_2 --> lar_swrod{i}
         
         paths.push path2
         
         @topology.add_flow "Flow#{index}_1", FELIX_FLOW_PRIORITY, paths, FELIX_GENERATION_PERIOD, FELIX_GENERATION_SIZE       
         @topology.add_flow "Flow_Monitoring#{index}_1", FELIX_FLOW_PRIORITY, [path1], FELIX_MONITORING_GENERATION_PERIOD, FELIX_MONITORING_GENERATION_SIZE
         @topology.add_flow "Flow_Control#{index}_1", FELIX_FLOW_PRIORITY, [path2], FELIX_CONTROL_GENERATION_PERIOD, FELIX_CONTROL_GENERATION_SIZE
      end 
      
    end

    def get_path_between(source, destination) 
      raise NotImplementedError, "NetworkTopology: This method is not implemented (¿does it ever get called?)"      
   end 
end
