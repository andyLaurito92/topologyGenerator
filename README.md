## What is this gem for?

This gem was designed for the SDN enviorment. The idea of this gem is to obtain from a specified provider a network topology representation, and eventually some additional properties of the network which will be used to build a custom output. 
Right now the gem supports two providers: 

1. ONOS SDN Controller( http://onosproject.org/ ): This will obtain the network using the Rest API.
2. Custom Topology: This provider allows to define a custom network using ruby, and check properties on the specified network.

This is an image that explains the above explanation.

![alt tag](images/topologygenerator.png)

As you can see, the idea is to get the network topology from a provider, and build an output using the builders implemented. The builders and providers are supposed to be implemented by users, however some examples are provided to help the development.

TODO: Add OpenDayLight Controller as provider.

## Example of use

### Case 1
Suppose that you have a network that uses SDN. You can use this gem to obtain the network topology representation from the controller, and generate a graph model from this network to check some logic properties. See Providers Examples - Controller and Builders Examples - Ruby Builder for more information.

### Case 2
Suppose that you are designing your network, and you want to check if the designed network fulfills some properties, for example that the delay from one host is less that 0.02s . You can use this gem to describe your desired network in ruby, and generate an output for a network simulator to check the desired properties. See Providers Examples - Custom and Builders Examples - PowerDevs Builder for more information.

## Who uses this gem?

This gem is used by the Haikunet programming language for getting the initial topology and perform the semantic checker analysis. For more information of Haikunet, you can check the following link: 

https://github.com/andyLaurito92/tesis/tree/master/haikunet

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'topologygenerator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install topologygenerator

## Usage

For using the topologygenerator gem, you will need to write your output builder, and specify the uri from where the initial topology information will be get. 
The use of the topology generator is as follow:

```ruby
my_topology_generator = TopologyGenerator.new({
		"source" => "name_of_my_provider", #Actually ONOS and CUSTOM are the options supported
		"directory_concrete_builders" => "my_directory", #The directory where to locate the output builders
		"output_directory" => "my_output_directory", #The directory where the output will be saved
		"uri_resource" => "path_to_source" #Must be the rest api uri if ONOS is choosed or the path of a file if CUSTOM is choosed.
	})
my_custom_topology = topology_generator.generate 
```

Suppose that you want to use the tree topology network example located at network_topologies_examples, and you want to use the PowerDevs builder located at builders_examples of this repository. This is how you would do this:

```ruby
my_topology_generator = Topologygenerator.new({
		"source" => "CUSTOM",
		"directory_concrete_builders" => "builders_examples/pdm_builders",
		"output_directory" => "output",
		"uri_resource" => "network_topologies_examples/tree_topology.rb" 
	})
my_custom_topology = topology_generator.generate
```

Now, if you want to use a ONOS controller running in your local host, and use the Ruby builder, this is what you have to do:

```ruby
my_topology_generator = Topologygenerator.new({
		"source" => "ONOS",
		"directory_concrete_builders" => "builders_examples/ruby_builders",
		"output_directory" => "output",
		"uri_resource" => "http://127.0.0.1:8181/onos/v1/docs/" 
	}) 
my_custom_topology = topology_generator.generate
```

If you need help to program either your provider or your builder, check the Providers Examples or Builders Examples for more information.

You can also use the topologygenerator as an executable throw the createTopology.rb script. For using the topologygenerator as an executable, you have to use it like this:

createTopology.rb source -n NAME_OF_SOURCE -o OUTPUT_DIRECTORY -u URI_RESOURCE -d CONCRETE_BUILDERS_DIRECTORY

Where each of the options is the same as detailed above.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andyLaurito92/topologygenerator. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

