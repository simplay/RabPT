class Matrix4f

  EPSILON = 0.001
  attr_accessor :m00, :m01, :m02, :m03,
                :m10, :m11, :m12, :m13,
                :m20, :m21, :m22, :m23,
                :m30, :m31, :m32, :m33

  def self.buil_with_rows(row_x = nil,
                          row_y = nil,
                          row_z = nil,
                          row_w = nil)

    if [row_x, row_y, row_z, row_w].all?(&:nil?)
      row_x = Vector4f.new(0.0, 0.0, 0.0, 0.0)
      row_y = Vector4f.new(0.0, 0.0, 0.0, 0.0)
      row_z = Vector4f.new(0.0, 0.0, 0.0, 0.0)
      row_w = Vector4f.new(0.0, 0.0, 0.0, 0.0)
    end

    new(
      row_x.x, row_x.y, row_x.z, row_x.w,
      row_y.x, row_y.y, row_y.z, row_y.w,
      row_z.x, row_z.y, row_z.z, row_z.w,
      row_w.x, row_w.y, row_w.z, row_w.w
    )
  end

  def initialize(m00 = 0, m01 = 0, m02 = 0, m03 = 0,
                 m10 = 0, m11 = 0, m12 = 0, m13 = 0,
                 m20 = 0, m21 = 0, m22 = 0, m23 = 0,
                 m30 = 0, m31 = 0, m32 = 0, m33 = 0)

    @m00 = m00; @m01 = m01; @m02 = m02; @m03 = m03;
    @m10 = m10; @m11 = m11; @m12 = m12; @m13 = m13;
    @m20 = m20; @m21 = m21; @m22 = m22; @m23 = m23;
    @m30 = m30; @m31 = m31; @m32 = m32; @m33 = m33;
  end

  # dimension of this matrix
  def dim
    4
  end

  # overwrite all entries of this 4x4 matrix
  # by the elements of a provided other matrix
  def ovwrite_me other
    (1..4).each do |i|
      (1..4).each do |j|
        set_at(i, j, other.at(i,j))
      end
    end
    self
  end

  # get a copy of this matrix' schema
  def s_copy
    Matrix4f.new(
      @m00, @m01, @m02, @m03,
      @m10, @m11, @m12, @m13,
      @m20, @m21, @m22, @m23,
      @m30, @m31, @m32, @m33
    )
  end

  # set this object to 4x4 identity matrix
  # move to special matrices
  def make_identity
    v1 = Vector4f.new(1.0, 0.0, 0.0, 0.0)
    v2 = Vector4f.new(0.0, 1.0, 0.0, 0.0)
    v3 = Vector4f.new(0.0, 0.0, 1.0, 0.0)
    v4 = Vector4f.new(0.0, 0.0, 0.0, 1.0)
    ovwrite_me Matrix4f.new(v1, v2, v3, v4)
  end

  # return identity matrix
  # @return identity matrix:Matrix4f
  def self.identity
    Matrix4f.new(
      1.0, 0.0, 0.0, 0.0,
      0.0, 1.0, 0.0, 0.0,
      0.0, 0.0, 1.0, 0.0,
      0.0, 0.0, 0.0, 1.0
    )
  end

  def translate2(by)
    t = Matrix4f.identity

    other = by.to_a
    other << 1.0

    (1..4).each do |idx|
      t.set_at(idx, 4, other[idx - 1])
    end
    t.mult(self)
    ovwrite_me t
  end

  # translate relying on homogeneous transformation
  # overwrites and returns self
  # @param by:Vector3f representing translation vector
  # @return updated self
  def translate(by)
    @m03 = @m00 * by.x + @m01 * by.y + @m02 * by.z + @m03
    @m13 = @m10 * by.x + @m11 * by.y + @m12 * by.z + @m13
    @m23 = @m20 * by.x + @m21 * by.y + @m22 * by.z + @m23
    @m33 = @m30 * by.x + @m31 * by.y + @m32 * by.z + @m33
    self
  end

  # apply a rotation matrix around
  # given axis by given degree cclw.
  # angle is an angle in degree.
  # internally, it will be recomputed
  # to a angle in radians
  # axis is a symbol representing the
  # target axis
  def rotate(angle, axis)
    rot = send("rotate_#{axis}_axis_by", angle)
    rot.mult(self)
    ovwrite_me rot
  end

  def transpose
    m01 = @m10; @m10 = @m01; @m01 = m01
    m02 = @m20; @m20 = @m02; @m02 = m02
    m03 = @m30; @m30 = @m03; @m03 = m03
    m21 = @m12; @m12 = @m21; @m21 = m21
    m31 = @m13; @m13 = @m31; @m31 = m31
    m32 = @m23; @m23 = @m32; @m32 = m32
    self
  end

  # first row equal index
  def row(kth)
    entry_parser kth
  end

  # first column equal index 1
  def column(kth)
    self.transpose
    col = entry_parser kth
    self.transpose
    col
  end

  # write val into (i,j) element of this matrix
  def setElementAt(i, j, val)
    send("m#{i-1}#{j-1}=", val)
    self
  end

  # get val of (i,j) element of this matrix
  def elementAt(i, j)
    send("m#{i-1}#{j-1}")
  end

  # replace i-th row of this matrix
  # by a given row
  def set_row_at(ith, row)
    col_idx = 1
    row.to_a.each do |element|
      set_at(ith, col_idx, element)
      col_idx += 1
    end
  end

  # replace j-th column of this matrix
  # by a given column
  def set_column_at(jth, column)
    row_idx = 1
    column.to_a.each do |element|
      set_at(row_idx, jth, element)
      row_idx += 1
    end
  end

  # assumption: dimensions match
  # perfroms a matrix4f matrix4f multiplication
  def mult(other)
    m00 = @m00 * other.m00 + @m01 * other.m10 + @m02 * other.m20 + @m03 * other.m30
    m01 = @m00 * other.m01 + @m01 * other.m11 + @m02 * other.m21 + @m03 * other.m31
    m01 = @m00 * other.m02 + @m01 * other.m12 + @m02 * other.m22 + @m03 * other.m32
    m01 = @m00 * other.m03 + @m01 * other.m13 + @m02 * other.m23 + @m03 * other.m33

    m10 = @m10 * other.m00 + @m11 * other.m10 + @m12 * other.m20 + @m13 * other.m30
    m11 = @m10 * other.m01 + @m11 * other.m11 + @m12 * other.m21 + @m13 * other.m31
    m11 = @m10 * other.m02 + @m11 * other.m12 + @m12 * other.m22 + @m13 * other.m32
    m11 = @m10 * other.m03 + @m11 * other.m13 + @m12 * other.m23 + @m13 * other.m33

    m20 = @m20 * other.m00 + @m21 * other.m10 + @m22 * other.m20 + @m23 * other.m30
    m21 = @m20 * other.m01 + @m21 * other.m11 + @m22 * other.m21 + @m23 * other.m31
    m21 = @m20 * other.m02 + @m21 * other.m12 + @m22 * other.m22 + @m23 * other.m32
    m21 = @m20 * other.m03 + @m21 * other.m13 + @m22 * other.m23 + @m23 * other.m33

    m30 = @m30 * other.m00 + @m31 * other.m10 + @m32 * other.m20 + @m33 * other.m30
    m31 = @m30 * other.m01 + @m31 * other.m11 + @m32 * other.m21 + @m33 * other.m31
    m31 = @m30 * other.m02 + @m31 * other.m12 + @m32 * other.m22 + @m33 * other.m32
    m31 = @m30 * other.m03 + @m31 * other.m13 + @m32 * other.m23 + @m33 * other.m33

    @m00 = m00; @m01 = m01; @m02 = m02; @m03 = m03
    @m10 = m10; @m11 = m11; @m12 = m12; @m13 = m13
    @m20 = m20; @m21 = m21; @m22 = m22; @m23 = m23
    @m30 = m30; @m31 = m31; @m32 = m32; @m33 = m33

    self
  end

  # assumption vec4f is a column vector
  # performs a matrix4f vector4f multiplaction
  def vectormult(vec4f)
    values = []
    (1..4).each do |i|
      values << row(i).dot(vec4f)
    end
    Vector4f.new(values[0], values[1], values[2], values[3])
  end

  # add other to me
  def add(other)
    @m00 += other.m00
    @m01 += other.m01
    @m02 += other.m02
    @m03 += other.m03
    @m10 += other.m10
    @m11 += other.m11
    @m12 += other.m12
    @m13 += other.m13
    @m20 += other.m20
    @m21 += other.m21
    @m22 += other.m22
    @m23 += other.m23
    @m30 += other.m30
    @m31 += other.m31
    @m32 += other.m32
    @m33 += other.m33
    self
  end

  # substract other from me
  def sub(other)
    @m00 -= other.m00
    @m01 -= other.m01
    @m02 -= other.m02
    @m03 -= other.m03
    @m10 -= other.m10
    @m11 -= other.m11
    @m12 -= other.m12
    @m13 -= other.m13
    @m20 -= other.m20
    @m21 -= other.m21
    @m22 -= other.m22
    @m23 -= other.m23
    @m30 -= other.m30
    @m31 -= other.m31
    @m32 -= other.m32
    @m33 -= other.m33
  end

  # is element (i,j) of other matrix
  # EXACTLY the same as element (i,j)
  # of this matrix. EXACTLY means there is
  # no finite arithmetical difference which
  # might slightly alter the values.
  def ==(other)
    @m00 == other.m00 &&
    @m01 == other.m01 &&
    @m02 == other.m02 &&
    @m03 == other.m03 &&
    @m10 == other.m10 &&
    @m11 == other.m11 &&
    @m12 == other.m12 &&
    @m13 == other.m13 &&
    @m20 == other.m20 &&
    @m21 == other.m21 &&
    @m22 == other.m22 &&
    @m23 == other.m23 &&
    @m30 == other.m30 &&
    @m31 == other.m31 &&
    @m32 == other.m32 &&
    @m33 == other.m33
  end

  # is element (i,j) of other matrix
  # approximately the same as element (i,j)
  # of this matrix.
  # we compute deltas between row elements
  # of other and self. we compare those deltas
  # in a least square sense (
  # i.e is the sum of squared deltas below a given threshold
  def sum
    @m00 + @m01 + @m02 + @m03 +
    @m10 + @m11 + @m12 + @m13 +
    @m20 + @m21 + @m22 + @m23 +
    @m30 + @m31 + @m32 + @m33
  end

  # scale every element of this matrix by given value
  def scale(by)
    @m00 *= by
    @m01 *= by
    @m02 *= by
    @m03 *= by
    @m10 *= by
    @m11 *= by
    @m12 *= by
    @m13 *= by
    @m20 *= by
    @m21 *= by
    @m22 *= by
    @m23 *= by
    @m30 *= by
    @m31 *= by
    @m32 *= by
    @m33 *= by
    self
  end

  # diagonal elements of this matrix
  # represented as a vectror4f
  def diag
    d = []
    (1..4).each do |k|
      d << at(k,k)
    end
    Vector4f.new(d[0], d[1], d[2], d[3])
  end

  # get sub/block matrix defined by a mask
  # we are masking by using two indices
  # a row/ and a column index
  # given an N x N matrix A, then
  # masling row i and column j will give us
  # i.e. A_i,j will give us a (N-1)x(N-1) matrix
  # consisting of matrix A without having row i
  # and without having column j.
  def masked_block(row_idx, column_idx)
    elements = []
    (1..4).each do |i|
      (1..4).each do |j|
        if(i != row_idx && j != column_idx)
          elements << at(i,j)
        end
      end
    end

    # here assumption 3x3
    a1 = elements[0..2]
    a2 = elements[3..5]
    a3 = elements[6..8]

    v1 = Vector3f.new(a1[0], a1[1], a1[2])
    v2 = Vector3f.new(a2[0], a2[1], a2[2])
    v3 = Vector3f.new(a3[0], a3[1], a3[2])
    Matrix3f.new(v1, v2, v3)
  end

  # note this is highly unstable for some matrices
  # and has a runtime of O(N^3 N!)
  # explicit inverse for a 4x4 matrix
  # relying on Laplace expansions
  def invert
    m = Matrix4f.new
    s0 = @m00 * @m11 - @m10 * @m01;
    s1 = @m00 * @m12 - @m10 * @m02;
    s2 = @m00 * @m13 - @m10 * @m03;
    s3 = @m01 * @m12 - @m11 * @m02;
    s4 = @m01 * @m13 - @m11 * @m03;
    s5 = @m02 * @m13 - @m12 * @m03;

    c5 = @m22 * @m33 - @m32 * @m23;
    c4 = @m21 * @m33 - @m31 * @m23;
    c3 = @m21 * @m32 - @m31 * @m22;
    c2 = @m20 * @m33 - @m30 * @m23;
    c1 = @m20 * @m32 - @m30 * @m22;
    c0 = @m20 * @m31 - @m30 * @m21;

    # check for 0 determinant
    invdet = 1.0 / (s0 * c5 - s1 * c4 + s2 * c3 + s3 * c2 - s4 * c1 + s5 * c0)

    m.m00 = ( @m11 * c5 - @m12 * c4 + @m13 * c3) * invdet
    m.m01 = (-@m01 * c5 + @m02 * c4 - @m03 * c3) * invdet
    m.m02 = ( @m31 * s5 - @m32 * s4 + @m33 * s3) * invdet
    m.m03 = (-@m21 * s5 + @m22 * s4 - @m23 * s3) * invdet

    m.m10 = (-@m10 * c5 + @m12 * c2 - @m13 * c1) * invdet
    m.m11 = ( @m00 * c5 - @m02 * c2 + @m03 * c1) * invdet
    m.m12 = (-@m30 * s5 + @m32 * s2 - @m33 * s1) * invdet
    m.m13 = ( @m20 * s5 - @m22 * s2 + @m23 * s1) * invdet

    m.m20 = ( @m10 * c4 - @m11 * c2 + @m13 * c0) * invdet
    m.m21 = (-@m00 * c4 + @m01 * c2 - @m03 * c0) * invdet
    m.m22 = ( @m30 * s4 - @m31 * s2 + @m33 * s0) * invdet
    m.m23 = (-@m20 * s4 + @m21 * s2 - @m23 * s0) * invdet

    m.m30 = (-@m10 * c3 + @m11 * c1 - @m12 * c0) * invdet
    m.m31 = ( @m00 * c3 - @m01 * c1 + @m02 * c0) * invdet
    m.m32 = (-@m30 * s3 + @m31 * s1 - @m32 * s0) * invdet
    m.m33 = ( @m20 * s3 - @m21 * s1 + @m22 * s0) * invdet

    m
  end

  def singular?
    det == 0.0
  end

  def det
    s0 = @m00 * @m11 - @m10 * @m01;
    s1 = @m00 * @m12 - @m10 * @m02;
    s2 = @m00 * @m13 - @m10 * @m03;
    s3 = @m01 * @m12 - @m11 * @m02;
    s4 = @m01 * @m13 - @m11 * @m03;
    s5 = @m02 * @m13 - @m12 * @m03;

    c5 = @m22 * @m33 - @m32 * @m23;
    c4 = @m21 * @m33 - @m31 * @m23;
    c3 = @m21 * @m32 - @m31 * @m22;
    c2 = @m20 * @m33 - @m30 * @m23;
    c1 = @m20 * @m32 - @m30 * @m22;
    c0 = @m20 * @m31 - @m30 * @m21;

    s0 * c5 - s1 * c4 + s2 * c3 + s3 * c2 - s4 * c1 + s5 * c0
  end

  def to_s
    str = ""
    3.times {|idx| str << "#{row(idx+1).to_s}\n"}
    str << row(4).to_s
  end

  private

  def entry_parser(at)
    collection = nil

    case at
    when 1
      collection = Vector4f.new(@m00, @m01, @m02, @m03)
    when 2
      collection = Vector4f.new(@m10, @m11, @m12, @m13)
    when 3
      collection = Vector4f.new(@m20, @m21, @m22, @m23)
    when 4
      collection = Vector4f.new(@m30, @m31, @m32, @m33)
    end
    collection
  end

  # swaps two elements of this matrix
  def swap(a, b)
    tmp = send("#{a}")
    send("#{a}=",send("#{b}"))
    send("#{b}=",tmp)
  end

  # counter clock wise rotation
  # Math::cos(Math::PI) is -1.0
  def rotate_z_axis_by degree
    rot = Matrix4f.identity
    pi = Math::PI
    angle = (degree.to_f * pi) / 180.0
    rot.set_at(1, 1, Math::cos(angle))
    rot.set_at(2, 2, Math::cos(angle))
    rot.set_at(1, 2, Math::sin(-angle))
    rot.set_at(2, 1, Math::sin(angle))
    rot
  end

  # counter clock wise rotation
  def rotate_y_axis_by(degree)
    rot = Matrix4f.identity
    pi = Math::PI
    angle = (degree.to_f * pi) / 180.0
    rot.set_at(1, 1, Math::cos(angle))
    rot.set_at(3, 3, Math::cos(angle))
    rot.set_at(3, 1, Math::sin(-angle))
    rot.set_at(1, 3, Math::sin(angle))
    rot
  end

  # counter clock wise rotation
  def rotate_x_axis_by(degree)
    rot = Matrix4f.identity
    pi = Math::PI
    angle = (degree.to_f * pi) / 180.0
    rot.set_at(2, 2, Math::cos(angle))
    rot.set_at(3, 3, Math::cos(angle))
    rot.set_at(2, 3, Math::sin(-angle))
    rot.set_at(3, 2, Math::sin(angle))
    rot
  end

  alias_method :set_at, :setElementAt
  alias_method :at, :elementAt
  alias_method :inv, :invert
end
