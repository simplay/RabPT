class OneSamplerFactory
  include SamplerFactory

  def make
    OneSampler.new
  end
end
