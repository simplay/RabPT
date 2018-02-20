require_relative 'vector3f.rb'
require_relative 'matrix2f.rb'

class Matrix3f
  attr_accessor :m00, :m01, :m02,
                :m10, :m11, :m12,
                :m20, :m21, :m22

  def initialize(row_x, row_y, row_z)
    if [row_x, row_y, row_z].all?(&:nil?)
      row_x = Vector3f.new(0.0, 0.0, 0.0)
      row_y = Vector3f.new(0.0, 0.0, 0.0)
      row_z = Vector3f.new(0.0, 0.0, 0.0)
    end
    @m00 = row_x.x; @m01 = row_x.y; @m02 = row_x.z;
    @m10 = row_y.x; @m11 = row_y.y; @m12 = row_y.z;
    @m20 = row_z.x; @m21 = row_z.y; @m22 = row_z.z;
  end

  # make a shallow copy of this matrix copy all of its components and mak a new
  # instance of itself
  #
  # @return Matrix4f shallow copy of itself
  def s_copy
    v1 = Vector3f.new(@m00, @m01, @m02)
    v2 = Vector3f.new(@m10, @m11, @m12)
    v3 = Vector3f.new(@m20, @m21, @m22)
    Matrix3f.new(v1, v2, v3)
  end

  # set this object to 4x4 identity matrix
  # move to special matrices
  def make_identity
    v1 = Vector3f.new(1.0, 0.0, 0.0)
    v2 = Vector3f.new(0.0, 1.0, 0.0)
    v3 = Vector3f.new(0.0, 0.0, 1.0)
    ovwrite_me Matrix3f.new(v1, v2, v3)
  end

  # return identity matrix
  # @return identity matrix:Matrix3f
  def self.identity
    v1 = Vector3f.new(1.0, 0.0, 0.0)
    v2 = Vector3f.new(0.0, 1.0, 0.0)
    v3 = Vector3f.new(0.0, 0.0, 1.0)
    Matrix3f.new(v1, v2, v3)
  end

  def transpose
    swap(:m10, :m01)
    swap(:m02, :m20)
    swap(:m21, :m12)
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
  end

  # get val of (i,j) element of this matrix
  def element_at(i, j)
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
  # perfroms a matrix3f matrix3f multiplication
  def mult other
    values = []
    (1..3).each do |i|
      (1..3).each do |j|
        values << row(j).dot(other.column(i))
      end
    end
    counter = 0
    (1..3).each do |i|
      (1..3).each do |j|
        setElementAt(j,i, values[counter])
        counter += 1
      end
    end
    self
  end

  def masked_block(row_idx, column_idx)
    elements = []
    (1..3).each do |i|
      (1..3).each do |j|
        if i != row_idx && j != column_idx
          elements << at(i,j)
        end
      end
    end

    Matrix2f.new(
      elements[0], elements[1],
      elements[2], elements[3]
    )
  end

  # assumption vec4f is a column vector
  # performs a matrix3f vector3f multiplaction
  def vectormult(vec3f)
    values = []
    (1..3).each do |i|
      values << row(i).dot(vec3f)
    end
    Vector3f.new(values[0], values[1], values[2])
  end

  def add(other)
    applyBinaryComponentwise(:+, other)
  end

  def sub(other)
    applyBinaryComponentwise(:-, other)
  end

  def same_values_as?(other)
    predicat = true
    (1..3).each do |idx|
      predicat &&= other.row(idx).same_values_as?(self.row(idx))
    end
    predicat
  end

  # scale every element of this matrix by given value
  def scale(by)
    (1..3).each do |i|
      (1..3).each do |j|
        val = at(i,j)*by
        setElementAt(i, j, val)
      end
    end
    self
  end

  def adj
    snapshot = s_copy
    sign = 1.0
    (1..3).each do |i|
      (1..3).each do |j|
        setElementAt(i,j, sign*snapshot.masked_block(i,j).det)
        sign *= -1.0
      end
    end
    transpose
  end

  def invert
    values = []
    unless is_singular?
      # compute elementwise inverses
      initial_det = det
      f = (1.0/initial_det.to_f)
      adj
      scale(f)
      self
    end
  end

  def det
    a1 = at(1,1)*at(2,2)*at(3,3)
    a2 = at(1,2)*at(2,3)*at(3,1)
    a3 = at(1,3)*at(2,1)*at(3,2)

    b1 = at(1,1)*at(2,3)*at(3,2)
    b2 = at(1,2)*at(2,1)*at(3,3)
    b3 = at(1,3)*at(2,2)*at(3,1)

    (a1 + a2 + a3) - ( b1 + b2 + b3)
  end

  def is_singular?
    det == 0
  end

  def to_s
    str = ''
    2.times {|idx| str << "#{row(idx+1).to_s}\n"}
    str << row(3).to_s
  end

  private

  def entry_parser(at)
    collection = nil
    case at
    when 1
      collection = Vector3f.new(@m00, @m01, @m02)
    when 2
      collection = Vector3f.new(@m10, @m11, @m12)
    when 3
      collection = Vector3f.new(@m20, @m21, @m22)
    end
    collection
  end

  # deuglyfy this helper bz using chained sends
  # and a for for loop
  def applyBinaryComponentwise(op, other)
    @m00 = @m00.send(op, other.m00)
    @m01 = @m01.send(op, other.m01)
    @m02 = @m02.send(op, other.m02)

    @m10 = @m10.send(op, other.m10)
    @m11 = @m11.send(op, other.m11)
    @m12 = @m12.send(op, other.m12)

    @m20 = @m20.send(op, other.m20)
    @m21 = @m21.send(op, other.m21)
    @m22 = @m22.send(op, other.m22)

    self
  end

  def swap(a, b)
    tmp = send("#{a}")
    send("#{a}=",send("#{b}"))
    send("#{b}=",tmp)
  end

  alias_method :at, :element_at
  alias_method :set_at, :setElementAt
end
