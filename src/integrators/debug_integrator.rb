class DebugIntegrator
  # Use this integrator for debugging purposes. For example, you can simply return a white spectrum
  # if the ray hits something, and black otherwise. Any other visualization of data associated
  # with a hit record may be useful.  
  require_relative '../integrator.rb'
  include Integrator
  
  attr_accessor :scene
  
  def initialize scene
    @scene = scene
  end
  
  # Return some value useful for debugging.
  def integrate primary_ray
    hit_record = @scene.get_intersectable.intersect(ray)
    contribution = Spectrum.new(0.0)
    unless hit_record.nil?
      if hit_record.t > 0.0
        # render green if hit point was "in front" of ray origin
        contribution = Spectrum.new(Vector3f.new(0.0,1.0,0.0))
      else
        # color red if ray hit from behind
        contribution = Spectrum.new(Vector3f.new(1.0,0.0,0.0))
      end
    end
    contribution
  end
  
  # Make sample budget for a pixel. Since this integrator only samples the 2D 
  # pixel area itself, the samples are 2D.
  # 
  # @param sampler the sampler to be usef for generating the samples
  # @param n the desired number of samples
  def make_pixel_samples(sampler, n)
    sampler.make_samples(n, 2);
  end
  
end