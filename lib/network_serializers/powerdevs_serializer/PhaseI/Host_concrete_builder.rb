module HostConcreteBuilder    
    def build_output_representation
"     Atomic
        {
            Name = #{id}
            Ports = #{in_elements.size} ; #{out_elements.size}
            Path = PhaseI/FelixServer.h
            Description = Generates jobs. Distribution for the rate and jobSize are retrieved from the Flows assigned to this server
            Graphic
                {
                Position = #{-9975 + 750 * (my_number - 1)} ; -10285
                Dimension = 700 ; 700
                Direction = Down
                Color = 15
                Icon = %datanetworks%generator.png
                }
            Parameters
                {
                }
         }
      "
    end
      
end