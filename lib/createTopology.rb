#!/usr/bin/env ruby

require_relative 'command_line/command_line_arguments.rb'
require_relative "./topology_generator.rb"

my_command_line_arguments = CommandLineArguments.new
my_command_line_arguments.run

topo_gen = topologygenerator.new my_command_line_arguments
topo_gen.generate
