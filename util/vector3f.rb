class Vector3f

  attr_accessor :x, :y, :z
  
  def initialize(x, y, z)
    @x = x
    @y = y
    @z = z
  end
  
  def to_a
    [@x, @y, @z]
  end
  
  # substract other to this
  def sub other
    @x = @x-other.x
    @y = @y-other.y
    @z = @z-other.z
    self
  end
  
  # add other to this
  def add other
    @x = @x+other.x
    @y = @y+other.y
    @z = @z+other.z
    self
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
  
  def length
    norm_2(self)
  end
  
  # compute cross product between this an another vector
  # returns a new instance
  def cross other
    c_x = @y*other.z - @z*other.y
    c_y = @z*other.x - @x*other.z
    c_z = @x*other.y - @y*other.x
    Vector3f.new(c_x,c_y,c_z)
  end
  
  # scale this vector by a constant
  def scale by
    @x = @x*by
    @y = @y*by
    @z = @z*by
    self
  end
  
  # get unit vector version of this vector
  def normalize
    normalization_factor = norm_2 self
    self.scale (1.0 / normalization_factor.to_f)
  end
  
  def same_values_as? other
    (@x == other.x) && (@y == other.y) && (@z == other.z)
  end
  
end