module CsgSolid
  require File.join(File.dirname(__FILE__), 'interval_boundary.rb')
  
  attr_accessor :material
  
  # returns hit_record of ray with given solid              
  def intersect ray
    interval_boundaries(ray).each do |boundary|
      first_hit = boundary.hit_record
      if !first_hit.nil? && first_hit.t > 0.0
        first_hit.intersectable = self
        return first_hit;
      end      
    end
    return nil
  end
  
  # cos_theta is angle between suface normal
  # at point where ray hit onto and ray's direction
  # vector.
  def boundary_type(hit_record, ray)
    cos_theta = hit_record.dot(ray.direction)
    (cos_theta < 0.0) ? BoundaryType::START : BoundaryType::END
  end
  
  def interval_boundaries ray
    raise "not implemented"
  end
  
  protected
  
  # this acts as an inherited enum
  class BoundaryType
    START = :start
    END = :end
  end
  
  # this acts as an inherited enum
  class BelongsTo
    LEFT = :left
    RIGHT = :right
  end
  
end