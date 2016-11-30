require_relative '../abstracts/network_element.rb'

class Host < NetworkElement
  attr_accessor :gateway_id, :gateway_port, :queue_capacity
  
	def initialize(id, queue_capacity=-1)		
		@queue_capacity = queue_capacity
		super id
	end
end