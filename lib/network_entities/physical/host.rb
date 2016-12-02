require_relative '../abstracts/network_element.rb'

class Host < NetworkElement
  attr_accessor :gateway_id, :gateway_port, :queue_capacity, :ips, :mac
  
	def initialize(id, ips=["127.0.0.1"], mac="9A:4A:43:D4:36:45", queue_capacity=-1)		
		@ips = ips
		@mac = mac
		@queue_capacity = queue_capacity
		super id
	end
end