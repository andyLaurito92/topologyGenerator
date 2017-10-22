require 'typhoeus'
require_relative "../interface_topology_provider.rb"
require_relative "../../network_entities/topology.rb"
require_relative '../../network_entities/abstracts/path.rb'

class OpendaylightTopologyProvider < ITopologyProvider

    attr_accessor :uri_resource
    
    def initialize(new_uri_resource)
          raise ArgumentError, 'No uri recieved as parameter' unless new_uri_resource
          @uri_resource = new_uri_resource
          @topology = Topology.new
    end

=begin
This is who it looks like the xml received by the opendaylight api

<topology>
  <topology-id>flow:1</topology-id>
  <node>
    <node-id>openflow:1</node-id>
    <inventory-node-ref>/a:nodes/a:node[a:id='openflow:1']</inventory-node-ref>
    <termination-point>
      <tp-id>openflow:1:2</tp-id>
      <inventory-node-connector-ref>/a:nodes/a:node[a:id='openflow:1']/a:node-connector[a:id='openflow:1:2']</inventory-node-connector-ref>
    </termination-point>
    <termination-point>
      <tp-id>openflow:1:1</tp-id>
      <inventory-node-connector-ref>/a:nodes/a:node[a:id='openflow:1']/a:node-connector[a:id='openflow:1:1']</inventory-node-connector-ref>
    </termination-point>
    <termination-point>
      <tp-id>openflow:1:LOCAL</tp-id>
      <inventory-node-connector-ref>/a:nodes/a:node[a:id='openflow:1']/a:node-connector[a:id='openflow:1:LOCAL']</inventory-node-connector-ref>
    </termination-point>
  </node>
  <node>
    <node-id>host:52:57:c6:e4:b3:33</node-id>
    <id>52:57:c6:e4:b3:33</id>
    <addresses>
      <id>1</id>
      <mac>52:57:c6:e4:b3:33</mac>
      <ip>10.0.0.2</ip>
      <first-seen>1480973744947</first-seen>
      <last-seen>1480973744947</last-seen>
    </addresses>
    <attachment-points>
      <tp-id>openflow:2:2</tp-id>
      <active>true</active>
      <corresponding-tp>host:52:57:c6:e4:b3:33</corresponding-tp>
    </attachment-points>
    <termination-point>
      <tp-id>host:52:57:c6:e4:b3:33</tp-id>
    </termination-point>
  </node>
  <link>
    <link-id>openflow:1:2</link-id>
    <source>
      <source-node>openflow:1</source-node>
      <source-tp>openflow:1:2</source-tp>
    </source>
    <destination>
      <dest-node>openflow:2</dest-node>
      <dest-tp>openflow:2:1</dest-tp>
    </destination>
  </link>
  <link>
    <link-id>host:5e:66:e6:c2:d0:02/openflow:3:1</link-id>
    <source>
      <source-node>host:5e:66:e6:c2:d0:02</source-node>
      <source-tp>host:5e:66:e6:c2:d0:02</source-tp>
    </source>
    <destination>
      <dest-node>openflow:3</dest-node>
      <dest-tp>openflow:3:1</dest-tp>
    </destination>
  </link>
</topology>
=end
    
    def get_topology
      response = Typhoeus.get "#{@uri_resource}/restconf/operational/network-topology:network-topology/topology/flow:1/", userpwd:"admin:admin"
      topology_json_response = (JSON.parse response.body)['topology'].first
      nodes_info = topology_json_response['node']
      links_info = topology_json_response['link']

      nodes_info.each do |node|
        if node['node-id'].include? 'openflow'
          @topology.add_router node['node-id']
        else
          node_info = node["host-tracker-service:addresses"].first
          @topology.add_host node['node-id'], [node_info['ip']], node_info['mac']
        end
      end

      links_info.each do |link|
        source = @topology.get_element_by_id link['source']['source-node']
        destiny = @topology.get_element_by_id link['destination']['dest-node']

        #TODO: WHICH IS THE FORM OF FINDING THE PORT OF THE HOST?
        source_port = (source.is_a? Host) ? 1 : (link['source']['source-tp'].gsub "#{source.id}:", '').to_i
        destiny_port = (destiny.is_a? Host) ? 1 : (link['destination']['dest-tp'].gsub "#{destiny.id}:", '').to_i

        @topology.add_link link['link-id'], source, source_port, destiny, destiny_port
      end

      @topology.topology_elements
    end    

    def get_path_between(source, destination)
      raise NotImplementedError, "OpenDayLight provider: This method is not implemented!"      
    end
end