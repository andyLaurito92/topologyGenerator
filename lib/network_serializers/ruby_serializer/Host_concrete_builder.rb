module HostConcreteBuilder    
    def build_output_representation
        "hosts.push @topology.add_host \"#{id}\""
    end      
end