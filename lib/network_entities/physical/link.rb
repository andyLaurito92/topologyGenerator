require_relative '../abstracts/network_element.rb'

class Link < NetworkElement

  attr_reader :src_element, :src_port, :dst_element, :dst_port, :bandwith, :delay

  "port numbers are 0-based (like in the c++ of powerdevs)"
  def initialize(id, src_element, src_port, dst_element, dst_port, bandwith = 500*1000*1000, delay = 0)
    
    bandwith ||= 500*1000*1000 # 500 Mb/s
    delay ||= 0
    
    raise "Attempted to create an invalid Link. Invalid source #{src_element.id}" if (!src_element.is_a? Router) && (!src_element.is_a? Host)  
    raise "Attempted to create an invalid Link. Invalid destination '#{dst_element.id}'" if (!dst_element.is_a? Router) && (!dst_element.is_a? Host)
    raise "Attempted to create an invalid Link. Invalid source port '#{src_port}' must be an integer" if (!src_port.is_a? Integer)
    raise "Attempted to create an invalid Link. Invalid destination port '#{dst_port}' must be an integer" if (!dst_port.is_a? Integer)
    raise "Invalid Source port. Port '#{src_port}' already in use for '#{src_element.id}'" if src_element.out_elements[src_port]
    raise "Invalid Destination port. Port '#{dst_port}' already in use for '#{dst_element.id}'" if dst_element.in_elements[dst_port]
    raise "Bandwith must be a number, #{bandwith} was recieved" unless bandwith.is_a? Integer

    @src_element = src_element
    @src_port = src_port
    @dst_element = dst_element
    @dst_port = dst_port
    @bandwith = bandwith # Expressed in bits per second (bit/s)
    @delay = delay

    # add each other
    @src_element.out_elements[src_port] = @dst_element
    @dst_element.in_elements[dst_port] = @src_element 

    super id
  end  
end