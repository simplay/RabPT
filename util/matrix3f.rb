class Matrix3f
  require File.join(File.dirname(__FILE__), 'vector3f.rb')

  
  attr_accessor :schema,
                :m00, :m01, :m02,
                :m10, :m11, :m12,
                :m20, :m21, :m22
                
  def initialize(row_x, row_y, row_z)
    @m00 = row_x.x; @m01 = row_x.y; @m02 = row_x.z;
    @m10 = row_y.x; @m11 = row_y.y; @m12 = row_y.z;
    @m20 = row_z.x; @m21 = row_z.y; @m22 = row_z.z;
    build_schema
  end
  
  def transpose
    swap(:m10, :m01)
    swap(:m02, :m20)
    swap(:m21, :m12)
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
  def element_at(i, j) 
    send("m#{i-1}#{j-1}")
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
    build_schema
  end
  
  # assumption vec4f is a column vector
  # performs a matrix3f vector3f multiplaction
  def vectormult vec3f
    values = []
    (1..3).each do |i|
      values << row(i).dot(vec3f)
    end
    Vector3f.new(values[0], values[1], values[2])
  end
  
  def add other
    applyBinaryComponentwise(:+, other)
  end
  
  def sub other
    applyBinaryComponentwise(:-, other)
  end
  
  def same_values_as? other
    predicat = true
    (1..3).each do |idx|
      predicat &&= other.row(idx).same_values_as?(self.row(idx))
    end
    predicat
  end
  
  def invert
    values = []
    
  end
  
  def det
    a1 = at(1,1)*at(2,2)*at(3,3)
    a2 = at(1,2)*at(2,3)*at(3,1)
    a3 = at(1,3)*at(2,1)*at(3,2)
    
    b1 = at(1,1)*at(2,3)*at(3,2)
    b2 = at(1,2)*at(2,1)*at(3,3)
    b3 = at(1,3)*at(2,2)*at(3,1)
    
    (a1+a2+a3)+(-1*(b1+b2+b3))
  end
  
  def is_singular?
    (det == 0)
  end
  
  private
  
  def entry_parser at 
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

    build_schema
  end
  
  def swap(a, b)  
    tmp = send("#{a}")
    send("#{a}=",send("#{b}"))
    send("#{b}=",tmp)
  end
  
  def build_schema
    @schema = [    
    [@m00, @m01, @m02],
    [@m10, @m11, @m12],
    [@m20, @m21, @m22]]
    self
  end
  
  alias :at :element_at 
end