require_relative '../../behaviors/serialize_behavior.rb'

class NetworkElement
  include SerializeBehavior

  attr_reader :id, :my_number, :out_elements, :in_elements

	def initialize(id)
    @my_number = self.increase_quantity_in_one 
		@id = id
    @out_elements = [] 
    @in_elements = []
	end
	
  def increase_quantity_in_one
      @@quantity ||= 0
      @@quantity += 1
  end 
end