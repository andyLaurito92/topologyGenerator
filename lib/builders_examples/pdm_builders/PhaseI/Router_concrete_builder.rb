module RouterConcreteBuilder
    def build_output_representation
"Atomic
  {
  Name = #{@id}
  Ports = #{in_elements.size} ; #{out_elements.size}
  Path = PhaseI/Router.h
  Description = In0: Incomming packetsInN: Outgoing packets from a single flowDemultiplexes a single packet flow in N input output streams.Each output stream contains packets belonging to a single flow identifier.
  Graphic
      {
      Position = #{-9975 + 750 * (@my_number-1)} ; -8505
      Dimension = 600 ; 800
      Direction = Down
      Color = 15
      Icon = %datanetworks%router.jpg
      }
  Parameters
      {
      }
  }
"
    end
      
end