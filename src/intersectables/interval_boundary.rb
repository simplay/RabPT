class IntervalBoundary
  
  attr_accessor :t,
                :hit_record,
                :belongs_to,
                :type
  
  def initialize(args = {})
    args.each do |key, value| 
      send("#{key}=",value)
    end
  end
  
  # 
  def compare_to other
    if @t < other.t
      return -1
    elsif @t == other.t
      return 0
    else
      return 1
    end
  end
  
  protected
  
  # cos_theta is angle between suface normal
  # at point where ray hit onto and ray's direction
  # vector.
  def boundary_type(hit_record, ray)
    cos_theta = hit_record.dot(ray.direction)
    (cos_theta < 0.0) ? BoundaryType::START : BoundaryType::END
  end

  # this acts as an inherited enum
  class BoundaryType
    START = :start
    END = :end
  end

end