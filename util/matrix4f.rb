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
  
  def add other
    applyBinaryComponentwise(:+, other)
  end
  
  def sub other
    applyBinaryComponentwise(:-, other)
  end
  
  
  private
  
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