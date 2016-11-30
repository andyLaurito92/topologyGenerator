#PhaseITopologyPriorityQueues

=begin
http://asciiflow.com

                +-------------+           +----------------+
               |             |           |                |
               | Host0       |           |    Host1       |
               +-------------+       +---+----------------+
                             |       |
                             |       |
                             |       |
                            ++-------+-+
                            |          |
                            |          +-----------------------------+
                 +----------+Switch0   +-------------+               |
                 |          +-------+--+             |               |
                 |                  |                |               |
            +----+---+         +----+---+        +---+-----+    +----+-----+
            |        |         |        |        |         |    |          |
            |Switch1 |  +------+Switch2 |        |Switch3  |    |Switch4   |
    +------------+---+  |      +------+-+--+     +---+-----++   +----------++
    |            |      |      |      |    |         |      |               |
    |            |      |  +---+----+ |    |  +------+-+   ++------+      +-+--------+
+---+----+  +----+---+  |  |Host4   | |    |  |        |   |       |      |          |
|        |  |        |  |  |   +----+-+--+ |  | Host9  |   |Host10 |      | Host11   |
|Host2   |  | Host3  |  |  +-----Host5   | |  +--------+   +-------+      +----------+
+--------+  +--------+  |      |    +----+-+-+
                        |      +------Host6  |
                        |           |    +---+-----+
                        |           +----+Host7    |
                        |                |    +----+---+
                        +----------------+------Host8  |
                        |                     |        |
                        +---------------------+--------+
   

=end

module NetworkTopology
    def get_topology
        return @topology.topology_elements if @topology.topology_elements.size != 0

        routers = []
        hosts = []

        # Routers
        for i in 0..4
          router = @topology.add_router "MyRouter#{i}"
          routers.push router
        end         

        # Hosts
        for i in 0..11  
          host = @topology.add_host "Host#{i}"
          hosts.push host     
        end

        #Links (starting from the flows that goes from top to bottom)    
        @topology.add_link "Link1", hosts[0], 0, routers[0], 0
        @topology.add_link "Link2", hosts[1], 0, routers[0], 1

        @topology.add_link "Link3", routers[0], 0, routers[1], 0
        @topology.add_link "Link4", routers[0], 1, routers[2], 0
        @topology.add_link "Link5", routers[0], 2, routers[3], 0
        @topology.add_link "Link6", routers[0], 3, routers[4], 0

        @topology.add_link "Link7", routers[1], 0, hosts[2], 0
        @topology.add_link "Link8", routers[1], 1, hosts[3], 0

        @topology.add_link "Link9", routers[2], 0, hosts[4], 0
        @topology.add_link "Link10", routers[2], 1, hosts[5], 0
        @topology.add_link "Link11", routers[2], 2, hosts[6], 0
        @topology.add_link "Link12", routers[2], 3, hosts[7], 0
        @topology.add_link "Link13", routers[2], 4, hosts[8], 0

        @topology.add_link "Link14", routers[3], 0, hosts[9], 0
        @topology.add_link "Link15", routers[3], 1, hosts[10], 0

        @topology.add_link "Link16", routers[4], 0, hosts[11], 0

        #Links (flows that goes from bottom to top)    
        @topology.add_link "Link17", hosts[2], 0, routers[1], 1
        @topology.add_link "Link18", hosts[3], 0, routers[1], 2

        @topology.add_link "Link19", hosts[4], 0, routers[2], 1
        @topology.add_link "Link20", hosts[5], 0, routers[2], 2
        @topology.add_link "Link21", hosts[6], 0, routers[2], 3
        @topology.add_link "Link22", hosts[7], 0, routers[2], 4
        @topology.add_link "Link23", hosts[8], 0, routers[2], 5

        @topology.add_link "Link24", hosts[9], 0, routers[3], 1
        @topology.add_link "Link25", hosts[10], 0, routers[3], 2        

        @topology.add_link "Link26", hosts[11], 0, routers[4], 1

        @topology.add_link "Link27", routers[1], 2, routers[0], 2
        @topology.add_link "Link28", routers[2], 5, routers[0], 3
        @topology.add_link "Link29", routers[3], 2, routers[0], 4
        @topology.add_link "Link30", routers[4], 1, routers[0], 5        

        @topology.add_link "Link31", routers[0], 4, hosts[0], 0
        @topology.add_link "Link32", routers[0], 5, hosts[1], 0


        @topology.topology_elements
    end  

    def get_path_between(source, destination)
        raise Exception, "Source must be either from class Router or class Host to ask for a path" unless [Host, Router].include? source.class
        raise Exception, "Destination must be either from class Router or class Host to ask for a path" unless [Host, Router].include? destination.class

        #TODO: Implement this function seriously :P
        path = Path.new(source,destination)
        links = @topology.topology_elements.select { |elem| elem.is_a? Link }
        links.each do |link|
          path.add_link link
        end
        path
    end
end