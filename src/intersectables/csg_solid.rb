require_relative 'interval_boundary.rb'

# A CSG solid object that can be intersected by a ray. If a CSG object is
# intersected by a ray, we determine all intersection intervals and their
# boundaries, that is, the intervals along the ray where the ray is either
# inside or outside the object. Each interval has two boundaries, a start and
# an end, where the ray enters and leaves the solid. The actual intersection
# point with the object is the first interval boundary where the ray enters the
# object the first time.
module CsgSolid
  attr_accessor :material

  # returns hit_record of ray with given solid
  def intersect(ray)
    interval_boundaries(ray).each do |boundary|
      first_hit = boundary.hit_record
      if !first_hit.nil? && first_hit.t > 0.0
        first_hit.intersectable = self
        return first_hit;
      end
    end
    nil
  end

  # cos_theta is angle between suface normal
  # at point where ray hit onto and ray's direction
  # vector.
  def boundary_type(hit_record, ray)
    cos_theta = hit_record.dot(ray.direction)
    (cos_theta < 0.0) ? BoundaryType::START : BoundaryType::END
  end

  # Compute the boundaries of the intersection intervals of this CSG solid with
  # a ray.
  #
  # @param ray the ray that intersects the CSG solid
  # @return boundaries of intersection intervals
  def interval_boundaries ray
    raise "not implemented"
  end

  protected

  # this acts as an inherited enum
  class BoundaryType
    START = :start
    FRONT = :end
  end

  # this acts as an inherited enum
  class BelongsTo
    LEFT = :left
    RIGHT = :right
  end
end
