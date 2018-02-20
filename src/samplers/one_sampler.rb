require_relative '../sampler.rb'

# Returns always one sample at 0.5 in all dimensions.
class OneSampler
  include Sampler

  def make_samples(n, d)
    sample_row = []
    d.times do
      sample_row << 0.5
    end
    [sample_row]
  end
end
