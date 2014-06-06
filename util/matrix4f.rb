class Matrix4f
  require File.join(File.dirname(__FILE__), 'vector4f.rb')
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
  end
  
  # get val of (i,j) element of this matrix
  def elementAt(i, j) 
    send("m#{i-1}#{j-1}")
  end
  
  # assumption: dimensions match
  # perfroms a matrix4f matrix4f multiplication
  def mult other
    (1..4).each do |i|
      (1..4).each do |j|
        val = row(i).dot(other.column(j))
        setElementAt(i,j, val)
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
  
end