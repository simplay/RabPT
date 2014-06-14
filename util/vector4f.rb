require_relative 'Vector3f.rb'
 
class Vector4f
  EPSILON = 0.001
  attr_accessor :x, :y, :z, :w
  
  def initialize(x_f, y_f, z_f, w_f)
    self.x = x_f
    self.y = y_f
    self.z = z_f
    self.w = w_f
  end
  
  # shallow copy of this vector3f
  def s_copy
    Vector4f.new(@x, @y, @z, @w)
  end
  
  def to_a
    [@x, @y, @z, @w]
  end
  
  def to_vec3f
    Vector3f.new(@x, @y, @z)
  end
  
  # substract other to this
  def sub other
    @x = @x-other.x
    @y = @y-other.y
    @z = @z-other.z
    @w = @w-other.w
    self
  end
  
  # add other to this
  def add other
    @x = @x+other.x
    @y = @y+other.y
    @z = @z+other.z
    @w = @w+other.w
    self
  end
  
  # applied a tranformation matrix 
  # to this vector and overwrite its values
  def transform t
    ovwrite_me t.vectormult(self)
  end
  
  def dotted
    dot self
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
  
  def length
    norm_2(self)
  end
  
  # scale this vector by a constant
  def scale by
    @x = @x*by
    @y = @y*by
    @z = @z*by
    @w = @w*by
    self
  end
  
  # get unit vector version of this vector
  def normalize
    normalization_factor = norm_2 self
    self.scale (1.0 / normalization_factor.to_f)
  end
  
  def same_values_as? other
    (@x == other.x) && (@y == other.y) && (@z == other.z) && (@w == other.w) 
  end
  
  def approx_same_values_as? other
    delta = copy_s.sub(other).to_a.inject(0.0) do |result, element| 
      result + element**2.0 
    end
    delta < EPSILON
  end  
  
  def to_s
    "(#{@x},#{@y},#{@z},#{@w})"
  end
  
  private
  
  def ovwrite_me other
    @x = other.x
    @y = other.y
    @z = other.z
    @w = other.w
    self
  end
  
end