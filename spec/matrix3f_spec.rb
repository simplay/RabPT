require_relative 'spec_helper'

describe Matrix3f do
  before(:each) do
    v1 = Vector3f.new(1.0, 0.0, 0.0)
    v2 = Vector3f.new(0.0, 1.0, 0.0)
    v3 = Vector3f.new(0.0, 0.0, 1.0)
    @identity_matrix = Matrix3f.new(v1, v2, v3)
  end

  it "can compute the determinat" do
    v1 = Vector3f.new(1.0, 0.0, 2.0)
    v2 = Vector3f.new(2.0, 1.0, 3.0)
    v3 = Vector3f.new(0.0, 3.0, 1.0)
    m = Matrix3f.new(v1, v2, v3)
    m_copy = Matrix3f.new(v1, v2, v3)
    expect(m.det).to eq(4)
  end

  it "can compute the adjugate" do
    v1 = Vector3f.new(1.0, 0.0, 2.0)
    v2 = Vector3f.new(2.0, 1.0, 3.0)
    v3 = Vector3f.new(0.0, 3.0, 1.0)
    m = Matrix3f.new(v1, v2, v3)

    v1 = Vector3f.new(-8.0, 6.0, -2.0)
    v2 = Vector3f.new(-2.0, 1.0, 1.0)
    v3 = Vector3f.new(6.0, -3.0, 1.0)
    m_adj = Matrix3f.new(v1, v2, v3)

    expect(m.adj).to eq(m_adj)
  end

  it "can be inverted" do
    v1 = Vector3f.new(1.0, 0.0, 2.0)
    v2 = Vector3f.new(2.0, 1.0, 3.0)
    v3 = Vector3f.new(0.0, 3.0, 1.0)
    m = Matrix3f.new(v1, v2, v3)
    m_copy = Matrix3f.new(v1, v2, v3)
    expect(m.invert.mult(m_copy)).to eq(@identity_matrix)
  end

  it "can generate the identity matrix" do
    expect(Matrix3f.identity).to eq(@identity_matrix)
  end
end
