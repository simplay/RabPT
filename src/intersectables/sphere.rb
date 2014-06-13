class Sphere
  require_relative '../intersectable.rb'
  require_relative '../ray.rb'
  require_relative '../hit_record.rb'
  
  include Intersectable
  
  attr_accessor :center,
                :radius,
                :material
  
  def initialize args
    args.each do |key, value|
      send("#{key}=", value)
    end
  end
  
  # ray: r(t) = orig + t*dir
  # sphere: S(x,y,z) 
  #   = (x-cx)^2 + (y-cy)^2 + (z-cz)^2 - R^2 = 0
  # Solve S(r(t)) = 0 for t
  # @param ray incident hitting us: Ray
  # @return HitRecord
  def intersect ray
    zeros = (find_intersection_parameter ray).sort
    (zeros.min > 0.0) ? make_hit_record(ray, zeros.min) : nil    
  end
  
  private
  
  # @param ray:Ray intersection ray
  # @param t:Float param to find intersectiin point r(t)
  def make_hit_record(ray, t)
    hit_point = ray.point_at(t)
    hit_normal = hit_point.s_copy.sub(@center)
    hit_normal.scale(1.0/@radius)
    
    w_in = ray.direction.s_copy.normalize.negate
    
    u = 0.5 + Math::atan2(hit_point.z, hit_point.x)/(2.0*Math::PI)
    v = 0.5 - Math::asin(hit_point.y)/Math::PI
    
    hit_recod_hash = {
      :position => hit_point,
      :normal => hit_normal,
      :w => w_in,
      :t => t,
      :intersectable => self,
      :material => @material,
      :u => u,
      :v => v
    }
    
    HitRecord.new hit_recod_hash
  end
  
  # solve quadratic equation 
  # a*t^2 + b*t + c = 0 for t
  def find_intersection_parameter ray
    a = ray.direction.dotted
    b = 2.0*ray.origin.s_copy.dot(@center)
    c = @origin.dotted - @radius*@radius
    solve_quadric(a, b, c).map &:to_f
  end
  
  # export me asap
  # solves a*t^2 + b*t + c = 0 for t
  # using midnight formula>
  # t_1, t_2 = -b +- sqrt(b^2 - 4ac) / 2a
  def solve_quadric(a, b, c)
    left = -b
    right = Math::sqrt(b*b-4.0*a*c)
    [left-right, left+right].map {|arg| arg / 2.0*a}
  end
  
end