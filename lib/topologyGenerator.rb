require_relative "topologyGenerator/version"
require_relative 'providers/apis/onos_topology_provider.rb'
require_relative 'providers/customs/custom_topology_provider.rb'
require_relative 'output_builder.rb'

"Main class that reads a topology from a source provider and writes it using a builder"
class TopologyGenerator
  
  def initialize(arguments)
    validate arguments
    @arguments = arguments

    case @arguments.source
        when 'ONOS'
            @topology_provider = OnosTopologyProvider.new @arguments.uri_resource
        when 'CUSTOM'
            @topology_provider = CustomTopologyProvider.new @arguments.uri_resource
        else
            raise ArgumentError, "The source: #{@arguments.source} is not one of the expected"
    end
  end
  
  def generate
    output_builder = OutputBuilder.new @topology_provider, @arguments.directory_concrete_builders, @arguments.output_directory
    output_builder.build_output    
  end

  def validate(arguments)
    raise ArgumentError, 'No arguments received' unless arguments
    [:source,:directory_concrete_builders,:output_directory, :uri_resource].each do |argument_name|
      raise ArgumentError, "It is mandatory that arguments has a #{argument_name}" unless arguments.respond_to? argument_name
    end
  end
end
