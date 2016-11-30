module OutputConcreteBuilder
    OUTPUT_PDM_FILE_NAME = 'topology.pdm'
    OUTPUT_CPP_FILE_NAME = 'FlowDefinitions.cpp'
    OUTPUT_SCILAB_FILE_NAME = 'flows_definition.scilabParams'

    def initialize_concrete_builder(topology_provider, directory_concrete_builders, output_directory)
        @topology_provider = topology_provider
        @directory_concrete_builders = directory_concrete_builders # make's sense?
        @output_directory = output_directory
    end

    def build_output_content
        build_pdm_output

        build_flow_output
    end

    def build_pdm_output
        graph_elements = topology_provider.get_topology
        
        graph_elements = graph_elements.select { |elem| [Host,Link,Router].include? elem.class }

        pdm_topology = PDM_INITIAL_STRUCTURE 

        graph_elements.each do |element|
            pdm_topology += element.transform_to_output_representation @directory_concrete_builders
        end
        
        pdm_topology += create_lines_between_graph_elements graph_elements

        pdm_topology += PDM_FINAL_STRUCTURE

        write_file "#{@output_directory}/#{OUTPUT_PDM_FILE_NAME}",
                    pdm_topology
    end

    def create_lines_between_graph_elements(graph_elements)
        links = graph_elements.select { |node| node.is_a? Link }
        lines = ''
        links.each do |link|
            src_pdm_pos = get_pdm_position link.src_element
            dst_pdm_pos = get_pdm_position link.dst_element
            link_pdm_pos = get_pdm_position link
            lines += link.create_pdm_line_between_src_and_dst src_pdm_pos, dst_pdm_pos, link_pdm_pos
        end
        lines
    end

    def get_pdm_position(network_elem)
        #Here links have a modeled representation, so we have to count the link as well.
        #We have routers, hosts and links as either atomic or compunded models
        NUMBER_OF_PDM_MODELS_IN_STRUCTURE + network_elem.my_number
    end 

    def build_flow_output
        graph_elements = topology_provider.get_topology 

        flows = graph_elements.select { |elem| elem.is_a? Flow }        

        scilab_flows_definition = ''
        cplusplus_flows_defined = ''
        flows.each do |flow|
            flow_output = flow.transform_to_output_representation @directory_concrete_builders
            scilab_flows_definition += flow_output['scilab']
            cplusplus_flows_defined += flow_output['cplusplus']
        end

        write_file "#{@output_directory}/#{OUTPUT_SCILAB_FILE_NAME}",
                    scilab_flows_definition

        write_file  "#{@output_directory}/#{OUTPUT_CPP_FILE_NAME}",
                   (build_cplusplus_output cplusplus_flows_defined)
    end

    def build_cplusplus_output(cplusplus_flows_defined)
        cplusplus_flows_definition = "#include \"FlowDefinitions.h\" \n"
        cplusplus_flows_definition += "\n"
        cplusplus_flows_definition += "std::multimap<std::string, std::shared_ptr<Flow>> FlowDefinitions::Flows; \n"
        cplusplus_flows_definition += "\n"
        cplusplus_flows_definition += "void FlowDefinitions::defineFlows(){ \n"
        cplusplus_flows_definition += "\n"
        cplusplus_flows_definition += cplusplus_flows_defined
        cplusplus_flows_definition += '}'
        cplusplus_flows_definition
    end   
end
