require 'spec_helper'

describe Topologygenerator do
    context 'it fails when' do
        it 'an instance is created without source' do
            expect{ Topologygenerator.new({"directory_concrete_builders" => "test1",
                "output_directory" => "test2",
                "uri_resource" => "test3" 
            })}.to raise_error ArgumentError, "It is mandatory that arguments has a source"
        end

        it 'an instance is created without directory_concrete_builders' do
            expect{ Topologygenerator.new({"source" => "test1","output_directory" => "test2",
                "uri_resource" => "test3" 
            })}.to raise_error ArgumentError, "It is mandatory that arguments has a directory_concrete_builders"
        end

        it 'an instance is created without output_directory' do
            expect{ Topologygenerator.new({"source" => "test1",
                "directory_concrete_builders" => "test2",
                "uri_resource" => "test3" 
            })}.to raise_error ArgumentError, "It is mandatory that arguments has a output_directory"
        end

        it 'an instance is created without uri_resource' do
            expect{ Topologygenerator.new({"source" => "test1",
                "output_directory" => "test2",
                "directory_concrete_builders" => "test3" 
            })}.to raise_error ArgumentError, "It is mandatory that arguments has a uri_resource"
        end
    end

    context 'when parameters are well given' do
        it 'has a version number' do
            expect(Topologygenerator::VERSION).not_to be nil
        end
    end
end
