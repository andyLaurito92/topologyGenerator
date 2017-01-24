class NetworkConcreteBuilder
  attr_reader :uri_resource

  def build_provider_from(topology)
      @topology = topology

      self
  end

  def get_topology
     @topology.topology_elements
  end

  def get_path_between(source, destination)
  	raise NotImplementedError, "ITopologyProvider: Implement this method in a child class"
  end
end