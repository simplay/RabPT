require_relative 'vectorable.rb'
require_relative 'vector2f.rb'
require_relative 'vector4f.rb' 
 
class Vector3f
  attr_accessor :x, :y, :z
  
  include Vectorable
  
  def initialize(x_f, y_f, z_f)
    self.x = x_f
    self.y = y_f
    self.z = z_f
  end

  # shallow copy of this vector3f
  # @return new instance of this vector
  #         having the same components
  def s_copy
    Vector3f.new(@x, @y, @z)
  end
  
  # make an instance of vector3f from a given array
  # @array: Array containing 3 Float arguments
  def self.make_from_floats array
    Vector3f.new(array[0], array[1], array[2])
  end
  
  # makes an array of the this vector
  # @return array of components of this vector
  def to_a
    [@x, @y, @z]
  end
  
  def to_vec4f(w=0.0)
    Vector4f.new(@x, @y, @z, w)
  end
  
  # me = me - other
  # substract other to this
  # this method overwrites 
  # the components of this vector
  # @param other Vector3f
  # @return updated me:Vector3f
  def sub other
    @x = @x-other.x
    @y = @y-other.y
    @z = @z-other.z
    self
  end
  
  # me = me + other
  # add other to this
  # this method overwrites 
  # the components of this vector
  # @param other Vector3f
  # @return updated me:Vector3f
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
  
  # ret = me x other
  # compute the cross product between this an another vector
  # returns a new instance
  # @param other Vector3f
  # @return cross product:Vector3f
  def cross other
    c_x = @y*other.z - @z*other.y
    c_y = @z*other.x - @x*other.z
    c_z = @x*other.y - @y*other.x
    Vector3f.new(c_x,c_y,c_z)
  end
  
  # me = t*me
  # scale this vector by a constant
  # this method overwrites 
  # the components of this vector
  # @param by Vector3f
  # @return scaled version it self: Vector3f
  def scale by
    @x = @x*by
    @y = @y*by
    @z = @z*by
    self
  end  
  
  # other == self
  # check whether components of this vector are 
  # exactly the same to a given other vector
  # @param other Vector3f
  # @return Boolean are they the same
  def same_values_as? other
    (@x == other.x) && (@y == other.y) && (@z == other.z)
  end
  
  
  # showing tripple of vector components
  # @return String: pretty stringified components.
  def to_s
    "(#{@x},#{@y},#{@z})"
  end
  
  private
  
  # brute force overwrite components
  # of this vector.
  # this method is used for updating purposes.
  def ovwrite_me other
    @x = other.x
    @y = other.y
    @z = other.z
    self
  end
  
end
