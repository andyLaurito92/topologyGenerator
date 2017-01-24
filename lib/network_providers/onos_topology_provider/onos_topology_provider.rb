require 'cgi'
require 'json'
require 'typhoeus'

module NetworkConcreteBuilder

    attr_accessor :uri_resource
    
    def build_provider_from(new_uri_resource)
          raise ArgumentError, 'No uri recieved as parameter' unless new_uri_resource
          @uri_resource = new_uri_resource
          @topology = Topology.new

          self
    end
    
    def get_topology

      return @topology.topology_elements if @topology.topology_elements.size != 0
            
      add_routers 
      add_hosts
      add_links 
      
      @topology.topology_elements
    end    

    def get_from_api(resource)
        Typhoeus.get "#{@uri_resource}#{resource}", userpwd:"onos:rocks"
    end

=begin
This is the info that represents a router
{
  "id"=>"of:0000000000000003", 
  "type"=>"SWITCH", 
  "available"=>true, 
  "role"=>"MASTER", 
  "mfr"=>"Nicira, Inc.", 
  "hw"=>"Open vSwitch", 
  "sw"=>"2.5.0", 
  "serial"=>"None", 
  "chassisId"=>"3", 
  "annotations"=>{
    "managementAddress"=>"127.0.0.1", 
    "protocol"=>"OF_13", 
    "channelId"=>"127.0.0.1:59170"
    }
}
=end
    def add_routers
        #Devices represents either hosts or routers. This function will make difference between them
        devices_response = get_from_api 'devices'
        graph_elements_info = (JSON.parse devices_response.body)['devices']
        graph_elements_info.each do |element_info|
            # To identify if a device is either a router or a host, we can ask for it flows. If the device has no flows, 
            # then it's a host
            flows_response = get_from_api "flows/#{element_info['id']}"
            @topology.add_router element_info['id'] if flows_response.code == 200
        end        
    end

=begin
This is the info that represents a Host

{
  "id"=>"9A:4A:43:D4:36:45/None", 
  "mac"=>"9A:4A:43:D4:36:45", 
  "vlan"=>"None", 
  "configured"=>false, 
  "ipAddresses"=>["10.0.0.1"], 
  "location"=>{
    "elementId"=>"of:0000000000000002", 
    "port"=>"1"
  }
}

=end
    def add_hosts
        hosts_response = get_from_api 'hosts'
        hosts_info = (JSON.parse hosts_response.body)['hosts']
        hosts_info.each_with_index  do |host_info, index|
          
          host = @topology.add_host host_info['id'], host_info['ipAddresses'], host_info['mac']
            
          
          @topology.add_link "Link#{index}host_to_router",
                                      host, 
                                      0,
                                      host_info['location']['elementId'],
                                      host_info['location']['port'].to_i

          @topology.add_link "Link#{index}router_to_host",
                                      host_info['location']['elementId'], 
                                      host_info['location']['port'].to_i,
                                      host,
                                      0                                      
        end        
    end

=begin
links_between_routers_info is an array of elements of this kind
{
  "src"=>{
    "port"=>"2",
    "device"=>"of:0000000000000001"
  },
  "dst"=>{
    "port"=>"3",
    "device"=>"of:0000000000000005"
  },
  "type"=>"DIRECT",
  "state"=>"ACTIVE"
}
=end    
    def add_links
        links_between_routers_response = get_from_api 'links'
        links_between_routers_info = (JSON.parse links_between_routers_response.body)['links']
          
        index_offset = @topology.links.size + 1 
        links_between_routers_info.each_with_index do |link_between_routers_info, index|
          @topology.add_link "Link#{index+index_offset}", 
                                     link_between_routers_info['src']['device'],
                                     link_between_routers_info['src']['port'].to_i,
                                     link_between_routers_info['dst']['device'],
                                     link_between_routers_info['dst']['port'].to_i
        end
    end

    def get_path_between(source, destination)
        raise Exception, "Source must be either from class Router or class Host to ask for a path" unless [Host, Router].include? source.class
        raise Exception, "Destination must be either from class Router or class Host to ask for a path" unless [Host, Router].include? destination.class
        
        paths_response = get_from_api "paths/#{CGI.escape(source.id)}/#{CGI.escape(destination.id)}"
        paths_info = (JSON.parse paths_response.body)['paths']
        path = Path.new(source,destination)
        
        return path if paths_info.size == 0
        
        links_info = paths_info.first['links']

        #If either the source or the destination are hosts, the path will return host instead of device
        first_link = links_info.shift
        last_link = links_info.pop
        
        path.add_link (find_link first_link, 'host', 'device')

        links_info.each do |link|
          path.add_link (find_link link, 'device', 'device')
        end
        path.add_link (find_link last_link, 'device', 'host')

        path
    end

    def find_link(link_representation_in_path, src_key, dst_key)
      links_found = @topology.topology_elements.select { |elem| 
        (elem.is_a? Link) && 
        (elem.src_element.id == link_representation_in_path['src'][src_key]) && 
        (elem.dst_element.id == link_representation_in_path['dst'][dst_key]) }

      raise "It was suppossed to find one link with the representation #{link_representation_in_path}, but #{links_found.size} were found" unless links_found.size == 1
      links_found.first
    end
end