require_relative 'spec_helper'

describe Plane do
  before(:each) do
    @plane = Plane.new(nil, Vector3f.new(1.0, 0.0, 0.0), 1.0)
  end

  it "can be intersected" do
    (@plane.respond_to? :intersect).should be_true
  end

  it "can querry #bounding_box" do
    (@plane.respond_to? :bounding_box).should be_true
  end
end
