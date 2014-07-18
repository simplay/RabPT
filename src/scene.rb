module Scene
  require_relative '../util/calculus/algebra/matrix4f.rb'
  require_relative '../util/calculus/algebra/vector3f.rb'
  require_relative '../util/obj_reader.rb'
  require_relative 'camera.rb'
  require_relative 'integrators/debug_integrator.rb'
  require_relative 'integrators/point_light_integrator.rb'
  
  require_relative '../util/calculus/algebra/matrix4f.rb'
  # Defines scene properties that need to be made accessible to the renderer.
  attr_accessor :spp,
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
  
  def base_name
    raise "not implemented yet"
  end
  
  def file_name
    "#{base_name}_#{@spp}spp_#{@width}w_#{@height}h"
  end

end