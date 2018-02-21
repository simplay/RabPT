require_relative '../integrator.rb'

# Use this integrator for debugging purposes. For example, you can simply
# return a white spectrum if the ray hits something, and black otherwise. Any
# other visualization of data associated with a hit record may be useful.
class DebugIntegrator
  include Integrator

  attr_accessor :scene

  def initialize(scene)
    @scene = scene
  end

  # @param ray [Ray]
  def integrate(ray)
    hit_record = scene.root.intersect(ray)
    contribution = Spectrum.new(0.0)

    return contribution if hit_record.nil?

    if hit_record.positive?
      # render green if hit point was "in front" of ray origin
      Spectrum.new(Vector3f.new(0.0, 1.0, 0.0))
    else
      # color red if ray hit from behind
      Spectrum.new(Vector3f.new(1.0, 0.0, 0.0))
    end
  end

  # Make sample budget for a pixel. Since this integrator only samples the 2D
  # pixel area itself, the samples are 2D.
  #
  # @param sampler the sampler to be usef for generating the samples
  # @param n the desired number of samples
  def make_pixel_samples(sampler, n)
    sampler.make_samples(n, 2)
  end
end
