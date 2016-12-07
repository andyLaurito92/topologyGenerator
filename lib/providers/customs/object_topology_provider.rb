class ObjectTopologyProvider < ITopologyProvider
  attr_reader :uri_resource

  def initialize(topology)
      @topology = topology
  end

  def get_topology
     @topology
  end

  def get_path_between(source, destination)
  	raise NotImplementedError, "ITopologyProvider: Implement this method in a child class"
  end
end