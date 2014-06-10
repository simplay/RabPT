class PointLight
  # Implements a point light using a PointLightMaterial.
  require_relative '../light_geometry.rb'
  require_relative '../materials/point_light_material.rb'
  include LightGeometry
  
  attr_accessor :position,
                :material 
  
  def initialize(position, emission)
    @position = position.s_copy
    @material = PointLightMaterial.new(emission)
  end
  
  # a ray cannot be intersected by a ray
  def intersect ray
    nil
  end
  
  # Sample a point on the light geometry.
  def sample
    hit_record_args = {
      :position => @position.s_copy,
      :material => @material,
      :p => 1.0
    }
    
    HitRecord.new hit_record_args
  end
  
  def bounding_box
    nil
  end
  
end