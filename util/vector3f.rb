class Vector3f

  attr_accessor :x, :y, :z
  
  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end
  
  def sub other
    @x = @x-other.x
    @y = @y-other.y
    @z = @z-other.z
  end
  
  def add other
    @x = @x+other.x
    @y = @y+other.y
    @z = @z+other.z
  end
  
  def dot other
    @x*other.x + @y*other.y + @z*other.z
  end
  
  def norm_2 other
    dot = dot(other)
    Math::sqrt(dot)
  end
  
end