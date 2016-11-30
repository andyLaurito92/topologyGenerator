module SerializeBehavior
    def transform_to_output_representation(path_to_templates_directory)
        load "#{path_to_templates_directory}/#{self.class.name}_concrete_builder.rb"
        self.class.send(:include, Kernel.const_get("#{self.class.name}ConcreteBuilder"))          
        validate_concrete_builder
        build_output_representation              
    end

    def validate_concrete_builder
        [:build_output_representation].each do |method|
           raise ArgumentError, "It was expected to load a #{self.class.name}ConcreteBuilder module from #{path_to_templates_directory}/builders/pdm that implements the method #{method}, but the one provided does not have this method implemented" unless self.respond_to? method
        end
    end
end