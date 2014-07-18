require 'pry'

module Vectorable
  EPSILON = 0.001
  
  # compute euclidian distance between this and other
  def norm_2 other
    dot = dot(other)
    Math::sqrt(dot)
  end
  
  def length
    norm_2(self)
  end
  
  def dotted
    dot self
  end
  
  # <(me-other),(me-other)>^2
  # computed squared dotproduct of 
  # distance vector, whereat
  # distacne is from me to other 
  # @param other Vector3f
  # @return distance from me to other squared:Float
  def dist_to_sqr(other)
    s_copy.sub(other).dotted
  end
  
  # get unit vector version of this vector
  def normalize
    normalization_factor = norm_2 self
    self.scale (1.0 / normalization_factor.to_f) unless normalization_factor==0.0
  end
  
  # me = -me
  # invertes direction of this vector
  # this method overwrites 
  # the components of this vector
  # @return updated self Vector3f
  def negate
    scale(-1.0)
  end
  
  # || other - self || < epsilon
  # check whether components of this vector are 
  # approximately the same according to the 2Norm
  # to a given other vector
  # @param other Vector3f
  # @return Boolean are they approxi. the same
  def approx_same_values_as? other
    delta = s_copy.sub(other).to_a.inject(0.0) do |result, element| 
      result + element**2.0 
    end
    delta < EPSILON
  end
  
  # me = T*me
  # applied a tranformation matrix 
  # to this vector and overwrite its values
  # this method overwrites 
  # the components of this vector
  # @param t Matrix3f transformation
  # @return updated me:Vector3f
  def transform t
    ovwrite_me t.vectormult(self)
  end
  
  # computes outgoing mirror direction, reflected off
  # at hit_position, relying on incident light direction
  # and the surface normal at that postion.
  # uses self as incident direction.
  # theta_i denotes the angle between
  # surface normal and indicdent light direction.
  # Snell's law: r = 2*dot(n,i)n-i
  # @param normal:Vector3f surface normal
  # @return w_out: Vector3f mirror reflection direction.
  def reflection normal
    cos_theta_i = self.dot(normal)
    normal.s_copy.scale(2.0*cos_theta_i).add(w_in.s_copy.negate)
  end
  
end