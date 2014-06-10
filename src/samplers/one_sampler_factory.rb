class OneSamplerFactory
  require_relative '../sampler_factory'
  require_relative 'one_sampler'
  include SamplerFactory
  
  def initialize
  end
  
  def make
    OneSampler.new
  end
end