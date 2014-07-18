require_relative 'vectorable.rb'
require_relative 'vector3f.rb'
require_relative 'vector4f.rb' 
 
class Vector2f
  attr_accessor :x, :y
  
  include Vectorable
  
  def initialize(x, y)
    @x = x
    @y = y
  end
  
  # shallow copy of this vector3f
  def s_copy
    Vector3f.new(@x, @y)
  end
  
  def to_a
    [@x, @y]
  end
  
  # substract other to this
  def sub other
    @x = @x-other.x
    @y = @y-other.y
    self
  end
  
  # add other to this
  def add other
    @x = @x+other.x
    @y = @y+other.y
    self
  end
  
   # compute euclidian scalar product between this and other
  def dot other
    @x*other.x + @y*other.y
  end
  
  # scale this vector by a constant
  def scale by
    @x = @x*by
    @y = @y*by
    self
  end
  
  def same_values_as? other
    (@x == other.x) && (@y == other.y)
  end
  
  def to_s
    "(#{@x},#{@y})"
  end
  
end