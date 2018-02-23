# Defines scene properties that need to be made accessible to the renderer.
module Scene
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
