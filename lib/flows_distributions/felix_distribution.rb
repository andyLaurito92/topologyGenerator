require_relative 'normal_distribution.rb'

class FelixDistribution
    FELIX_MODE_HIGH_THROUGHOUT = "FELIX_MODE_HIGH_THROUGHOUT"
    FELIX_MODE_LOW_LATENCY = "FELIX_MODE_LOW_LATENCY"
  
    attr_reader :period, :mode, :size_bytes, :buffer_bytes, :timeout, :out_size_bytes
    
    def initialize(period, mode, size_bytes = nil, buffer_bytes = nil, timeout = nil, out_size_bytes = nil)
        @period = period #its the distribution of the message period arriving at the GBT link 
        @mode = mode #Its either FELIX_MODE_LOW_LATENCY or FELIX_MODE_HIGH_THROUGHPUT
        @size_bytes = size_bytes || (NormalDistribution.new "4*k", "1*k") #Its a distribution of the message size arriving at the GBT link
        @buffer_bytes = buffer_bytes || "1 * M"
        @timeout = timeout || 1
        @out_size_bytes = out_size_bytes || "TCP_MTU_bytes"
    end
end