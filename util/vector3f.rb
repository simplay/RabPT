require 'pry'
class Vector3f
  EPSILON = 0.001
  attr_accessor :x, :y, :z
  
  def initialize(x_f, y_f, z_f)
    self.x = x_f
    self.y = y_f
    self.z = z_f
  end

  # shallow copy of this vector3f
  def s_copy
    Vector3f.new(@x, @y, @z)
  end
  
  def to_a
    [@x, @y, @zz]
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
  
  # applied a tranformation matrix 
  # to this vector and overwrite its values
  def transform t
    ovwrite_me t.vectormult(self)
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
  
  # invertes direction of this vector
  def negate
    scale(-1.0)
  end
  
  # get unit vector version of this vector
  def normalize
    normalization_factor = norm_2 self
    self.scale (1.0 / normalization_factor.to_f) unless normalization_factor==0.0
  end
  
  def same_values_as? other
    (@x == other.x) && (@y == other.y) && (@zz == other.zz)
  end
  
  def approx_same_values_as? other
    delta = copy_s.sub(other).to_a.inject(0.0) do |result, element| 
      result + element**2.0 
    end
    delta < EPSILON
  end
  
  def to_s
    "(#{@x},#{@y},#{@z})"
  end
  
  private
  
  def ovwrite_me other
    @x = other.x
    @y = other.y
    @z = other.z
    self
  end
  
end