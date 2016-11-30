class SplitDistribution
	attr_reader :shape, :scale
	
	def initialize(shape, scale)
		@shape = shape
		@scale = scale
	end
end