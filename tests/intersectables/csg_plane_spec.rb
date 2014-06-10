require_relative '../src/intersectables/csg_plane.rb'
require_relative '../util/vector3f.rb'
require "pry"

describe CsgPlane do
  before(:each) do
    hash = {:distance => 1.0,
            :normal => Vector3f.new(1.0, 0.0, 0.0)}
    @plane = CsgPlane.new hash
  end
  
  it "can be intersected" do
    (@plane.respond_to? :intersect).should be_true
  end
  
  it "can have #boundary_type" do
    (@plane.respond_to? :boundary_type).should be_true
  end
  
  it "can querry #bounding_box" do
    (@plane.respond_to? :bounding_box).should be_true
  end
  
  it "has implemented #interval_boundaries" do
    (@plane.respond_to? :interval_boundaries).should be_true
    lambda { @plane.interval_boundaries(nil) }.should_not raise_error
  end
end