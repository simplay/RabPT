class Plane
  require_relative '../intersectable.rb'
  require_relative '../ray.rb'
  require_relative '../hit_record.rb'
  
  include Intersectable
  
  # Construct a plane given its normal @param n and distance to the origin @param
  # d. Note that the distance is along the direction that the normal points.
  # The sign matters!
  # 
  # @param normal
  #   normal of the plane
  #
  #  @param d
  #   distance to origin measured along normal direction 
  attr_accessor :material,
                :normal,
                :distance
                
  def initialize(material, normal, distance)
    @material = material
    @normal = normal.s_copy
    @distance = distance
  end
  
  # plane-ray intersection
  # ray p(t) = orig+t*dir
  # implicit plane: f(p) = dot(n,(p-a))
  # intersection: f(p(t)) = 0. Solve for t.
  # plug t_i into p(t_i) will give intersection point
  def intersect ray
    cos_theta = @normal.dot(ray.direction)
    if (cos_theta != 0.0)
      t = -(@normal.dot(ray.origin) + @distance) / cos_theta;
      ray_dir = ray.direction.s_copy
      intersection_position = ray_dir.scale(t).add(ray.origin)
      w_in = ray.direction.s_copy
      w_in.negate
      w_in.normalize
      hit_normal = @normal.s_copy
         
      tangent = Vector3f.new(1.0, 0.0, 0.0).cross(hit_normal)
      
      # TODO implement texture coordinates for planes 
      hash = {:t => t,
              :position => intersection_position,
              :normal => hit_normal,
              :tangent => tangent,
              :w => w_in,
              :intersectable => self,
              :material => @material,
              :u => 0.0,
              :v => 0.0}

      hit_record = HitRecord.new hash
      tbs_inv = hit_record.tbs.s_copy.invert
      localspace_position = intersection_position.s_copy.transform(tbs_inv)
      
      # apply clipping by applying modulo 1
      hit_record.u = localspace_position.x.abs % 1 
      hit_record.v = localspace_position.y.abs % 1 
      
      return (t > 0.0) ? hit_record : nil 
    end
    return nil
  end
end