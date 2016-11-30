module LinkConcreteBuilder
    def build_output_representation
"   Coupled
      {
      Type = Coordinator
      Name = #{@id}
      Ports = 1; 1
      Description = Coupled DEVS model
      Graphic
          {
          Position = #{-9975 + 750 * (@my_number - 1)}; -9870
          Dimension = 645; 705
          Direction = Down
          Color = 15
          Icon = %datanetworks%ethernet.jpg
          Window = 5000; 5000; 5000; 5000
          }
      Parameters
          {
          }
      System
          {
          Inport
              {
              Name = Inport0
              CoupledPort = 1
              Description =
              Graphic
                  {
                  Position = -4740 ; -3525
                  Dimension = 480
                  Direction = Right
                  }
              }
          Outport
              {
              Name = Outport0
              CoupledPort = 1
              Description =
              Graphic
                  {
                  Position = -930 ; 2850
                  Dimension = 360
                  Direction = Right
                  }
              }
          Atomic
              {
              Name = InNICQueue
              Ports = 2 ; 2
              Path = PhaseI/NetworkQueue.h
              Description = In0 Incomming packets to queueIn1 Incoming signal to request dequeueOut0 Outgoing dequeued packetsOut1 Outgoing queue lenght informationQueues incoming packets and enqueues them as required by aexternal entity. FIFO Policy (FirstInFirstOut). Provides information its internal state.
              Graphic
                  {
                  Position = -3855 ; -1230
                  Dimension = 675 ; 675
                  Direction = Down
                  Color = 15
                  Icon = %datanetworks%queue.png
                  }
              Parameters
                  {
                  MaxCapacity = Str; FelixNICQueue1.maxBuffer ; Queue Capacity in Bytes. (Use -1 for INF capacity)
                  ForcedPeriod = Str; -1 ; Force minimum period to transition. Use -1 for INF
                  }
              }
          Atomic
              {
              Name = Link
              Ports = 1 ; 1
              Path = PhaseI/Link.h
              Description = Vector to scalar signal
              Graphic
                  {
                  Position = -3990 ; 585
                  Dimension = 630 ; 630
                  Direction = Down
                  Color = 15
                  Icon = %vectors%vec2scalar.svg
                  }
              Parameters
                  {
                  link.capacity = Str; FelixLink.capacity ; Signal Index
                  link.delay = Str; link.delay ;
                  }
              }
          Point
              {
              ConectedLines = 3 ; 4 ; 5
              ConectedExtrems = Org ; Org ; Org
              Position = -3675 ; 1950
              }
          Line
              {
              Source = Prt ;  1 ;  1 ; 0
              Sink = Cmp ;  1 ;  1 ; -1
              PointX = -4125 ; -3675 ; -3675
              PointY = -3525 ; -3525 ; -1365
              }
          Line
              {
              Source = Cmp ;  1 ;  1 ; 0
              Sink = Cmp ;  2 ;  1 ; -1
              PointX = -3675 ; -3675 ; -3675
              PointY = -450 ; -450 ; 435
              }
          Line
              {
              Source = Cmp ;  2 ;  1 ; 0
              Sink = Pnt ;  1 ; -1 ; 0
              PointX = -3675 ; -3675 ; -3675
              PointY = 1350 ; 1350 ; 1950
              }
          Line
              {
              Source = Cmp ;  1 ;  2 ; -1
              Sink = Pnt ;  1 ; -1 ; 0
              PointX = -3375 ; -3375 ; -2325 ; -2325 ; -3675
              PointY = -1365 ; -1650 ; -1650 ; 1950 ; 1950
              }
          Line
              {
              Source = Pnt ;  1 ; -1 ; 0
              Sink = Prt ;  2 ;  1 ; -1
              PointX = -3675 ; -3675 ; -1065 ; -1065
              PointY = 1950 ; 2775 ; 2775 ; 2850
              }
          }
      }
      "
    end
   
    def create_pdm_line_between_src_and_dst(src_element_pdm_pos, dst_element_pdm_pos, link_element_pdm_pos)
    "Line
                       {
                       Source = Cmp ;  #{src_element_pdm_pos} ;   #{@src_port + 1} ; 0
                       Sink = Cmp ;  #{link_element_pdm_pos} ;  1 ; -1
                       PointX = -9675 ; -9675 ; -9675
                       PointY = -10350 ; -10350 ; -9990
                       }
                       Line
                       {
                       Source = Cmp ;  #{link_element_pdm_pos} ;  1 ; 0
                       Sink = Cmp ;  #{dst_element_pdm_pos} ;  #{@dst_port + 1} ; -1
                       PointX = -9675 ; -9675 ; -9675
                       PointY = -10350 ; -10350 ; -9990
                       }
                       "
  end
end