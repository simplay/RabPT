class Matrix4f
  require File.join(File.dirname(__FILE__), 'vector4f.rb')
  require File.join(File.dirname(__FILE__), 'matrix3f.rb')
  
require "pry"
  EPSILON = 0.001
  attr_accessor :m00, :m01, :m02, :m03,
                :m10, :m11, :m12, :m13,
                :m20, :m21, :m22, :m23,
                :m30, :m31, :m32, :m33
                
  def initialize(row_x, row_y, row_z, row_w)
    if ([row_x, row_y, row_z, row_w].all? &:nil?)
      row_x = Vector4f.new(0.0, 0.0, 0.0, 0.0)
      row_y = Vector4f.new(0.0, 0.0, 0.0, 0.0)
      row_z = Vector4f.new(0.0, 0.0, 0.0, 0.0)
      row_w = Vector4f.new(0.0, 0.0, 0.0, 0.0)
    end
    @m00 = row_x.x; @m01 = row_x.y; @m02 = row_x.z; @m03 = row_x.w;
    @m10 = row_y.x; @m11 = row_y.y; @m12 = row_y.z; @m13 = row_y.w;
    @m20 = row_z.x; @m21 = row_z.y; @m22 = row_z.z; @m23 = row_z.w;
    @m30 = row_w.x; @m31 = row_w.y; @m32 = row_w.z; @m33 = row_w.w;
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
    v1 = Vector4f.new(@m00, @m01, @m02, @m03)
    v2 = Vector4f.new(@m10, @m11, @m12, @m13)
    v3 = Vector4f.new(@m20, @m21, @m22, @m23)
    v4 = Vector4f.new(@m30, @m31, @m32, @m33)
    Matrix4f.new(v1, v2, v3, v4)
  end
  
  # set this object to 4x4 identity matrix
  def make_identity
    v1 = Vector4f.new(1.0, 0.0, 0.0, 0.0)
    v2 = Vector4f.new(0.0, 1.0, 0.0, 0.0)
    v3 = Vector4f.new(0.0, 0.0, 1.0, 0.0)
    v4 = Vector4f.new(0.0, 0.0, 0.0, 1.0)
    ovwrite_me Matrix4f.new(v1, v2, v3, v4)
  end
  
  # transpose this matrix
  def transpose
    swap(:m10, :m01)
    swap(:m20, :m02)
    swap(:m30, :m03)
    swap(:m21, :m12)
    swap(:m31, :m13)
    swap(:m32, :m23)
    self
  end
  
  # first row equal index 
  def row kth 
    entry_parser kth
  end
  
  # first column equal index 1
  def column kth
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
  
  # assumption: dimensions match
  # perfroms a matrix4f matrix4f multiplication
  def mult other
    values = []
    (1..4).each do |i|
      (1..4).each do |j|
        values << row(j).dot(other.column(i))
      end
    end  
    counter = 0
    (1..4).each do |i|
      (1..4).each do |j|
        setElementAt(j,i, values[counter])
        counter += 1
      end
    end  
    self
  end
  
  # assumption vec4f is a column vector
  # performs a matrix4f vector4f multiplaction
  def vectormult vec4f
    values = []
    (1..4).each do |i|
      values << row(i).dot(vec4f)
    end
    Vector4f.new(values[0], values[1], values[2], values[3])
  end
  
  # add other to me
  def add other
    applyBinaryComponentwise(:+, other)
  end
  
  # substract other from me
  def sub other
    applyBinaryComponentwise(:-, other)
  end
  
  # is element (i,j) of other matrix
  # EXACTLY the same as element (i,j)
  # of this matrix. EXACTLY means there is 
  # no finite arithmetical difference which 
  # might slightly alter the values.
  def same_values_as? other
    predicat = true
    (1..4).each do |idx|
      predicat &&= other.row(idx).same_values_as?(self.row(idx))
    end
    predicat
  end
  
  # is element (i,j) of other matrix
  # approximately the same as element (i,j)
  # of this matrix. 
  # we compute deltas between row elements 
  # of other and self. we compare those deltas 
  # in a least square sense (
  # i.e is the sum of squared deltas below a given threshold
  def approx_same_values_as? other
    predicat = true
    (1..4).each do |idx|
      delta_vec = row(idx).sub(other.row(idx)).to_a
      delta = delta_vec.inject(0.0) do |result, element| 
        result + element**2.0 
      end
      predicat &&= (delta < EPSILON)
    end
    predicat
  end
  
  # scale every element of this matrix by given value
  def scale by  
    (1..4).each do |i|
      (1..4).each do |j|
        set_at(i, j, at(i,j)*by) 
      end
    end
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
  
  # Adjugate of this matrix
  def adj
    snapshot = s_copy
    sign = 1.0
    (1..4).each do |i|
      (1..4).each do |j|
        sign = ((i+j)%2 == 0)? 1 : -1
        setElementAt(i,j, sign*snapshot.masked_block(i,j).det)
      end
    end  
    transpose
  end
  
  def is_singular?
    det == 0.0
  end
  
  # recursive det calculation
  def det
    s1 = at(1,1)
    
    r11 = Vector3f.new(at(2,2),at(2,3),at(2,4))
    r12 = Vector3f.new(at(3,2),at(3,3),at(3,4))
    r13 = Vector3f.new(at(4,2),at(4,3),at(4,4))
    det1 = (Matrix3f.new(r11, r12, r13)).det
    
    s2 = at(1,2)
    r21 = Vector3f.new(at(2,1),at(2,3),at(2,4))
    r22 = Vector3f.new(at(3,1),at(3,3),at(3,4))
    r23 = Vector3f.new(at(4,1),at(4,3),at(4,4))
    det2 = (Matrix3f.new(r21, r22, r23)).det
    
    s3 = at(1,3)
    r31 = Vector3f.new(at(2,1),at(2,2),at(2,4))
    r32 = Vector3f.new(at(3,1),at(3,2),at(3,4))
    r33 = Vector3f.new(at(4,1),at(4,2),at(4,4))
    det3 = (Matrix3f.new(r31, r32, r33)).det
    
    s4 = at(1,4)
    r41 = Vector3f.new(at(2,1),at(2,2),at(2,3))
    r42 = Vector3f.new(at(3,1),at(3,2),at(3,3))
    r43 = Vector3f.new(at(4,1),at(4,2),at(4,3))
    det4 = (Matrix3f.new(r41, r42, r43)).det
    
    (s1*det1 - s2*det2 + s3*det3 - s4*det4)
  end
  
  private
  
  def entry_parser at 
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
  
  # deuglyfy this helper bz using chained sends
  # and a for for loop
  def applyBinaryComponentwise(op, other)
    @m00 = @m00.send(op, other.m00)
    @m01 = @m01.send(op, other.m01)
    @m02 = @m02.send(op, other.m02)
    @m03 = @m03.send(op, other.m03)
    @m10 = @m10.send(op, other.m10)
    @m11 = @m11.send(op, other.m11)
    @m12 = @m12.send(op, other.m12)
    @m13 = @m13.send(op, other.m13)
    @m20 = @m20.send(op, other.m20)
    @m21 = @m21.send(op, other.m21)
    @m22 = @m22.send(op, other.m22)
    @m23 = @m23.send(op, other.m23)
    @m30 = @m30.send(op, other.m30)
    @m31 = @m31.send(op, other.m31)
    @m32 = @m32.send(op, other.m32)
    @m33 = @m33.send(op, other.m33)
    self
  end
  
  # swaps two elements of this matrix
  def swap(a, b)  
    tmp = send("#{a}")
    send("#{a}=",send("#{b}"))
    send("#{b}=",tmp)
  end
    
  alias_method :set_at, :setElementAt 
  alias_method :at, :elementAt
end