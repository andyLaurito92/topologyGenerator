#!/usr/bin/env ruby

require_relative 'command_line/command_line_arguments.rb'
require_relative "./topology_generator.rb"
require 'colorize'

begin
    my_command_line_arguments = CommandLineArguments.new
    my_command_line_arguments.run

    raise ArgumentError, 'No arguments received' unless arguments
    [:source,:directory_concrete_builders,:output_directory, :uri_resource].each do |argument_name|
      raise ArgumentError, "It is mandatory that arguments has a #{argument_name}" unless arguments.key? argument_name
    end

    topo_gen = topologygenerator.new({
            "source" => my_command_line_arguments.source
            "directory_concrete_builders" => my_command_line_arguments.directory_concrete_builders,
            "output_directory" => my_command_line_arguments.output_directory,
            "uri_resource" => my_command_line_arguments.uri_resource
        })
    topo_gen.generate
rescue Exception => ex
  puts "#{ex.class}".red 
  puts "#{ex.message}".blue
end
