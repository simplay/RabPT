class Matrix4f
  require File.join(File.dirname(__FILE__), 'vector4f.rb')
  require File.join(File.dirname(__FILE__), 'matrix3f.rb')
  
require "pry"
  
  attr_accessor :schema,
                :m00, :m01, :m02, :m03,
                :m10, :m11, :m12, :m13,
                :m20, :m21, :m22, :m23,
                :m30, :m31, :m32, :m33
                
  def initialize(row_x, row_y, row_z, row_w)

    @m00 = row_x.x; @m01 = row_x.y; @m02 = row_x.z; @m03 = row_x.w;
    @m10 = row_y.x; @m11 = row_y.y; @m12 = row_y.z; @m13 = row_y.w;
    @m20 = row_z.x; @m21 = row_z.y; @m22 = row_z.z; @m23 = row_z.w;
    @m30 = row_w.x; @m31 = row_w.y; @m32 = row_w.z; @m33 = row_w.w;
    build_schema
  end
  
  def transpose
    swap(:m10, :m01)
    swap(:m20, :m02)
    swap(:m30, :m03)
    swap(:m21, :m12)
    swap(:m31, :m13)
    swap(:m32, :m23)
    build_schema
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
    build_schema
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
    build_schema
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
  
  def add other
    applyBinaryComponentwise(:+, other)
  end
  
  def sub other
    applyBinaryComponentwise(:-, other)
  end
  
  def same_values_as? other
    predicat = true
    (1..4).each do |idx|
      predicat &&= other.row(idx).same_values_as?(self.row(idx))
    end
    predicat
  end
  
  # scale every element of this matrix by given value
  def scale by
    (1..4).each do |i|
      (1..4).each do |j|
        val = elementAt(i,j)*by
        setElementAt(i, j, val) 
      end
    end
    build_schema  
  end
  
  # explicit inverse for a 4x4 matrix
  def invert
    values = []
    unless is_singular?
      # compute elementwise inverses
      
      # b11 to b14
      values << at(2,2)*at(3,3)*at(4,4) + at(2,3)*at(3,4)*at(4,2) + at(2,4)*at(3,2)*at(4,3) - at(2,2)*at(3,4)*at(4,3) - at(2,3)*at(3,2)*at(4,4) - at(2,4)*at(3,3)*at(4,2)
      values << at(1,2)*at(3,4)*at(4,3) + at(1,3)*at(3,2)*at(4,4) + at(1,4)*at(3,3)*at(4,2) - at(1,2)*at(3,3)*at(4,4) - at(1,3)*at(3,4)*at(4,2) - at(1,4)*at(3,2)*at(4,3)
      values << at(1,2)*at(2,3)*at(4,4) + at(1,3)*at(2,4)*at(4,2) + at(1,4)*at(2,2)*at(4,3) - at(1,2)*at(2,4)*at(4,3) - at(1,3)*at(2,2)*at(4,4) - at(1,4)*at(2,3)*at(4,2)
      values << at(1,2)*at(2,4)*at(3,3) + at(1,3)*at(2,2)*at(3,4) + at(1,4)*at(2,3)*at(3,2) - at(1,2)*at(2,3)*at(3,4) - at(1,3)*at(2,4)*at(3,2) - at(1,4)*at(2,2)*at(3,3)
      
      # b21 to b24
      values << at(2,1)*at(3,4)*at(4,3) + at(2,3)*at(3,1)*at(4,4) + at(2,4)*at(3,3)*at(4,1) - at(2,1)*at(3,3)*at(4,4) - at(2,3)*at(3,4)*at(4,1) - at(2,4)*at(3,1)*at(4,3)
      values << at(1,1)*at(3,3)*at(4,4) + at(1,3)*at(3,4)*at(4,1) + at(1,4)*at(3,1)*at(4,3) - at(1,1)*at(3,4)*at(4,3) - at(1,3)*at(3,1)*at(4,4) - at(1,4)*at(3,3)*at(4,1)
      values << at(1,1)*at(2,4)*at(4,3) + at(1,3)*at(2,1)*at(4,4) + at(1,4)*at(2,3)*at(4,1) - at(1,1)*at(2,3)*at(4,4) - at(1,3)*at(2,4)*at(4,1) - at(1,4)*at(2,1)*at(4,3)
      values << at(1,1)*at(2,3)*at(3,4) + at(1,3)*at(2,4)*at(3,1) + at(1,4)*at(2,1)*at(3,3) - at(1,1)*at(2,4)*at(3,3) - at(1,3)*at(2,1)*at(3,4) - at(1,4)*at(2,3)*at(3,1)
      
      # b31 to b34
      values << at(2,1)*at(3,2)*at(4,4) + at(2,2)*at(3,4)*at(4,1) + at(2,4)*at(3,1)*at(4,2) - at(2,1)*at(3,4)*at(4,2) - at(2,2)*at(3,1)*at(4,4) - at(2,4)*at(3,2)*at(4,1)
      values << at(1,1)*at(3,4)*at(4,2) + at(1,2)*at(3,1)*at(4,4) + at(1,4)*at(3,2)*at(4,1) - at(1,1)*at(3,2)*at(4,4) - at(1,2)*at(3,4)*at(4,1) - at(1,4)*at(3,1)*at(4,2)
      values << at(1,1)*at(2,2)*at(4,4) + at(1,2)*at(2,4)*at(4,1) + at(1,4)*at(2,1)*at(4,2) - at(1,1)*at(2,4)*at(4,2) - at(1,2)*at(2,1)*at(4,4) - at(1,4)*at(2,2)*at(4,1)
      values << at(1,1)*at(2,4)*at(3,2) + at(1,2)*at(2,1)*at(3,4) + at(1,4)*at(2,2)*at(3,1) - at(1,1)*at(2,2)*at(3,4) - at(1,2)*at(2,4)*at(3,1) - at(1,4)*at(2,1)*at(3,2)
      
      # b41 to b44
      values << at(2,1)*at(3,3)*at(4,2) + at(2,2)*at(3,1)*at(4,3) + at(2,3)*at(3,2)*at(4,1) - at(2,1)*at(3,2)*at(4,3) - at(2,2)*at(3,3)*at(4,1) - at(2,3)*at(3,1)*at(4,2)
      values << at(1,1)*at(3,2)*at(4,3) + at(1,2)*at(3,3)*at(4,1) + at(1,3)*at(3,1)*at(4,2) - at(1,1)*at(3,3)*at(4,2) - at(1,2)*at(3,1)*at(4,3) - at(1,3)*at(3,2)*at(4,1)
      values << at(1,1)*at(2,3)*at(4,2) + at(1,2)*at(2,1)*at(4,3) + at(1,3)*at(2,2)*at(4,1) - at(1,1)*at(2,2)*at(4,3) - at(1,2)*at(2,3)*at(4,1) - at(1,3)*at(2,1)*at(4,2)
      values << at(1,1)*at(2,2)*at(3,3) + at(1,2)*at(2,3)*at(3,1) + at(1,3)*at(2,1)*at(3,2) - at(1,1)*at(2,3)*at(3,2) - at(1,2)*at(2,1)*at(3,3) - at(1,3)*at(2,2)*at(3,1)
      
      counter = 0
      (1..4).each do |i|
        (1..4).each do |j|
          setElementAt(j,i, values[counter])
          counter += 1
        end
      end  
      
      build_schema
      scale((1.0/det.to_f))
    end
    
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
    build_schema
  end
  
  def swap(a, b)  
    tmp = send("#{a}")
    send("#{a}=",send("#{b}"))
    send("#{b}=",tmp)
  end
  
  def build_schema
    @schema = [    
    [@m00, @m01, @m02, @m03],
    [@m10, @m11, @m12, @m13],
    [@m20, @m21, @m22, @m23],
    [@m30, @m31, @m32, @m33]]
    self
  end
  
  alias_method :at, :elementAt
end