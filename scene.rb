class Scene
  require File.join(File.dirname(__FILE__), 'util/vector3f.rb')
  require File.join(File.dirname(__FILE__), 'camera.rb')
  require File.join(File.dirname(__FILE__), 'util/matrix4f.rb')
  
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
    
    v1 = Vector4f.new(1.0, 2.0, 3.0, 4.0)
    v2 = Vector4f.new(5.0, 6.0, 7.0, 8.0)
    v3 = Vector4f.new(9.0, 10.0, 11.0, 12.0)
    v4 = Vector4f.new(13.0, 14.0, 15.0, 16.0)
    m = Matrix4f.new(v1,v2,v3,v4)
    binding.pry
  end
end