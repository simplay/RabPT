# Construct a plane given its normal @param n and distance to the origin @param
# d. Note that the distance is along the direction that the normal points.  The
# sign matters!
#
# @param normal
#   normal of the plane
#
#  @param d
#   distance to origin measured along normal direction
class Plane
  include Intersectable

  attr_accessor :material,
                :normal,
                :distance

  def initialize(material, normal, distance)
    @material = material
    @normal   = normal.s_copy
    @distance = distance
  end

  # plane-ray intersection
  # ray p(t) = orig+t*dir
  # implicit plane: f(p) = dot(n,(p-a))
  # intersection: f(p(t)) = 0. Solve for t.
  # plug t_i into p(t_i) will give intersection point
  def intersect(ray)
    cos_theta = normal.dot(ray.direction)
    return nil if cos_theta.zero?

    t = -(normal.dot(ray.origin) + distance) / cos_theta;
    return nil if t <= 0.0

    ray_dir = ray.direction.s_copy
    intersection_position = ray_dir.scale(t)
                                   .add(ray.origin)

    w_in = ray.direction.s_copy
    w_in.negate
    w_in.normalize
    hit_normal = normal.s_copy

    tangent = Vector3f.new(1.0, 0.0, 0.0).cross(hit_normal)

    hash = {
      t: t,
      position: intersection_position,
      normal: hit_normal,
      tangent: tangent,
      w: w_in,
      intersectable: self,
      material: material,
      u: 0.0,
      v: 0.0
    }

    hit_record = HitRecord.new(hash)
    tbs_inv = hit_record.tbs.s_copy.invert
    localspace_position = intersection_position.s_copy
                                               .transform(tbs_inv)

    # Apply clipping to range [0, 1] by applying modulo 1:
    hit_record.u = localspace_position.x.abs % 1
    hit_record.v = localspace_position.y.abs % 1

    hit_record
  end
end
