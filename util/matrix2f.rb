class Matrix2f
  attr_accessor :schema,
                :m00, :m01,
                :m10, :m11
                
  def initialize(a11, a12, a21, a22)
    @m00 = a11; @m01 = a12;
    @m10 = a21; @m11 = a22;
    build_schema
  end
  
  def det
    @m00*@m11 - @m01*@m10
  end
  
  private 
  
  def build_schema
    @schema = [    
    [@m00, @m01],
    [@m10, @m11]]
    self
  end
end