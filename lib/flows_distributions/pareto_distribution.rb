class ParetoDistribution
	attr_reader :val_1, :val_2, :mean
	
	def initialize(val_1, val_2, mean)
		@val_1 = val_1
		@val_2 = val_2
		@mean = mean
	end
end