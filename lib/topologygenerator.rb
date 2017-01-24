require_relative "topologygenerator/version"
require_relative 'network_provider_builder.rb'
require_relative 'network_serializer_builder.rb'
require 'byebug'

class Topologygenerator

  DIR_PROVIDER_BUILDERS = 'dir_provider_builders'
  DIR_SERIALIZER_BUILDERS = 'dir_serializer_builders' 
  OUTPUT_DIRECTORY = 'output_directory'
  URI_RESOURCE = 'uri_resource'

  attr_reader :topology_provider

  def initialize(arguments)
    validate arguments
    @arguments = arguments

    topology_provider_builder = NetworkProviderBuilder.new 
    topology_provider = topology_provider_builder.build_from @arguments[DIR_PROVIDER_BUILDERS], @arguments[URI_RESOURCE]
    @topology_provider = topology_provider
  end
  
  def generate
    topology_serializer_builder = NetworkSerializerBuilder.new
    topology_serializer_builder.build_from @topology_provider, @arguments[DIR_SERIALIZER_BUILDERS], @arguments[OUTPUT_DIRECTORY]   
  end

  def validate(arguments)
    raise ArgumentError, 'No arguments received' unless arguments
    [DIR_PROVIDER_BUILDERS,DIR_SERIALIZER_BUILDERS,OUTPUT_DIRECTORY, URI_RESOURCE].each do |argument_name|
      raise ArgumentError, "It is mandatory to specify the #{argument_name}" if !(arguments.key? argument_name) || arguments[argument_name].nil?
    end

    [DIR_PROVIDER_BUILDERS,DIR_SERIALIZER_BUILDERS].each do |directory|
      raise ArgumentError, "The directory #{directory} given is not a valid one" unless Dir.exists? arguments[directory]
    end
  end
end
