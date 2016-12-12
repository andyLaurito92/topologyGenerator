require 'byebug'

# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'topologygenerator/version'

Gem::Specification.new do |spec|
  spec.name          = "topologygenerator"
  spec.version       = Topologygenerator::VERSION
  spec.authors       = ["Andrés Laurito"]
  spec.email         = ["andy.laurito@gmail.com"]

  spec.summary       = %q{Build a topology from a source provider and generates an output using a custom builder.}
  spec.description   = %q{The topologygenerator gem is a tool for building a custom output file format out of a 
                          given network topology. 
                          The topology can be retrieved from a custom file written in ruby by the user, or from an 
                          SDN controller (by specifying the API uri).
                          The ONOS controller is currently supported, while the API for OpenDayLight is in 
                          progress. 

                          When building your output, you have to write a module that describes how to each 
                          class defined in the network topology. The topologygenerator gem will then use the 
                            defined modules to generate the output desired. You can see examples of how to use 
                            this gem in the public github webpage.
                           }
  spec.homepage      = "https://github.com/andyLaurito92/topologygenerator"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  #if spec.respond_to?(:metadata)
  #  spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  #else
  #  raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  #end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "typhoeus"
  spec.add_development_dependency 'commander'
end
