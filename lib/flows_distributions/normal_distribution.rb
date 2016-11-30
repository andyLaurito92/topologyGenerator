class NormalDistribution
	attr_reader :mu, :var
	
	def initialize(mu, var)
		@mu = mu
		@var = var
	end
end