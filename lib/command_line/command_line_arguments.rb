require 'commander'
require 'uri'
require 'byebug'

class CommandLineArguments
    include Commander::Methods

    attr_reader :source, :uri_resource, :output_directory, :directory_concrete_builders

    def run
        program :name, 'Create PowerDevs topology'
        program :version, '0.0.1'
        program :description, 'Tool for retrieving topologies from a specific target and serialize it into a specific output format'
        program :help, 'Author', 'Andrés Laurito && Matias Bonaventura'

        my_command_line_argument = self 

        my_command = command :source do |c|
          c.syntax = 'Topologygenerator source [OPTIONS]'
          c.summary = 'Specify the name of the source from where to retrieve the topology, the output directory, 
          the URI used to get the topology and the directory of where the builders are located.'
          c.description = 'Specify the data source from where the topology should be retrieved
          An example of use: Topologygenerator source -n ONOS -o output -u http://127.0.0.1:8181/onos/v1/ -d builders_examples/ruby_builders
          By default, the option is set in CUSTOM.
          By default, the output will be written in a file called my_topology'
          c.example 'Set ONOS as source', 'Topologygenerator source -n ONOS'
          c.example 'Set CUSTOM as source', 'Topologygenerator source -n CUSTOM'
          c.example 'Set CUSTOM as source and called the output file my_file', 'Topologygenerator source -n MOCK -o my_file.txt'
          c.option '-n', '--name NAME', String, 'Specify the source name'
          c.option '-o', '--outDir NAME', String, 'Specify the output directory path'
          c.option '-u', '--uri NAME', String, 'Specify the uri for the source'
          c.option '-d', '--dirBuilders NAME', String, 'Specify the directory where the builders are located'
          c.action do |args, options|
            options.default :file => 'my_topology'
            options.default :outDir => 'output'
            options.default :dirBuilders => 'builders_examples/pdm_builders/PhaseI'
          	new_source = options.name
            raise ArgumentError, "The source '#{new_source}' is not one of the expected. Please type source --help to more information." unless ['ONOS','OPENDAYLIGHT','CUSTOM'].include? new_source

            if new_source == 'ONOS'
                new_uri_resource = options.uri 
                new_uri_resource = ask 'http source for ONOS?:(example http://127.0.0.1:8181/onos/v1/)' unless new_uri_resource
                raise ArgumentError, "You must specify a valid http source when the option ONOS is selected. #{new_uri_resource} is not a valid one" unless new_uri_resource =~ /\A#{URI::regexp(['http', 'https'])}\z/
            elsif new_source == 'OPENDAYLIGHT'
              new_uri_resource = options.uri 
                new_uri_resource = ask 'http source for OPENDAYLIGHT?:(example http://localhost:8080/restconf/operational/network-topology:network-topology/topology/flow:1/)' unless new_uri_resource
                raise ArgumentError, "You must specify a valid http source when the option OPENDAYLIGHT is selected. #{new_uri_resource} is not a valid one" unless new_uri_resource =~ /\A#{URI::regexp(['http', 'https'])}\z/
            elsif new_source == 'CUSTOM'
                new_uri_resource = options.uri
                new_uri_resource = ask 'uri source for CUSTOM?:(example network_topologies_examples/tree_topology.rb)' unless new_uri_resource
                raise ArgumentError, "You must specify a valid uri source when the option CUSTOM is selected. #{new_uri_resource} is not a valid one" unless File.exists? new_uri_resource
            end

            @source = new_source
            @uri_resource = new_uri_resource
            @output_directory = options.outDir
            @directory_concrete_builders = options.dirBuilders
          end
        end

    	run!
    end
end
