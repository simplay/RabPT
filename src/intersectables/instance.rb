class Instance  
  # when arranges a scene, we would have serveral occurences of similar object instances,
  # such as many spheres placed in our scene. instead creating many versions of 
  # the same kind of object we actually could make use of creating instances instead.
  # basicallz, an instance has a reference to a common, shadered intersectable and
  # a homogeneous tranformation which describes how an object is rotated, translated, 
  # scaled and sheared in its using scene. An instance of an intersectable then
  # never gets modified, only its transformation matrix gets updated. This allows
  # to save us from creating many similar intersectable instances, which reduces 
  # the overall memorz usage und furthermore makes it quite handz to create
  # a scene.
  
  require 'pry'
  require_relative '../intersectable.rb'
  require_relative '../ray.rb'
  require_relative '../hit_record.rb'
  
  include Intersectable
  
  ##
  # :attr_accessor: 
  #   transf: Matrix4f
  #     homogeneous tranformation
  #     described in local object coordinate system
  #     i.e. from obj. coordinates to world coords.
  #
  #   inv_transf: Matrix4f
  #     homogeneous inverse tranformation
  #     described in world coordinate system
  #     i.e. from world space coordinates to local coords.
  #
  #   trasp_inv_transf: Matrix4f
  #     homogeneous transposed inverse tranformation
  #     described in world coordinate system
  #
  #   intersectable: Intersectable
  #     a reference of an instance of an intersectable,
  #     such as a sphere or a plane for example.
  
  attr_accessor :transf,
                :inv_transf,
                :trasp_inv_transf,
                :intersectable
          
  # stores intersectable and its transformation 
  # @param intersectable:Intersectable 
  #        instance of an intersectable
  # @param transformation: Matrix4f
  #        homogeneous transformation
  #        applied on this intersectable               
  def initialize(intersectable, transformation)
    @intersectable = intersectable
    @transf = transformation
    
    @inv_transf = transformation.s_copy.inv
    @trasp_inv_transf = @inv_transf.s_copy.transpose    
  end
  
  # intersect ray with given encapsulated instance
  # delegate to instance and report its resulting
  # hitrecord.
  # Note that we have to apply the transformation
  # matrix encapsulated by this instance.
  # @param ray:Ray
  # @return HitRecord provided by intersectable
  def intersect ray
    instance_origin = ray.origin.s_copy.to_vec4f(1.0)
    instance_direction = ray.direction.s_copy.to_vec4f
    
    instance_origin.transform(Tinv)
    instance_direction.transform(Tinv)
    
    ray_args = {:origin => instance_origin.s_copy, 
                :direction => instance_direction.s_copy, 
                :t => ray.t}
    instance_ray = Ray.new ray_args
    

		hit_record = @intersectable.intersect(instance_ray);
		return nil if (hit_record == nil)
		return assembly_hit_record(hit_record)
  end
  
  private
  
  def assembly_hit_record
    raise "not implemented yet"
  end
  
end