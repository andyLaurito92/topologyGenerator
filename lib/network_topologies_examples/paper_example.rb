module NetworkTopology
 def get_topology
  return @topology.topology_elements unless @topology.topology_elements.size == 0
  hosts = []
  router = @topology.add_router "Router1"
  for i in 0..2  
    host = @topology.add_host "Host#{i}"
    hosts.push host     
  end
  bwith = 500*1000*1000
 @topology.add_full_duplex_link "Link1", hosts[0], 0, router, 0, bwith
 @topology.add_full_duplex_link "Link2", hosts[1], 0, router, 1, bwith
 @topology.add_full_duplex_link "Link3", hosts[2], 0, router, 2, bwith
  link1 = @topology.get_element_by_id "Link1_up"
  link2 = @topology.get_element_by_id "Link3_down"
  flow_1_path = Path.new hosts[0], hosts[2]
  flow_1_path.add_link link1
  flow_1_path.add_link link2
  @topology.add_flow "Flow1", 10, 
  [flow_1_path], 
  (ExponentialDistribution.new 1.0/6875), 
  (ConstantDistribution.new 1000*8)
  @topology.topology_elements
 end
end