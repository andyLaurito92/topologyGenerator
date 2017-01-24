require_relative "network_entities/topology.rb"
require_relative 'network_entities/abstracts/path.rb'
require_relative 'network_entities/abstracts/flow.rb'
require_relative 'network_entities/abstracts/network_element.rb'
require_relative 'network_entities/physical/host.rb'
require_relative 'network_entities/physical/link.rb'
require_relative 'network_entities/physical/router.rb'

class NetworkProviderBuilder    
    def build_from(dir_topo_provider_builder, uri_resource)
        
        files_to_load = Dir["#{dir_topo_provider_builder}/*.rb"]
        raise ArgumentError, "Directory #{dir_topo_provider_builder} has no builders inside. Please check that you have specified the correct folder!" if files_to_load.size == 0

        files_to_load.each { |file| 
            if file[0] == '/' then
                require "#{file}" 
            else
                require "./#{file}" 
            end
        }

        self.class.send(:include,NetworkConcreteBuilder)

        validate_network_concrete_builder

        build_provider_from uri_resource
    end

    def validate_network_concrete_builder
        [:get_topology, :get_path_between, :build_provider_from].each do |method|
            raise ArgumentError, "It was expected that the ProviderConcreteBuilder module's load from #{@directory_concrete_builders} implemented the method #{method}, but the one provided does not has this method defined" unless self.respond_to? method
        end
    end
end