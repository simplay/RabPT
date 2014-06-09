# a ray is defined as a parametric line p(t) = origin + t*direction
# where t is a real-valued scalar.

class Ray
  attr_accessor :origin,
                :direction,
                :depth,
                :t
  
  def initialize(args={})
    init_values
    args.each do |key, value|
      send("#{key}=", value)
    end
  end
  
  # get point on ray for a given paramter t.
  def point_at t
    dir = @direction.copy_s
    orig = @origin.copy_s
    tmp = dir.scale(t).add(orig)
    Vector3f.new(tmp.x, tmp.y, tmp.z)
  end
  
  def to_s
    "origin: #{@origin.to_s} direction: #{@direction.to_s}"
  end
  
  private 
  
  def init_values
    v = Vector3f.new(0.0, 0.0, 0.0)
    @origin = v
    @direction = v
    @depth = 0.0
    @t = 0.0
  end
  
end