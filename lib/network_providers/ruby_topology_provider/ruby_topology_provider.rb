module NetworkConcreteBuilder
  attr_reader :uri_resource

  def build_network_from(new_uri_resource)
      raise ArgumentError, 'No uri recieved as parameter' unless new_uri_resource
      @topology = Topology.new
      
      @uri_resource = new_uri_resource
      require (Pathname.new @uri_resource).realpath.to_s
      self.class.send(:include, NetworkTopology)
  end
end