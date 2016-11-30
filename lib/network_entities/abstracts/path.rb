class Path
	attr_reader :links, :source, :destination

	def initialize(source, destination)
    raise "Invalid 'source' argument received. Path must contain a source" unless source
    raise "Invalid 'destination' argument received. Path must contain a destination" unless destination
	  
		@source = source
		@destination = destination
		@links = []
	end

	def add_link(link)
		@links.push link
	end
end