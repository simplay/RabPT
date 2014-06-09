module Scene
  # Defines scene properties that need to be made accessible to the renderer.
  attr_accessor :output_filename,
                :spp,
                :width,
                :height,
                :camera,
                :integratior_factory,
                :sampler_factory,
                :root,
                :light_list
  
  def prepare
    raise "not implemented yet"
  end
  
end