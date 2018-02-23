class Vector3f
  EPSILON = 0.001

  attr_accessor :x, :y, :z

  def initialize(x_f, y_f, z_f)
    @x = x_f
    @y = y_f
    @z = z_f
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

  def to_vec4f(w = 0.0)
    Vector4f.new(@x, @y, @z, w)
  end

  # me = me - other
  # substract other to this
  # this method overwrites
  # the components of this vector
  # @param other Vector3f
  # @return updated me:Vector3f
  def sub(other)
    @x = @x - other.x
    @y = @y - other.y
    @z = @z - other.z
    self
  end

  # me = me + other
  # add other to this
  # this method overwrites
  # the components of this vector
  # @param other Vector3f
  # @return updated me:Vector3f
  def add(other)
    @x = @x + other.x
    @y = @y + other.y
    @z = @z + other.z
    self
  end

  # me = T*me
  # applied a tranformation matrix
  # to this vector and overwrite its values
  # this method overwrites
  # the components of this vector
  # @param t Matrix3f transformation
  # @return updated me:Vector3f
  def transform(t)
    ovwrite_me t.vectormult(self)
  end

  # compute euclidian scalar product between this and other
  def dot(other)
    @x * other.x + @y * other.y + @z * other.z
  end

  def dotted
    dot(self)
  end

  # <(me-other),(me-other)>^2
  # computed squared dotproduct of
  # distance vector, whereat
  # distacne is from me to other
  # @param other Vector3f
  # @return distance from me to other squared:Float
  def dist_to_sqr(other)
    s_copy.sub(other).dotted
  end

  # compute euclidian distance between self and other
  # @param other Vector3f
  # @return euclidian distance betwenn: Float
  def norm_2(other)
    dot = dot(other)
    Math::sqrt(dot)
  end

  def length
    norm_2(self)
  end

  # ret = me x other
  # compute the cross product between this an another vector
  # returns a new instance
  # @param other Vector3f
  # @return cross product:Vector3f
  def cross(other)
    c_x = @y * other.z - @z * other.y
    c_y = @z * other.x - @x * other.z
    c_z = @x * other.y - @y * other.x
    Vector3f.new(c_x,c_y,c_z)
  end

  # me = t*me
  # scale this vector by a constant
  # this method overwrites
  # the components of this vector
  # @param by Vector3f
  # @return scaled version it self: Vector3f
  def scale(by)
    @x = @x * by
    @y = @y * by
    @z = @z * by
    self
  end

  # me = -me
  # invertes direction of this vector
  # this method overwrites
  # the components of this vector
  # @return updated self Vector3f
  def negate
    scale(-1.0)
  end

  # get unit vector version of this vector
  # this method overwrites
  # the components of this vector
  # return updated self Vector3f
  def normalize
    normalization_factor = norm_2(self)
    return self if normalization_factor.zero?

    self.scale (1.0 / normalization_factor.to_f)
  end

  # other == self
  # check whether components of this vector are
  # exactly the same to a given other vector
  # @param other Vector3f
  # @return Boolean are they the same
  def same_values_as?(other)
    (@x == other.x) && (@y == other.y) && (@z == other.z)
  end

  # || other - self || < epsilon
  # check whether components of this vector are
  # approximately the same according to the 2Norm
  # to a given other vector
  # @param other Vector3f
  # @return Boolean are they approxi. the same
  def approx_same_values_as?(other)
    delta = s_copy.sub(other).to_a.inject(0.0) do |result, element|
      result + element**2.0
    end
    delta < EPSILON
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
  def ovwrite_me(other)
    @x = other.x
    @y = other.y
    @z = other.z
    self
  end
end
