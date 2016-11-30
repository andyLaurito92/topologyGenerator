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

  spec.summary       = %q{Build a topology from a source provider and writes it using a builder.}
  spec.description   = %q{The topologygenerator gem is a tool for building from a network topology a custom output. 
                          This network topology can be obtained from a custom file written in ruby by the user, or 
                          by a SDN controller specifying the API uri (actually ONOS is support, and we are working 
                          for OpenDayLight support).
                          In case of the custom output, you have to write for each class defined in the network topology, 
                          a module that describes how to build this class. The topologygenerator gem will then use this 
                          module's defined to generate the output desired.
                          You can see examples of use in my public github webpage.
                           }
  spec.homepage      = "https://github.com/andyLaurito92"
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
