require_relative '../intersectable.rb'
require_relative '../ray.rb'
require_relative '../hit_record.rb'

class Sphere
  include Intersectable

  attr_accessor :center,
                :radius,
                :material

  # @param material:Material material of sphere
  # @param center:Vector3f center of sphere
  # @param radius:Float radius of sphere
  def initialize(material, center, radius)
    @material = material
    @center   = center
    @radius   = radius
  end

  # ray: r(t) = orig + t*dir
  # sphere: S(x,y,z)
  #   = (x-cx)^2 + (y-cy)^2 + (z-cz)^2 - R^2 = 0
  # Solve S(r(t)) = 0 for t
  # @param ray incident hitting us: Ray
  # @return HitRecord
  def intersect(ray)
    zeros = find_intersection_parameter(ray)
    return nil if zeros.nil?

    # zeros = zeros.sort
    return make_hit_record(ray, zeros.first) if zeros.first.positive?
    return make_hit_record(ray, zeros.last) if zeros.last.positive?
    nil
  end

  private

  # @param ray:Ray intersection ray
  # @param t:Float param to find intersectiin point r(t)
  def make_hit_record(ray, t)
    hit_point = ray.point_at(t)
    hit_normal = hit_point.s_copy.sub(center)
    hit_normal.scale(1.0 / radius)

    w_in = ray.direction.s_copy.normalize.negate

    u = 0.5 + Math::atan2(hit_point.z, hit_point.x) / (2.0 * Math::PI)
    v = 0.5 - Math::asin(hit_point.y % 1) / Math::PI

    hit_recod_hash = {
      position: hit_point,
      normal: hit_normal,
      w: w_in,
      t: t,
      intersectable: self,
      material: material,
      u: u,
      v: v
    }

    HitRecord.new(hit_recod_hash)
  end

  # solve quadratic equation
  # a*t^2 + b*t + c = 0 for t
  def find_intersection_parameter(ray)
    a = ray.direction.dotted
    b = 2.0 * ray.direction.s_copy.dot(ray.origin.s_copy.sub(center))
    c = ray.origin.s_copy.sub(center).dotted - radius * radius
    solve_quadric(a, b, c)
  end

  # export me asap
  # solves a*t^2 + b*t + c = 0 for t
  # using midnight formula>
  # t_1, t_2 = -b +- sqrt(b^2 - 4ac) / 2a
  def solve_quadric(a, b, c)
    discriminant = b * b - 4.0 * a * c
    return nil if discriminant < 0.0

    left = -b
    right = Math::sqrt(discriminant)
    [left - right, left + right].map { |arg| arg / (2.0 * a) }
  end
end
