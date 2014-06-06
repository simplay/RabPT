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
  
  private
  
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
  end
  
end