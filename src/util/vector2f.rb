class Vector2f
  EPSILON = 0.001

  attr_accessor :x, :y

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
  def sub(other)
    @x = @x - other.x
    @y = @y - other.y
    self
  end

  # add other to this
  def add(other)
    @x = @x + other.x
    @y = @y + other.y
    self
  end

   # compute euclidian scalar product between this and other
  def dot(other)
    @x * other.x + @y * other.y
  end

  # compute euclidian distance between this and other
  def norm_2(other)
    dot = dot(other)
    Math::sqrt(dot)
  end

  def length
    norm_2(self)
  end

  # scale this vector by a constant
  def scale(by)
    @x = @x * by
    @y = @y * by
    self
  end

  # get unit vector version of this vector
  def normalize
    normalization_factor = norm_2 self
    self.scale (1.0 / normalization_factor.to_f) unless normalization_factor == 0.0
  end

  def ==(other)
    (@x == other.x) && (@y == other.y)
  end

  def approx_same_values_as? other
    delta = copy_s.sub(other).to_a.inject(0.0) do |result, element|
      result + element**2.0
    end
    delta < EPSILON
  end

  def to_s
    "(#{@x},#{@y})"
  end
end
