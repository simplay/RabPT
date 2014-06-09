class Scene
  require File.join(File.dirname(__FILE__), '../util/vector3f.rb')
  require File.join(File.dirname(__FILE__), '../util/matrix4f.rb')
  require File.join(File.dirname(__FILE__), 'camera.rb')

  
  attr_accessor :SPP, :width, :height, :camera
  
  def initialize(options = {})
    options.each do |key, val|
      send("#{key}=",val)
    end

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