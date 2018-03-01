require_relative 'spec_helper'

describe Matrix4f do
  before(:each) do
    @matrix1 = Matrix4f.new(
      Vector4f.new(1.0, 2.0, 3.0, 4.0),
      Vector4f.new(5.0, 6.0, 7.0, 8.0),
      Vector4f.new(9.0, 10.0, 11.0, 12.0),
      Vector4f.new(13.0, 14.0, 15.0, 16.0)
    )

    @matrix2 = Matrix4f.new(
      Vector4f.new(1.0, 3.0, 2.0, 4.0),
      Vector4f.new(5.0, 8.0, 7.0, 6.0),
      Vector4f.new(10.0, 12.0, 11.0, 9.0),
      Vector4f.new(13.0, 14.0, 15.0, 16.0)
    )

    @identity = Matrix4f.new(
      Vector4f.new(1.0, 0.0, 0.0, 0.0),
      Vector4f.new(0.0, 1.0, 0.0, 0.0),
      Vector4f.new(0.0, 0.0, 1.0, 0.0),
      Vector4f.new(0.0, 0.0, 0.0, 1.0)
    )

    @zero = Matrix4f.new(
      Vector4f.new(0.0, 0.0, 0.0, 0.0),
      Vector4f.new(0.0, 0.0, 0.0, 0.0),
      Vector4f.new(0.0, 0.0, 0.0, 0.0),
      Vector4f.new(0.0, 0.0, 0.0, 0.0)
    )

    @matrix3 = Matrix4f.new(
      Vector4f.new(1.0, 0.0, 0.0, 1.0),
      Vector4f.new(0.0, 1.0, 0.0, 2.0),
      Vector4f.new(0.0, 0.0, 1.0, 3.0),
      Vector4f.new(0.0, 0.0, 0.0, 1.0)
    )

    @matrix4 = Matrix4f.new(
      Vector4f.new(1.0, 2.0, 3.0, 4.0),
      Vector4f.new(5.0, 6.0, 7.0, 8.0),
      Vector4f.new(9.0, 10.0, 11.0, 12.0),
      Vector4f.new(13.0, 14.0, 15.0, 16.0)
    )
  end

  it "can compare by its components" do
    expect(@matrix2).not_to eq(@matrix1)
    expect(@matrix1).to eq(@matrix1)
  end

  it "can transpose a matrix" do
    matrix3_transposed = Matrix4f.new(
      Vector4f.new(1.0, 0.0, 0.0, 0.0),
      Vector4f.new(0.0, 1.0, 0.0, 0.0),
      Vector4f.new(0.0, 0.0, 1.0, 0.0),
      Vector4f.new(1.0, 2.0, 3.0, 1.0)
    )
    expect(@matrix3.transpose).to eq(matrix3_transposed)
  end

  it "can peform a matrix multiplication" do
    v1 = Vector4f.new(93.0, 111.0, 109.0, 107.0)
    v2 = Vector4f.new(209.0, 259.0, 249.0, 247.0)
    v3 = Vector4f.new(325.0, 407.0, 389.0, 387.0)
    v4 = Vector4f.new(441.0, 555.0, 529.0, 527.0)
    result = Matrix4f.new(v1, v2, v3, v4)
    expect(@matrix4.mult(@matrix2)).to eq(result)
  end

  it "can perform a matrix vector multiplication" do
    v1 = Vector4f.new(1.0, 2.0, 3.0, 4.0)
    res = Vector4f.new(30.0, 70.0, 110.0, 150.0)
    expect(@matrix4.vectormult(v1)).to eq(res)
  end

  it "can perform a matrix addition" do
    m = Matrix4f.new(
      Vector4f.new(2.0, 4.0, 6.0, 8.0),
      Vector4f.new(10.0, 12.0, 14.0, 16.0),
      Vector4f.new(18.0, 20.0, 22.0, 24.0),
      Vector4f.new(26.0, 28.0, 30.0, 32.0)
    )
    expect(@matrix1.add(@matrix1)).to eq(m)
  end

  it "can perform a matrix subtraction" do
    expect(@matrix1.sub(@matrix1)).to eq(@zero)
  end

  it "can compute the determinant" do
    expect(@identity.det).to eq(1)
    expect(@zero.det).to eq(0)
    expect(@matrix3.det).to eq(1)

    v1 = Vector4f.new(5.0, 0.0, 3.0, -1.0)
    v2 = Vector4f.new(3.0, 0.0, 0.0, 4.0)
    v3 = Vector4f.new(-1.0, 2.0, 4.0, -2.0)
    v4 = Vector4f.new(1.0, 0.0, 0.0, 5.0)
    a = Matrix4f.new(v1, v2, v3, v4)
    expect(a.det).to eq(66.0)
  end

  it "can compute the inverse" do
    v1 = Vector4f.new(1.0, 3.0, 1.0, 1.0)
    v2 = Vector4f.new(2.0, 1.0, 5.0, 2.0)
    v3 = Vector4f.new(1.0, -1.0, 2.0, 3.0)
    v4 = Vector4f.new(4.0, 1.0, -3.0, 7.0)
    m1 = Matrix4f.new(v1, v2, v3, v4)
    m2 = Matrix4f.new(v1, v2, v3, v4)

    prod = m1.invert.mult(m2)
    expect(prod.sum).to be_within(0.0001).of(4)
  end

  it "can get translated" do
    expect(@identity.translate(Vector3f.new(1.0, 2.0, 3.0))).to eq(@matrix3)
  end

  it "can be rotated around x axis" do
    v1 = Vector4f.new(1.0, 0.0, 0.0, 0.0)
    v2 = Vector4f.new(0.0, -1.0, 0.0, 0.0)
    v3 = Vector4f.new(0.0, 0.0, -1.0, 0.0)
    v4 = Vector4f.new(0.0, 0.0, 0.0, 1.0)
    a = Matrix4f.new(v1, v2, v3, v4)
    @identity.rotate(180.0, :x)
    expect(@identity.sub(a).sum).to be_within(0.0001).of(0)
  end

  it "can be rotated around y axis" do
    v1 = Vector4f.new(-1.0, 0.0, 0.0, 0.0)
    v2 = Vector4f.new(0.0, 1.0, 0.0, 0.0)
    v3 = Vector4f.new(0.0, 0.0, -1.0, 0.0)
    v4 = Vector4f.new(0.0, 0.0, 0.0, 1.0)
    a = Matrix4f.new(v1, v2, v3, v4)
    @identity.rotate(180.0, :y)
    expect(@identity.sub(a).sum).to be_within(0.0001).of(0)
  end

  it "can be rotated around z axis" do
    v1 = Vector4f.new(-1.0, 0.0, 0.0, 0.0)
    v2 = Vector4f.new(0.0, -1.0, 0.0, 0.0)
    v3 = Vector4f.new(0.0, 0.0, 1.0, 0.0)
    v4 = Vector4f.new(0.0, 0.0, 0.0, 1.0)
    a = Matrix4f.new(v1, v2, v3, v4)
    @identity.rotate(180.0, :z)
    expect(@identity.sub(a).sum).to be_within(0.0001).of(0)
  end

  it "can set row values" do
    m = Matrix4f.new(nil,nil,nil,nil).make_identity
    m.set_at(1, 1, 2.0)
    m.set_at(1, 2, 3.0)
    m.set_at(1, 3, 4.0)
    m.set_at(1, 4, 5.0)
    @identity.set_row_at(1, Vector4f.new(2.0, 3.0, 4.0, 5.0))

    expect(@identity).to eq(m)
  end

  it "can set column values" do
    m = Matrix4f.new(nil,nil,nil,nil).make_identity
    m.set_at(1,1, 2.0)
    m.set_at(2,1, 3.0)
    m.set_at(3,1, 4.0)
    m.set_at(4,1, 5.0)

    @identity.set_column_at(1, Vector4f.new(2.0, 3.0, 4.0, 5.0))
    expect(@identity).to eq(m)
  end

  it "can generate the identity matrix" do
    expect(Matrix4f.identity).to eq(@identity)
  end
end
