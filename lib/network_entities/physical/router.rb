require_relative '../abstracts/network_element.rb'

class Router < NetworkElement
    
    attr_reader :priority_weights, :buffer
    
    def initialize(id, priority_weights=[1], buffer=-1)
        @priority_weights = priority_weights
        @buffer = buffer
        super id
    end 
end