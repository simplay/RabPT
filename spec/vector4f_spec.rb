require_relative 'spec_helper'

describe Vector4f do
  let(:v1) { Vector4f.new(1.0, 2.0, 4.0, 1.0) }
  let(:v1_orig) { Vector4f.new(1.0, 2.0, 4.0, 1.0) }
  let(:v2) { Vector4f.new(3.0, 2.0, 1.0, 1.0) }
  let(:zero) { Vector4f.new(0.0, 0.0, 0.0, 0.0) }
  let(:one) { Vector4f.new(1.0, 1.0, 1.0, 1.0) }
  let(:one_norm) { Vector4f.new(0.5, 0.5, 0.5, 0.5) }

  it "Im myself id==id" do
    v1.same_values_as?(v1).should be_true
  end

  it "eigensubstraction is zero" do
    v1.sub(v1)
    v1.same_values_as?(zero).should be_true
  end

  it "eigensubstraction and then adding me gives id" do
    v1.sub(v1).add(v1)
    v1.same_values_as?(v1).should be_true
  end

  it "an eigenaddition is the same as scaling by factor two" do
    v1.add(v1)
    v1.same_values_as?(v1_orig.scale(2.0)).should be_true
  end

  it "eigenaddition is only doubled value and nothing else" do
    v1.add(v1)
    f = (Random.rand(100)+2).to_f
    v1.same_values_as?(v1_orig.scale(f)).should_not be_true
  end

  it "v1 plus v2 is (4,4,5,2)" do
    v1_plus_v2 = Vector4f.new(4.0, 4.0, 5.0, 2.0)
    v1.add(v2)
    v1.same_values_as?(v1_plus_v2).should be_true
  end

  it "v1 minus v2 is (-2,0,3,0)" do
    v1_minus_v2 = Vector4f.new(-2.0, 0.0, 3.0, 0.0)
    v1.sub(v2)
    v1.same_values_as?(v1_minus_v2).should be_true
  end

  it "one vector should be normalized to one_norm" do
    one.normalize
    one.same_values_as?(one_norm).should be_true
  end

  it "normalized vector has unit length" do
    one.normalize
    one.length.should eq(1.0)
  end

  it "length and norm_2 applied on self are the same" do
    one.length.should eq(one.norm_2(one))
  end

  it "v1 dot v2 yields expected value 12" do
    v1.dot(v2).should eq(12.0)
  end

  it "v1 dot v2 yields expected value 12" do
    v1.dot(v2).should eq(12.0)
  end

  it "dot product is commulative" do
    v1.dot(v2).should eq(v2.dot(v1))
  end

  it "cross operator works as expected" do
    a = Vector3f.new(2.0, 3.0, 4.0)
    b = Vector3f.new(5.0, 6.0, 7.0)
    a_cross_b = Vector3f.new(-3.0, 6.0, -3.0)
    a.cross(b).same_values_as?(a_cross_b).should be_true
  end

  it "cross operator is not commulative" do
    a = Vector3f.new(2.0, 3.0, 4.0)
    b = Vector3f.new(5.0, 6.0, 7.0)
    a_cross_b = Vector3f.new(-3.0, 6.0, -3.0)
    b.cross(a).same_values_as?(a_cross_b).should_not be_true
  end

  it "cross a,b == -cross b,a" do
    a = Vector3f.new(2.0, 3.0, 4.0)
    b = Vector3f.new(5.0, 6.0, 7.0)
    a_cross_b = Vector3f.new(-3.0, 6.0, -3.0)
    b.cross(a).same_values_as?(a_cross_b.scale(-1.0)).should be_true
  end

  it "cross product gives an ortogonal vector" do
    a = Vector3f.new(2.0, 3.0, 4.0)
    b = Vector3f.new(5.0, 6.0, 7.0)
    c = b.cross(a)
    c.dot(a).should eq(0.0)
    c.dot(b).should eq(0.0)
  end

  it "should pefrom a propper shallow copy" do
    a = Vector4f.new(5.0, 6.0, 7.0, -13.0)
    c = Vector3f.new(5.0, 6.0, 7.0)
    b = a.s_copy
    d = c.s_copy
    expression = (a != b) && a.same_values_as?(b)
    expression &&= (c != d) && c.same_values_as?(d)
    expression.should be_true
  end

  it "to_a should work properly" do
    v = Vector3f.new(-0.01452, 2.22, 3.4)
    v_toaed = v.to_a
    expr = (v_toaed[0] == v.x) && (v_toaed[1] == v.y) && (v_toaed[2] == v.z)
    expr.should be_true
  end

  it "to_s should work properly" do
    v = Vector3f.new(-0.01452, 2.22, 3.4)
    # from code "(#{@x},#{@y},#{@z})"
    expr = "(-0.01452,2.22,3.4)".eql?(v.to_s)
    expr.should be_true
  end

  it "negate should work as expected" do
    v = Vector3f.new(-0.01452, 2.22, -3.4)
    v.negate
    expr = (v.x == 0.01452) && (v.y == -2.22) && (v.z == 3.4)
    expr.should be_true
  end

  it "approx same as should work as expected" do
    v = Vector3f.new(-0.01452, 2.22, -3.4)
    a = Vector3f.new(-0.0145, 2.22, -3.401)
    expr = !v.same_values_as?(a) && v.approx_same_values_as?(a)
    expr.should be_true
  end

  it "approx same is a symmetric relation" do
    v = Vector3f.new(-0.01452, 2.22, -3.4)
    a = Vector3f.new(-0.0145, 2.22, -3.401)
    expr = v.approx_same_values_as?(a) && a.approx_same_values_as?(v)
    expr.should be_true
  end

  it "dotted works as expected" do
    v = Vector3f.new(2.0, 3.0, 4.0)
    # v.dotted = 2^2 + 3^2 + 4^2 =  4 + 9 + 16
    v.dotted.should eq(29.0)
  end

  it "im approximitely the same as myself" do
    v = Vector3f.new(-0.01452, 2.22, -3.4)
    v.approx_same_values_as?(v).should be_true
  end

  it "Vector3f should be extendable to a Vector4f" do
    target = Vector4f.new(1.0, 2.0, 3.0, 4.0)
    us = Vector3f.new(1.0, 2.0, 3.0)
    us.to_vec4f(4.0).same_values_as?(target).should be_true
    us.to_vec4f().same_values_as?(target).should be_false
    us.to_vec4f(0.0).same_values_as?(target).should be_false
  end

  it "default value for extended Vector3f (to Vector4f) should 0.0" do
    us = Vector3f.new(1.0, 2.0, 3.0)
    (us.to_vec4f().w == 0.0).should be_true
  end

  it "to_vec3f for vec4f works as expected" do
    target = Vector4f.new(1.0, 2.0, 3.0, 4.0)
    us = Vector3f.new(1.0, 2.0, 3.0)
    target.to_vec3f().same_values_as?(us).should be_true
  end
end
