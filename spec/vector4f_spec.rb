require_relative 'spec_helper'

describe Vector4f do
  let(:v1) { Vector4f.new(1.0, 2.0, 4.0, 1.0) }
  let(:v1_orig) { Vector4f.new(1.0, 2.0, 4.0, 1.0) }
  let(:v2) { Vector4f.new(3.0, 2.0, 1.0, 1.0) }
  let(:zero) { Vector4f.new(0.0, 0.0, 0.0, 0.0) }
  let(:one) { Vector4f.new(1.0, 1.0, 1.0, 1.0) }
  let(:one_norm) { Vector4f.new(0.5, 0.5, 0.5, 0.5) }

  it "Im myself id==id" do
    expect(v1).to eq(v1)
  end

  it "eigensubstraction is zero" do
    v1.sub(v1)
    expect(v1).to eq(zero)
  end

  it "eigensubstraction and then adding me gives id" do
    v1.sub(v1).add(v1)
    expect(v1).to eq(v1)
  end

  it "an eigenaddition is the same as scaling by factor two" do
    v1.add(v1)
    expect(v1).to eq(v1_orig.scale(2.0))
  end

  it "v1 plus v2 is (4,4,5,2)" do
    v1_plus_v2 = Vector4f.new(4.0, 4.0, 5.0, 2.0)
    v1.add(v2)
    expect(v1).to eq(v1_plus_v2)
  end

  it "v1 minus v2 is (-2,0,3,0)" do
    v1_minus_v2 = Vector4f.new(-2.0, 0.0, 3.0, 0.0)
    v1.sub(v2)
    expect(v1).to eq(v1_minus_v2)
  end

  it "normalized vector has unit length" do
    one.normalize
    expect(one.length).to eq(1.0)
  end

  it "length and norm_2 applied on self are the same" do
    expect(one.length).to eq(one.norm_2(one))
  end

  it "v1 dot v2 yields expected value 12" do
    expect(v1.dot(v2)).to eq(12.0)
  end

  it "dot product is commulative" do
    expect(v1.dot(v2)).to eq(v2.dot(v1))
  end

  it "cross operator works as expected" do
    a = Vector3f.new(2.0, 3.0, 4.0)
    b = Vector3f.new(5.0, 6.0, 7.0)
    a_cross_b = Vector3f.new(-3.0, 6.0, -3.0)
    expect(a.cross(b)).to eq(a_cross_b)
  end

  it "cross a,b == -cross b,a" do
    a = Vector3f.new(2.0, 3.0, 4.0)
    b = Vector3f.new(5.0, 6.0, 7.0)
    a_cross_b = Vector3f.new(-3.0, 6.0, -3.0)
    expect(b.cross(a)).to eq(a_cross_b.negate)
  end

  it "cross product gives an ortogonal vector" do
    a = Vector3f.new(2.0, 3.0, 4.0)
    b = Vector3f.new(5.0, 6.0, 7.0)
    c = b.cross(a)
    expect(c.dot(a)).to eq(0.0)
    expect(c.dot(b)).to eq(0.0)
  end

  it "should pefrom a propper shallow copy" do
    a = Vector4f.new(5.0, 6.0, 7.0, -13.0)
    b = a.s_copy
    expect(b).not_to be(a)
    expect(b).to eq(a)
  end

  it "negate should work as expected" do
    v = Vector3f.new(-1, 2, -3.4)
    expect(v.negate).to eq(Vector3f.new(1, -2, 3.4))
  end

  it "dotted works as expected" do
    v = Vector3f.new(2.0, 3.0, 4.0)
    # v.dotted = 2^2 + 3^2 + 4^2 =  4 + 9 + 16
    expect(v.dotted).to eq(29.0)
  end
end
