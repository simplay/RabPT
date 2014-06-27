require_relative 'vectorable.rb'
require_relative 'vector2f.rb'
require_relative 'vector3f.rb'

class Vector4f
  attr_accessor :x, :y, :z, :w
  
  include Vectorable
  
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
  
   # compute euclidian scalar product between this and other
  def dot other
    @x*other.x + @y*other.y + @z*other.z + @w*other.w
  end
  
  # scale this vector by a constant
  def scale by
    @x = @x*by
    @y = @y*by
    @z = @z*by
    @w = @w*by
    self
  end
  
  def same_values_as? other
    (@x == other.x) && (@y == other.y) && (@z == other.z) && (@w == other.w) 
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
