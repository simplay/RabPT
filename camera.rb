# Pinwhole camera model - later introduce additional models.
# C transformation matric from world to camera space.
# Cinv is transofrmation matrix from world coordinates to camera space.



require File.join(File.dirname(__FILE__), 'util/vector3f.rb')




class Camera
  attr_accessor :eye,
                :look_at,
                :up,
                :fov,
                :aspect_ratio,
                :width,
                :height,
                :C, 
                :Cinv
  
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
    
    Camera.compute_camera_matrix
    Camera.compute_image_corners
    
  end
  
  private
  
  def self.compute_camera_matrix
  
  end
  
  def self.compute_image_corners
  
  end
  
end