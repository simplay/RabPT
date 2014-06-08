require_relative '../util/matrix4f.rb'

describe Matrix4f do
  before(:each) do
    @v1r = Vector4f.new(1.0, 2.0, 3.0, 4.0)
    @v2r = Vector4f.new(5.0, 6.0, 7.0, 8.0)
    @v3r = Vector4f.new(9.0, 10.0, 11.0, 12.0)
    @v4r = Vector4f.new(13.0, 14.0, 15.0, 16.0)
    
    @v1c = Vector4f.new(1.0, 5.0, 9.0, 13.0)
    @v2c = Vector4f.new(2.0, 6.0, 10.0, 14.0)
    @v3c = Vector4f.new(3.0, 7.0, 11.0, 15.0)
    @v4c = Vector4f.new(4.0, 8.0, 12.0, 16.0)
    
    @M1 = Matrix4f.new(@v1r, @v2r, @v3r, @v4r)
    
    v1 = Vector4f.new(1.0, 3.0, 2.0, 4.0)
    v2 = Vector4f.new(5.0, 8.0, 7.0, 6.0)
    v3 = Vector4f.new(10.0, 12.0, 11.0, 9.0)
    v4 = Vector4f.new(13.0, 14.0, 15.0, 16.0)
    @M2 = Matrix4f.new(v1, v2, v3, v4)
    
    v1 = Vector4f.new(1.0, 3.0, 2.0, 4.0)
    v2 = Vector4f.new(5.0, 8.0, 7.0, 6.0)
    v3 = Vector4f.new(10.0, 12.0, 11.0, 9.0)
    v4 = Vector4f.new(13.0, 14.0, 15.0, 16.0)
    @M2copy = Matrix4f.new(v1, v2, v3, v4)
    
    v1 = Vector4f.new(1.0, 0.0, 0.0, 0.0)
    v2 = Vector4f.new(0.0, 1.0, 0.0, 0.0)
    v3 = Vector4f.new(0.0, 0.0, 1.0, 0.0)
    v4 = Vector4f.new(0.0, 0.0, 0.0, 1.0)
    @I = Matrix4f.new(v1, v2, v3, v4)
    
    v1 = Vector4f.new(2.0, 4.0, 6.0, 8.0)
    v2 = Vector4f.new(10.0, 12.0, 14.0, 16.0)
    v3 = Vector4f.new(18.0, 20.0, 22.0, 24.0)
    v4 = Vector4f.new(26.0, 28.0, 30.0, 32.0)
    @twoM1 = Matrix4f.new(v1, v2, v3, v4)
    
    v1 = Vector4f.new(0.0, 0.0, 0.0, 0.0)
    v2 = Vector4f.new(0.0, 0.0, 0.0, 0.0)
    v3 = Vector4f.new(0.0, 0.0, 0.0, 0.0)
    v4 = Vector4f.new(0.0, 0.0, 0.0, 0.0)
    @Z = Matrix4f.new(v1, v2, v3, v4)
    
    v1 = Vector4f.new(1.0, 0.0, 0.0, 1.0)
    v2 = Vector4f.new(0.0, 1.0, 0.0, 2.0)
    v3 = Vector4f.new(0.0, 0.0, 1.0, 3.0)
    v4 = Vector4f.new(0.0, 0.0, 0.0, 1.0)
    @T = Matrix4f.new(v1, v2, v3, v4)
    @Tcopy = Matrix4f.new(v1, v2, v3, v4)
    
    v1 = Vector4f.new(1.0, 0.0, 0.0, 0.0)
    v2 = Vector4f.new(0.0, 1.0, 0.0, 0.0)
    v3 = Vector4f.new(0.0, 0.0, 1.0, 0.0)
    v4 = Vector4f.new(1.0, 2.0, 3.0, 1.0)
    @Tt = Matrix4f.new(v1, v2, v3, v4)
    
    v1 = Vector4f.new(1.0, 2.0, 3.0, 4.0)
    v2 = Vector4f.new(5.0, 6.0, 7.0, 8.0)
    v3 = Vector4f.new(9.0, 10.0, 11.0, 12.0)
    v4 = Vector4f.new(13.0, 14.0, 15.0, 16.0)
    @Enum = Matrix4f.new(v1, v2, v3, v4)
    
    v1 = Vector4f.new(93.0, 111.0, 109.0, 107.0)
    v2 = Vector4f.new(209.0, 259.0, 249.0, 247.0)
    v3 = Vector4f.new(325.0, 407.0, 389.0, 387.0)
    v4 = Vector4f.new(441.0, 555.0, 529.0, 527.0)
    @EnumTimesM2 = Matrix4f.new(v1, v2, v3, v4)
    
    
  end
  
  it "Im myself id==id" do
    @M2.same_values_as?(@M2).should be_true
  end
  
  it "Im myself and no one else" do
    @M2.same_values_as?(@M1).should_not be_true
  end
  
  it "transposing T gives Tt" do
    @T.transpose.same_values_as?(@Tt).should be_true
  end
  
  it "transposing T gives not T" do
    @T.transpose.same_values_as?(@Tcopy).should_not be_true
  end
  
  it "row getter work as they are supposed to" do
    predicat = true
    rows = [@v1r, @v2r, @v3r, @v4r]
    (1..4).each do |idx|
      predicat &&= @M1.row(idx).same_values_as?(rows[idx-1])
    end
    predicat.should be_true
  end
  
  it "row getter work as they are supposed to" do
    predicat = true
    columns = [@v1c, @v2c, @v3c, @v4c]
    (1..4).each do |idx|
      predicat &&= @M1.column(idx).same_values_as?(columns[idx-1])
    end
    predicat.should be_true
  end
  
  it "#elementAt getter work as they are supposed to" do
    predicat = true
    counter = 1
    columns = [@v1c, @v2c, @v3c, @v4c]
    (1..4).each do |i|
      (1..4).each do |j|
        predicat &&= (@Enum.elementAt(i,j)== counter)
        counter += 1
      end
    end
    predicat.should be_true
  end
  
  it "#elementAt getter work as they are supposed to (sanity check)" do
    predicat = true
    counter = 0
    columns = [@v1c, @v2c, @v3c, @v4c]
    (1..4).each do |i|
      (1..4).each do |j|
        predicat &&= (@Enum.elementAt(i,j)== counter)
        counter += 1
      end
    end
    predicat.should_not be_true
  end
  
  it "Enum times M2 gives expected result EnumTimesM2" do
    @Enum.mult(@M2).same_values_as?(@EnumTimesM2).should be_true
  end
  
  it "@Enum times v1c gives expected result" do
    v1 = Vector4f.new(1.0, 2.0, 3.0, 4.0)
    res = Vector4f.new(30.0, 70.0, 110.0, 150.0)
    @Enum.vectormult(v1).same_values_as?(res).should be_true
  end
  
  it "Eigenaddition is twice the matrix" do
    @M1.add(@M1).same_values_as?(@twoM1).should be_true
  end
  
  it "Eigensubtraction is zerp" do
    @M1.sub(@M1).same_values_as?(@Z).should be_true
  end
  
  it "det identity matrix is 1" do
    @I.det.should eq(1.0)
  end
  
  it "det zero matrix is 0" do
    @Z.det.should eq(0.0)
  end
  
  it "det homogeneous translation is 1" do
    @T.det.should eq(1.0)
  end
  
  it "det should be correct calculated" do
    v1 = Vector4f.new(5.0, 0.0, 3.0, -1.0)
    v2 = Vector4f.new(3.0, 0.0, 0.0, 4.0)
    v3 = Vector4f.new(-1.0, 2.0, 4.0, -2.0)
    v4 = Vector4f.new(1.0, 0.0, 0.0, 5.0)
    A = Matrix4f.new(v1, v2, v3, v4)
    A.det.should eq(66.0)
  end
  
  it "me times inverse is identity" do
    # binding.pry
    @M2.invert.mult(@M2copy).same_values_as?(@I).should be_true
  end
  
  it "permutation matrix has |det| = 1" do
    @M2.get_p_matrix.det.abs.should eq(1.0)
  end
  
  it "L matrix has ones in its diagonal" do
    l = @M2.get_l_matrix
    (1..4).each do |d|
      l_diag = l.at(d,d)
      l_diag.should eq(1.0)
    end
  end
  
  
  
end