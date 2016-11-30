require_relative '../../behaviors/serialize_behavior.rb'
require_relative '../../flows_distributions/constant_distribution.rb'
require_relative '../../flows_distributions/exponential_distribution.rb'
require_relative '../../flows_distributions/normal_distribution.rb'
require_relative '../../flows_distributions/pareto_distribution.rb'
require_relative '../../flows_distributions/split_distribution.rb'

class Flow
    include SerializeBehavior

    attr_accessor :id, :priority, :paths, :distribution_rate, :distribution_size

    def initialize(id, priority, paths, distribution_rate, distribution_size)
        raise "Invalid 'priority' argument received. Priority must be a number, #{priority} was received" unless priority.is_a? Integer
        raise "Invalid 'paths' argument received. 'paths' must be an instance of Arry class, however the path received has class #{paths.class}" unless paths.is_a? Array
        raise "Invalid 'distribution_rate' received. Distribution rate cannot be nil" unless distribution_rate
        raise "Invalid 'distribution_size' received. Distribution size cannot be nil" unless distribution_size
        raise "Invalid 'distribution_rate' #{distribution_rate}. It is expected that the rate is an instance of a distribution" unless [ConstantDistribution, ExponentialDistribution, NormalDistribution, ParetoDistribution, SplitDistribution].include? distribution_rate.class
        raise "Invalid 'distribution_size' #{distribution_size}. It is expected that the size is an instance of a distribution" unless [ConstantDistribution, ExponentialDistribution, NormalDistribution, ParetoDistribution, SplitDistribution].include? distribution_size.class

        @id = id
        @priority = priority
        @paths = paths
        @distribution_rate = distribution_rate
        @distribution_size = distribution_size
    end
end