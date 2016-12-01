require_relative 'utils/custom_files_utils.rb'

class OutputBuilder
    
    attr_reader :topology_provider, :directory_concrete_builders, :output_directory

    include CustomFileUtils

    def initialize(topology_provider, directory_concrete_builders, output_directory)
        validate_params topology_provider, directory_concrete_builders, output_directory

        @topology_provider = topology_provider
        @directory_concrete_builders = directory_concrete_builders
        @output_directory = output_directory
    end

    def build_output
        Dir["#{@directory_concrete_builders}/*.rb"].each { |file| 
            if file[0] == '.' then
                require "#{file}" 
            else
                require "./#{file}" 
            end
        }
        self.class.send(:include,OutputConcreteBuilder)
        validate_output_concrete_builder

        initialize_concrete_builder @topology_provider, @directory_concrete_builders, @output_directory

        build_output_content
    end

    def validate_output_concrete_builder
        [:initialize_concrete_builder, :build_output_content].each do |method|
            raise ArgumentError, "It was expected to load an OutputConcreteBuilder module from #{@directory_concrete_builders}/builders/output_files_format that implements the method #{method}, but the one provided does not has this method implemented" unless self.respond_to? method
        end
    end

    def validate_params(topology_provider, directory_concrete_builders, output_directory)
        raise ArgumentError, 'The topology provider given cannot be nil' unless topology_provider
        raise ArgumentError, 'The template directory given cannot be nil' unless directory_concrete_builders
        raise ArgumentError, "It was expected to find builders files in directory #{directory_concrete_builders}, but nothing was found." if Dir["#{directory_concrete_builders}/*.rb"].size == 0
        raise ArgumentError, 'The output directory given cannot be nil' unless output_directory    
    end
end