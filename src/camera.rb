# Pinwhole camera model - later introduce additional models.
# C transformation matric from world to camera space.
# Cinv is transofrmation matrix from world coordinates to camera space.



require File.join(File.dirname(__FILE__), '../util/vector3f.rb')




class Camera
  attr_accessor :eye,
                :look_at,
                :up,
                :fov,
                :aspect_ratio,
                :width,
                :height,
                :C, 
                :Cinv,
                :angularFov,
                :t,
                :b,
                :r,
                :l,
                :camera_matrix
  
  # @param eye from position of camera
  # @param lookAt to position of camera
  # @param up height
  # @param fov field of view angle [degree]
  # @param aspect aspect retio w/h
  # @param width image width
  # @param height image height
  def initialize(args = {}) 
    args.each do |key, value|
      send("#{key}=", value)
    end
    compute_camera_matrix
    compute_image_corners
  end
  
  private
  
  def compute_camera_matrix
    from = Vector3f.new(@eye.x, @eye.y, @eye.z)
    to = Vector3f.new(@look_at.x, @look_at.y, @look_at.z)
    up = Vector3f.new(@up.x, @up.y, @up.z)
    
    # z-axis
    w = Vector3f.new(from.x, from.y, from.z)
    w.sub(to)
    w.normalize
    zc = Vector4f.new(w.x, w.y, w.z, 0.0)
    
    # x-axis
    u = up.cross(w)
    u.normalize
    xc = Vector4f.new(u.x, u.y, u.z, 0.0)
    
    # y-axis
    v = w.cross(u)
    yc = Vector4f.new(v.x, v.y, v.z, 0.0)
    e = Vector4f.new(from.x, from.y, from.z, 1.0)
    
    @camera_matrix = Matrix4f.new(nil, nil, nil, nil)
    @camera_matrix.set_column_at(1, xc)
    @camera_matrix.set_column_at(2, yc)
    @camera_matrix.set_column_at(3, zc)
    @camera_matrix.set_column_at(4, e)
  end
  
  def compute_image_corners
    @angularFov = Math::PI * (fov / 180.0);
    @t = Math::tan(angularFov/2.0.to_f);
    @b = -t;
    @r = aspect_ratio*t;
    @l = -r;
  end
  
end