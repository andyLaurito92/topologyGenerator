module NetworkTopology 
    def get_topology 
        return @topology.topology_elements if @topology.topology_elements.size != 0 
       hosts = [] 
        routers = [] 
       links = [] 


      routers.push @topology.add_router "of:2000000000010101", [1] 
      routers.push @topology.add_router "of:2000000000010201", [1] 
      routers.push @topology.add_router "of:2000000000010102", [1] 
      routers.push @topology.add_router "of:2000000000010202", [1] 
      routers.push @topology.add_router "of:1000000000020001", [1] 
      routers.push @topology.add_router "of:2000000000030001", [1] 
      routers.push @topology.add_router "of:2000000000030002", [1] 
      routers.push @topology.add_router "of:1000000000020002", [1] 
      routers.push @topology.add_router "of:1000000000030002", [1] 
      routers.push @topology.add_router "of:1000000000030001", [1] 
      routers.push @topology.add_router "of:1000000000010201", [1] 
      routers.push @topology.add_router "of:1000000000010102", [1] 
      routers.push @topology.add_router "of:1000000000010202", [1] 
      routers.push @topology.add_router "of:1000000000010101", [1] 

      @topology.add_link "Link1", routers[7], 4, routers[12], 2, 500000000 
      @topology.add_link "Link2", routers[12], 2, routers[7], 4, 500000000 
      @topology.add_link "Link3", routers[3], 3, routers[12], 4, 500000000 
      @topology.add_link "Link4", routers[1], 2, routers[10], 3, 500000000 
      @topology.add_link "Link5", routers[11], 1, routers[13], 1, 500000000 
      @topology.add_link "Link6", routers[3], 2, routers[10], 4, 500000000 
      @topology.add_link "Link7", routers[9], 4, routers[6], 2, 500000000 
      @topology.add_link "Link8", routers[10], 1, routers[12], 1, 500000000 
      @topology.add_link "Link9", routers[13], 4, routers[2], 2, 500000000 
      @topology.add_link "Link10", routers[0], 2, routers[13], 3, 500000000 
      @topology.add_link "Link11", routers[2], 3, routers[11], 4, 500000000 
      @topology.add_link "Link12", routers[2], 2, routers[13], 4, 500000000 
      @topology.add_link "Link13", routers[13], 2, routers[4], 3, 500000000 
      @topology.add_link "Link14", routers[4], 2, routers[8], 1, 500000000 
      @topology.add_link "Link15", routers[4], 3, routers[13], 2, 500000000 
      @topology.add_link "Link16", routers[5], 2, routers[9], 3, 500000000 
      @topology.add_link "Link17", routers[6], 3, routers[8], 4, 500000000 
      @topology.add_link "Link18", routers[10], 3, routers[1], 2, 500000000 
      @topology.add_link "Link19", routers[12], 4, routers[3], 3, 500000000 
      @topology.add_link "Link20", routers[6], 2, routers[9], 4, 500000000 
      @topology.add_link "Link21", routers[12], 3, routers[1], 3, 500000000 
      @topology.add_link "Link22", routers[4], 4, routers[10], 2, 500000000 
      @topology.add_link "Link23", routers[10], 2, routers[4], 4, 500000000 
      @topology.add_link "Link24", routers[5], 3, routers[8], 3, 500000000 
      @topology.add_link "Link25", routers[10], 4, routers[3], 2, 500000000 
      @topology.add_link "Link26", routers[13], 1, routers[11], 1, 500000000 
      @topology.add_link "Link27", routers[4], 1, routers[9], 1, 500000000 
      @topology.add_link "Link28", routers[7], 2, routers[8], 2, 500000000 
      @topology.add_link "Link29", routers[7], 1, routers[9], 2, 500000000 
      @topology.add_link "Link30", routers[0], 3, routers[11], 3, 500000000 
      @topology.add_link "Link31", routers[11], 4, routers[2], 3, 500000000 
      @topology.add_link "Link32", routers[13], 3, routers[0], 2, 500000000 
      @topology.add_link "Link33", routers[11], 3, routers[0], 3, 500000000 
      @topology.add_link "Link34", routers[12], 1, routers[10], 1, 500000000 
      @topology.add_link "Link35", routers[8], 1, routers[4], 2, 500000000 
      @topology.add_link "Link36", routers[8], 2, routers[7], 2, 500000000 
      @topology.add_link "Link37", routers[8], 4, routers[6], 3, 500000000 
      @topology.add_link "Link38", routers[9], 1, routers[4], 1, 500000000 
      @topology.add_link "Link39", routers[9], 3, routers[5], 2, 500000000 
      @topology.add_link "Link40", routers[8], 3, routers[5], 3, 500000000 
      @topology.add_link "Link41", routers[9], 2, routers[7], 1, 500000000 
      @topology.add_link "Link42", routers[11], 2, routers[7], 3, 500000000 
      @topology.add_link "Link43", routers[1], 3, routers[12], 3, 500000000 
      @topology.add_link "Link44", routers[7], 3, routers[11], 2, 500000000 

      @topology.topology_elements 
    end 

    def get_path_between(source, destination) 
       #Think how to implement it! 
       Path.new(source,destination) 
   end 
end
