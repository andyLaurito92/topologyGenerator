module FlowConcreteBuilder
    def build_output_representation
        scilab_definition = build_scilab_definition
        cplusplus_definition = build_cplusplus_definition
        {'scilab'=>scilab_definition, 'cplusplus'=>cplusplus_definition}
    end

    def build_scilab_definition
        scilab_flows_definition = ''
        scilab_flows_definition += "\n"
        scilab_flows_definition += build_parameter_flow_distribution 'periodDistribution', distribution_rate
        scilab_flows_definition += build_parameter_flow_distribution 'packetSizeDistribution', distribution_size
        scilab_flows_definition
    end

    def build_parameter_flow_distribution(distribution_name, distribution_variable)
        scilab_flow_parameter_distribution = ''
        case distribution_variable
        when ConstantDistribution
            scilab_flow_parameter_distribution = "flow#{@id}.#{distribution_name} =  DISTRIBUTION_CONSTANT;\n"            
            scilab_flow_parameter_distribution += "flow#{@id}.#{distribution_name}_value = #{distribution_variable.value};   // (in bits) value for the constant distribution\n"
        when ExponentialDistribution
            scilab_flow_parameter_distribution = "flow#{@id}.#{distribution_name} =  DISTRIBUTION_EXPONENTIAL;\n"
            scilab_flow_parameter_distribution += "flow#{@id}.#{distribution_name}_mu = #{distribution_variable.mu};   // (in seconds) mean for the exponential distribution.\n"
        when NormalDistribution
            scilab_flow_parameter_distribution = "flow#{@id}.#{distribution_name} =  DISTRIBUTION_NORMAL;\n"
            scilab_flow_parameter_distribution += "flow#{@id}.#{distribution_name}_mu = #{distribution_variable.mu}; \n"
            scilab_flow_parameter_distribution += "flow#{@id}.#{distribution_name}_var = #{distribution_variable.var}; \n"
        when ParetoDistribution
            scilab_flow_parameter_distribution = "flow#{@id}.#{distribution_name} =  DISTRIBUTION_PARETO;\n"
            scilab_flow_parameter_distribution += "flow#{@id}.#{distribution_name}_val1 = #{distribution_variable.val_1}; \n"
            scilab_flow_parameter_distribution += "flow#{@id}.#{distribution_name}_val2 = #{distribution_variable.val_2}; \n"
            scilab_flow_parameter_distribution += "flow#{@id}.#{distribution_name}_mean = #{distribution_variable.mean}; \n"
        when SplitDistribution
            scilab_flow_parameter_distribution = "flow#{@id}.#{distribution_name} =  DISTRIBUTION_SPLIT;\n"
            scilab_flow_parameter_distribution += "flow#{@id}.#{distribution_name}_shape = #{distribution_variable.shape}; \n"
            scilab_flow_parameter_distribution += "flow#{@id}.#{distribution_name}_scale = #{distribution_variable.scale}; \n"
        else
            raise "Distribution provided has a class which was unexpected. Class was: #{distribution_variable.class}"
        end
        scilab_flow_parameter_distribution
    end

  def build_cplusplus_definition
          start_time_of_flow = 0
          # flow
          cplusplus_flows_definition = "\n"
          cplusplus_flows_definition += "\t ///// definition of flow #{@id} \n"
          cplusplus_flows_definition += "\t auto flow#{@id}PeriodDistribution = readDistributionParameter(\"flow#{@id}.periodDistribution\"); \n"
          cplusplus_flows_definition += "\t auto flow#{@id}PacketSizeDistribution = readDistributionParameter(\"flow#{@id}.packetSizeDistribution\"); \n"
          cplusplus_flows_definition += "\t auto flow#{@id} = std::make_shared<Flow>(\"#{@id}\", #{start_time_of_flow} /*startTime*/, #{priority} /*typeOfService*/, flow#{@id}PeriodDistribution, flow#{@id}PacketSizeDistribution); \n"
                 
          #routes
          cplusplus_flows_definition += "\t // routes for flow #{@id} \n"
          paths.each_with_index do |path, index| #  add each route/path in the flow       
            cplusplus_flows_definition += "\t auto flow#{@id}_route#{index} = std::make_shared<Route>( std::deque<Route::Node>{ \n"
            path.links.each do |link|
                cplusplus_flows_definition += "\t\t\t {#{link.src_port}, \"#{link.src_element.id}.Routing\"}, \n"
            end
            last_link = path.links.last        
            cplusplus_flows_definition += "\t\t\t {#{last_link.dst_port}, \"#{last_link.dst_element.id}.Routing\"} \n"
            cplusplus_flows_definition += "\t });"
            cplusplus_flows_definition += "\t \n"
          end 
          
          
          # registrations
          cplusplus_flows_definition += "\t // register flow #{@id} with its routes\n"
          unique_sources = paths.map{ |path| path.links.first.src_element.id }.uniq{|id| id}  # only add unique sources
          unique_sources.each do |source|
            cplusplus_flows_definition += "\t FlowDefinitions::registerFlowSourceNode(flow#{@id}, \"#{source}.GeneratorApplication\");  \n"  
          end
          
          paths.each_with_index do |path, index| #  register each route/path in the flow  for each route
            cplusplus_flows_definition += "\t FlowDefinitions::registerFlowRoute(flow#{@id}, flow#{@id}_route#{index});  \n"
          end
                  
          cplusplus_flows_definition += "\t \n"
          
          cplusplus_flows_definition
      end
end