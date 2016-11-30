"Interface for topology providers"
class ITopologyProvider
  "returns a list with the topology elements (nodes, routers, links)"
  def get_topology
     raise NotImplementedError, "ITopologyProvider: Implement this method in a child class"
  end

  def get_path_between(source, destination)
  	raise NotImplementedError, "ITopologyProvider: Implement this method in a child class"
  end
end