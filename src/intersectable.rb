#An intersectable supports ray-surface intersection.
module Intersectable

  # Implement ray-surface intersection in this method. Implementations of this
  # method need to make and return a HitRecord correctly, following the
  # conventions of assumed for HitRecord.
  #
  # @param r the ray used for intersection testing
  # @return a hit record, should return null if there is no intersection
  def intersect ray
    raise "not implemented yet"
  end

  def bounding_box
    raise "not implemented yet"
  end

end
