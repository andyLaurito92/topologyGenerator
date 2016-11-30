#PhaseITopology
=begin
http://asciiflow.com

              +-------+
              |       |         +--------+
              |Host2  |         |        |
              |       |         |        |
              +----+--+         |Host1   |
+-------+          |            |        |
|       |          |            +--------+
| Host3 +------+---+-------+----+
|       |      |           |
+-------+     ++  Router1  |            +---------+
              ||           +------------+         |
              +----+-------+            |         |
    +---------+    |                    |Router2  |
    |         |    |                    |         |
    |         |    |                    +---------+
    | Host4   |    |
    +---------+    |
                   +---------+
                   |         |
                   |Host5    |
                   |         |
                   +---------+

=end
module NetworkTopology
    def get_topology
        return @topology.topology_elements if @topology.topology_elements.size != 0

        # Routers  
        router1 = @topology.add_router 'MyRouter1'
        router2 = @topology.add_router 'MyRouter2' 

        # Hosts
        link_count = 0
        for i in 1..5
          host = @topology.add_host "Host#{i}"     
          link_count += 1
          @topology.add_link "Link#{link_count}", host, 0, router1, i
          link_count += 1
          @topology.add_link "Link#{link_count}", router1, i, host, 0

        end

        #Links    
        @topology.add_link 'Link0', router1, 0, router2, 0    
            
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