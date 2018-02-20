require_relative '../sampler_factory'
require_relative 'one_sampler'

class OneSamplerFactory
  include SamplerFactory

  def make
    OneSampler.new
  end
end
