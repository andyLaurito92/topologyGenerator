require_relative 'utils/custom_files_utils.rb'

class NetworkSerializerBuilder    
    include CustomFileUtils

    def build_from(topology, directory_concrete_serializer_builders, output_directory)

        files_to_load = Dir["#{directory_concrete_serializer_builders}/*.rb"]
        raise ArgumentError, "Directory #{directory_concrete_serializer_builders} has no builders inside. Please check that you have specified the correct folder!" if files_to_load.size == 0
        files_to_load.each { |file| 
            if file[0] == '/' then
                require "#{file}" 
            else
                require "./#{file}" 
            end
        }
        self.class.send(:include,SerializerConcreteBuilder)

        validate_output_concrete_builder

        byebug

        initialize_serializer topology, directory_concrete_serializer_builders, output_directory

        serialize_network
    end

    def validate_output_concrete_builder
        [:initialize_serializer, :serialize_network].each do |method|
            raise ArgumentError, "It was expected to load a SerializerConcreteBuilder module that implements the method #{method}, the module load does not implement this method." unless self.respond_to? method
        end
    end
end