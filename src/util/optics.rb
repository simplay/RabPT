module Optics
  # computes outgoing mirror direction, reflected off
  # at hit_position, relying on incident light direction
  # and the surface normal at that postion.
  # theta_i denotes the angle between
  # surface normal and indicdent light direction.
  # Snell's law: r = 2*dot(n,i)n-i
  # @param normal:Vector3f surface normal
  # @param w_in:Vector3f incident light direction
  # @return w_out: Vector3f mirror reflection direction.
  def self.reflection(normal, w_in)
    cos_theta_i = w_in.dot(normal)
    normal.s_copy.scale(2.0*cos_theta_i).add(w_in.s_copy.negate)
  end

  def self.refraction
  end

  def self.fresnel(w_in, w_out)
  end
end
