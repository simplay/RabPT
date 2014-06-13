# TODO: make bitangent only be accessable but non-writtable.

class HitRecord
  # Stores information about a ray-surface intersection. This information 
  # is typically used for shading.
  
  require File.join(File.dirname(__FILE__), '../util/vector2f.rb')
  require File.join(File.dirname(__FILE__), '../util/vector3f.rb')
  require File.join(File.dirname(__FILE__), '../util/matrix3f.rb')
  require File.join(File.dirname(__FILE__), 'materials/material.rb')
  
  ##
  # :attr_accessor: 
  #   position: Vector3f
  #     position where the ray hit the surface
  #
  #   normal: Vector3f
  #     normal at hit pos
  #
  #   tangent, bitangent: Vector3f
  #     tangent and bitangent at hit pos
  #
  #   u,v: vector2f
  #     texture coordinates
  #
  #   w: Vector3f
  #     Direction towards origin of ray that hit surface. 
  #     By convention it points away from the surface, 
  #     that is, in the direction opposite to the incident ray.
  #
  #   t: Float 
  #     parameter of the ray at the hit point
  #
  #   material: Material
  #     The material at the hit point.
  #
  #   p: Float
  #     Area probability density. 
  #     This is typically used when a hit record is 
  #     generated by sampling the geometry, 
  #     like in implementations of LightGeometry
  # 
  #   tbs: Matrix3f
  #     tangent space transformation 
  
  attr_accessor :position,
                :normal,
                :tangent, :bitangent,
                :u, :v,
                :w,
                :t,
                :intersectable,
                :material,
                :p,
                :tbs
  
  # tangent can be assign as an optional value
  # all other attributes are supposed to be passed
  def initialize(args={})
    args.each do |key, value|
      send("#{key}=",value)
    end
    compute_tangents_and_tbs
  end
  
  private 
  
  # compute surface tangent and bitangent
  # at given hit point iff there is a normal 
  # at this hitpoint provided.
  # IF the passed tangent is lin. dependent,
  # on the passed normal, then change the value
  # of the provided tangent by some value 
  # which is for sure not lin. dependent.
  # strategy: assign another value for the tangent
  # TODO: nice to have:
  # perturbate the provided lin. dependent tangent
  # and assign cross(n, t_pert) the cross product
  # local space transformation (TBS) matrix:
  # tbs = [tangent,bitangent, normal]
  # used to caputure small local surface details 
  def compute_tangents_and_tbs
    unless @normal.nil?
      @tangent = Vector3f.new(1.0, 0.0, 0.0) unless @tangent
      @tangent = @tangent.cross(normal)
      @tangent = Vector3f.new(0.0, 1.0, 0.0).cross(normal) if @tangent.length == 0.0
      @tangent.normalize
      @bitangent = @tangent.cross(@normal)
      @tbs = Matrix3f.new(nil, nil, nil)
      @tbs.set_column_at(1, @tangent)
      @tbs.set_column_at(2, @bitangent)
      @tbs.set_column_at(3, @normal)
    end 
  end
  

  
end