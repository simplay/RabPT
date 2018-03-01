require_relative 'spec_helper'

describe Vector4f do
  let(:v1) { Vector4f.new(1.0, 2.0, 4.0, 1.0) }
  let(:v1_orig) { Vector4f.new(1.0, 2.0, 4.0, 1.0) }
  let(:v2) { Vector4f.new(3.0, 2.0, 1.0, 1.0) }
  let(:zero) { Vector4f.new(0.0, 0.0, 0.0, 0.0) }
  let(:one) { Vector4f.new(1.0, 1.0, 1.0, 1.0) }

  it "can be compared" do
    expect(v1).to eq(v1)
  end

  it "can perform substractions" do
    v1 = Vector4f.new(1.0, 2.0, 4.0, 1.0)
    v1.sub(v1)
    expect(v1).to eq(zero)

    v1 = Vector4f.new(1.0, 2.0, 4.0, 1.0)
    v1_minus_v2 = Vector4f.new(-2.0, 0.0, 3.0, 0.0)
    v1.sub(v2)
    expect(v1).to eq(v1_minus_v2)
  end

  it "can perform chained arithmetic operations" do
    v1.sub(v1).add(v1)
    expect(v1).to eq(v1)
  end

  it "can be scaled by scalars" do
    v1.add(v1)
    expect(v1).to eq(v1_orig.scale(2.0))
  end

  it "can perform additions" do
    v1_plus_v2 = Vector4f.new(4.0, 4.0, 5.0, 2.0)
    v1.add(v2)
    expect(v1).to eq(v1_plus_v2)
  end

  it "can be normalized" do
    one.normalize
    expect(one.length).to eq(1.0)
    expect(one.length).to eq(one.norm_2(one))
  end

  it "can compute the dot product" do
    expect(v1.dot(v2)).to eq(12.0)
    expect(v1.dot(v2)).to eq(v2.dot(v1))

    # v.dotted = 2^2 + 3^2 + 4^2 =  4 + 9 + 16
    v = Vector3f.new(2.0, 3.0, 4.0)
    expect(v.dotted).to eq(29.0)
  end

  it "can compute the cross product" do
    a = Vector3f.new(2.0, 3.0, 4.0)
    b = Vector3f.new(5.0, 6.0, 7.0)
    a_cross_b = Vector3f.new(-3.0, 6.0, -3.0)
    expect(a.cross(b)).to eq(a_cross_b)

    # cross a,b == -cross b,a
    a = Vector3f.new(2.0, 3.0, 4.0)
    b = Vector3f.new(5.0, 6.0, 7.0)
    a_cross_b = Vector3f.new(-3.0, 6.0, -3.0)
    expect(b.cross(a)).to eq(a_cross_b.negate)

    # cross product gives an ortogonal vector
    a = Vector3f.new(2.0, 3.0, 4.0)
    b = Vector3f.new(5.0, 6.0, 7.0)
    c = b.cross(a)
    expect(c.dot(a)).to eq(0.0)
    expect(c.dot(b)).to eq(0.0)
  end

  it "can be negated" do
    v = Vector3f.new(-1, 2, -3.4)
    expect(v.negate).to eq(Vector3f.new(1, -2, 3.4))
  end
end
