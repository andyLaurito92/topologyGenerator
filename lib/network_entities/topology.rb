require_relative "abstracts/network_element.rb"
require_relative "abstracts/flow.rb"
require_relative "physical/host.rb"
require_relative "physical/link.rb"
require_relative "physical/router.rb"

"A helper class to build consistent topologies"
class Topology
  attr_reader :topology_elements

  def initialize
    @topology_elements = []
  end
  
  def get_element_by_id(element_id)
    @topology_elements.find{|x| x.id == element_id }
  end

  def elements_of_type(type)
    @topology_elements.select { |elem| elem.is_a? type }
  end

  def links
    elements_of_type Link
  end

  def add_host(id, ips=["127.0.0.1"], mac="9A:4A:43:D4:36:45", queue_capacity=-1)
    raise "ID '#{id}' already exists in topology" if get_element_by_id id 
    
    new_host = Host.new id
    @topology_elements.push new_host
    new_host
  end
  
  def add_router(id, priority_weights=[1], buffer=-1)
    raise "ID '#{id}' already exists in topology" if get_element_by_id id
    
    new_router = Router.new id, priority_weights, buffer
    @topology_elements.push new_router
    new_router
  end
  
  def add_link(id, src, src_port, dst, dst_port, bandwith = nil)
    raise "ID '#{id}' already exists in topology" if get_element_by_id id
    
    # if they sent the id of the src or dst => search the object    
    src_node = (src.is_a? NetworkElement) ? src : (get_element_by_id src)
    dst_node = (dst.is_a? NetworkElement) ? dst : (get_element_by_id dst)
    
    new_link = Link.new id, src_node, src_port, dst_node, dst_port, bandwith
    @topology_elements.push new_link
    new_link
  end  
  
  def add_full_duplex_link(id, src, src_port, dst, dst_port, bandwith = nil)
    add_link("#{id}_up", src, src_port, dst, dst_port, bandwith) # up
    add_link("#{id}_down", dst, dst_port, src, src_port, bandwith) # down
  end
    
  def add_flow(id, priority, path, distribution_rate, distribution_size)
    raise "ID '#{id}' already exists in topology" if get_element_by_id id

    distribution_rate ||= ConstantDistribution.new 0
    distribution_size ||= ConstantDistribution.new 0
    new_flow = Flow.new id, priority, path, distribution_rate, distribution_size
    @topology_elements.push new_flow
    new_flow
  end
end