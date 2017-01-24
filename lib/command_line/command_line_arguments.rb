require 'commander'
require 'uri'
require 'byebug'

class CommandLineArguments
    include Commander::Methods

    attr_reader :dir_providers, :dir_serializers, :uri_resource, :output_directory

    def run
        program :name, 'Topologygenerator'
        program :version, '0.0.1'
        program :description, 'Tool for building a custom serialization out of a given network.'
        program :help, 'Author', 'Andrés Laurito && Matias Bonaventura'

        my_command_line_argument = self 

        my_command = command :source do |c|
          c.syntax = 'Tpologygenerator source [OPTIONS]'
          c.summary = 'Serialize a network using given parameters'
          c.description = 'Build the desired serialization of a network, by providing directories of serializers and providers, the uri from where to obtain the topology and the output directory desired. For more examples and tutorials, go to https://github.com/andyLaurito92/topologygenerator/wiki'
          c.example 'Retrieve network from ONOS controller, and seriliaze it as a ruby model', 'Topologygenerator source -p network_providers/onos_topology_provider -s network_serializers/ruby_serializer -o output_directory -u http://127.0.0.1:8181/onos/v1/'
          c.example 'Retrieve network from OPENDAYLIGHT controller, and serialize it as a ruby model', 'Topologygenerator source -p network_providers/opendaylight_topology_provider -s network_serializers/ruby_serializer -o output_directory -u http://localhost:8080/restconf/operational/network-topology:network-topology/topology/flow:1/'
          c.example 'Retrieve network from ONOS controller, and serialize it as a DEVS model', 'Topologygenerator source -p network_providers/onos_topology_provider -s network_serializers/powerdevs_serializer/PhaseIPriorityQueues -o output_directory -u http://127.0.0.1:8181/onos/v1/'
          c.option '-p', '--dirProvider NAME', String, 'Specify the directory where the provider files are located'
          c.option '-s', '--dirSerializer NAME', String, 'Specify the directory where the serializer files are located'
          c.option '-o', '--outDir NAME', String, 'Specify the output directory path'
          c.option '-u', '--uri NAME', String, 'Specify the uri for the source'
          c.action do |args, options|
            @dir_providers = options.dirProvider
            @dir_serializers = options.dirSerializer
            @uri_resource = options.uri
            @output_directory = options.outDir
          end
        end

    	run!
    end
end
