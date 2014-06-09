class CameraTestScene
  require_relative '../scene.rb'
  
  include Scene
  def initialize(width, height, spp)
    @width = width
    @height = height
    @spp = spp
    @output_filename = "camera_test_scene_#{spp}samples"
    
    
    eye = Vector3f.new(0.0, 0.0, 3.0)
    look_at = Vector3f.new(0.0, 0.3, 3.0)
    up = Vector3f.new(0.0, 1.0, 0.0)
    fov = 60.0
    aspect = @width.to_f / @height.to_f
    
    camera_args = {:eye => eye,
            :look_at => look_at,
            :up => up,
            :fov => fov,
            :aspect_ratio => aspect,
            :width => @width,
            :height => @height}
            
    @camera = Camera.new camera_args
    
    
    
  end
end