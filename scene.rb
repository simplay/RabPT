class Scene
  require File.join(File.dirname(__FILE__), 'util/vector3f.rb')
    
  attr_accessor :SPP, :width, :height, :camera
  
  def initialize(options = {})
    options.each do |key, val|
      send("#{key}=",val)
    end
    
    
    # camera = new PinholeCamera(eye, lookAt, up, fov, aspect, width, height);
    
    eye = Vector3f.new(0.0, 0.0, 3.0)
    look_at = Vector3f.new(0.0, 0.3, 3.0)
    up = Vector3f.new(0.0, 1.0, 0.0)
    fov = 60.0
    aspect = @width.to_f / @height.to_f
    
  end
end