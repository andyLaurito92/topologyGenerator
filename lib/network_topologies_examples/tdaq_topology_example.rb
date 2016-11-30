#PhaseITopologyPriorityQueues

=begin
http://asciiflow.com

    +---------+           +-----------+           +-----------+
    |         |           |           |           |           |
    |  (Host0)|           |(Host1)    |           |   (Host2) |
    |  FelixServer1       |DCS        |           |   Ctrl    |
    |         |           |           |           |           |
    +----+----+           +------+----+           +----+------+
         |                       |                     |
         |                       |                     |
         |                       |                     |
         |                       |                     |
         |                 +-----+-------+             |
         |                 |             |             |
         +-----------------+             |             |
                           |  Router0    +-------------+
                           |             |
                           +-----+-------+
                                 |
                                 |
                                 |
                           +-----+-------+
                           |             |
                           |             |
      +--------------------+ Router1     +-----------------+
      |                    |             |                 |
      |                    +------+------+                 |
      |                           |                        |
      |                           |                        |
+-----+------+           +--------+-----+          +-------+--------+
|            |           |              |          |                |
|            |           |    (Host4)   |          |    (Host5)     |
|   (Host3)  |           |    Dst2      |          |    Dst3        |
|   Dst1     |           |              |          |                |
|            |           |              |          |                |
+------------+           +--------------+          +----------------+
   

=end

module NetworkTopology
    def get_topology
        return @topology.topology_elements if @topology.topology_elements.size != 0

        routers = []
        hosts = []

        for i in 0..1  
            routers.push @topology.add_router "MyRouter#{i}", [6,3,1,1,1,1,1,1]
        end

        for i in 0..5  
          host = @topology.add_host "Host#{i}"
          hosts.push host     
        end

        # In these examples, we dont need the links that goes from dst to FelixServer, DCS or control
        # since the dst host's are never source.

        #Links (starting from the flows that goes from top to bottom)    
        link1 = @topology.add_link "Link1", hosts[0], 0, routers[0], 0, 3*1000*1000 # 500 Mb/s
        link2 = @topology.add_link "Link2", hosts[1], 0, routers[0], 1, 3*1000*1000 # 500 Mb/s
        link3 = @topology.add_link "Link3", hosts[2], 0, routers[0], 2, 3*1000*1000 # 500 Mb/s

        link4 = @topology.add_link "Link4", routers[0], 0, routers[1], 0, 2*1000*1000 # 500 Mb/s

        link5 = @topology.add_link "Link5", routers[1], 0, hosts[3], 0, 3*1000*1000 # 500 Mb/s
        link6 = @topology.add_link "Link6", routers[1], 1, hosts[4], 0, 3*1000*1000 # 500 Mb/s
        link7 = @topology.add_link "Link7", routers[1], 2, hosts[5], 0, 3*1000*1000 # 500 Mb/s

        flow_1_path = Path.new hosts[0], hosts[3]
        flow_1_path.add_link link1
        flow_1_path.add_link link4
        flow_1_path.add_link link5
        @topology.add_flow "Flow1", 
                            0, 
                            flow_1_path, 
                            (ConstantDistribution.new 0.001), #distribution rate in seconds
                            (ConstantDistribution.new 1*1000) #distribution size in bits

        flow_2_path = Path.new hosts[1], hosts[4]
        flow_2_path.add_link link2
        flow_2_path.add_link link4
        flow_2_path.add_link link6
        @topology.add_flow "Flow2", 
                            1, 
                            flow_2_path, 
                            (ConstantDistribution.new 0.001), #distribution rate in seconds
                            (ConstantDistribution.new 1*1000) #distribution size in bits

        flow_3_path = Path.new hosts[2], hosts[5]
        flow_3_path.add_link link3
        flow_3_path.add_link link4
        flow_3_path.add_link link7
        @topology.add_flow "Flow3", 
                            2, 
                            flow_3_path, 
                            (ConstantDistribution.new 0.001), #distribution rate in seconds
                            (ConstantDistribution.new 1*1000) #distribution size in bits                          

        @topology.topology_elements
    end  

    def get_path_between(source, destination)
        raise Exception, "Source must be either from class Router or class Host to ask for a path" unless [Host, Router].include? source.class
        raise Exception, "Destination must be either from class Router or class Host to ask for a path" unless [Host, Router].include? destination.class

        first_link = @topology.topology_elements.select { |elem| (elem.is_a? Link) && (elem.src_element == source) }.first
        second_link = @topology.topology_elements.select { |elem| (elem.is_a? Link) && (elem.dst_element == destination) }.first

        path = Path.new(source,destination)        
        path.add_link first_link
        path.add_link second_link
        path
    end
end