class Vector4f

  attr_accessor :x, :y, :z, :w
  
  def initialize(x, y, z, w)
    @x = x
    @y = y
    @z = z
    @w = w
  end
  
  # substract other to this
  def sub other
    @x = @x-other.x
    @y = @y-other.y
    @z = @z-other.z
    @w = @w-other.w
  end
  
  # add other to this
  def add other
    @x = @x+other.x
    @y = @y+other.y
    @z = @z+other.z
    @w = @w+other.w
  end
  
   # compute euclidian scalar product between this and other
  def dot other
    @x*other.x + @y*other.y + @z*other.z + @w*other.w
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
    @w = @w*by
  end
  
  # get unit vector version of this vector
  def normalize
    normalization_factor = norm_2 self
    self.scale normalization_factor
  end
  
end