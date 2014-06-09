require_relative '../src/intersectables/csg_plane.rb'
require_relative '../util/vector3f.rb'
require "pry"

describe CsgPlane do
  it "can be successfully created" do
    binding.pry
    hash = {:distance => 1.0,
            :normal => Vector3f.new(1.0, 0.0, 0.0)}
    
    CsgPlane.new hash
  end
end