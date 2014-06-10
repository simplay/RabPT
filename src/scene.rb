module Scene
  require_relative '../util/matrix4f.rb'
  require_relative '../util/vector3f.rb'
  require_relative 'camera.rb'
  require_relative 'integrators/debug_integrator.rb'
  require_relative 'integrators/point_light_integrator.rb'
  
  require_relative '../util/matrix4f.rb'
  # Defines scene properties that need to be made accessible to the renderer.
  attr_accessor :output_filename,
                :spp,
                :width,
                :height,
                :camera,
                :integrator_factory,
                :sampler_factory,
                :root,
                :light_list,
                :film
  
  def prepare
    raise "not implemented yet"
  end
  
end