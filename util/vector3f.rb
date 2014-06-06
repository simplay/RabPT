class Vector3f

  attr_accessor :x, :y, :z
  
  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end
  
  # substract other to this
  def sub other
    @x = @x-other.x
    @y = @y-other.y
    @z = @z-other.z
  end
  
  # add other to this
  def add other
    @x = @x+other.x
    @y = @y+other.y
    @z = @z+other.z
  end
  
   # compute euclidian scalar product between this and other
  def dot other
    @x*other.x + @y*other.y + @z*other.z
  end
  
  # compute euclidian distance between this and other
  def norm_2 other
    dot = dot(other)
    Math::sqrt(dot)
  end
  
  # scale this vector by a constant
  def scale by
    @x = @x*by
    @y = @y*by
    @z = @z*by
  end
  
  # get unit vector version of this vector
  def normalize
    normalization_factor = norm_2 self
    self.scale normalization_factor
  end
  
end