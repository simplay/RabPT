require_relative '../util/optics.rb'
require_relative '../util/calculus/algebra/vector3f.rb'
require 'pry'

describe Optics do
  describe "when performing reflective geometry operation" do
    
    it "should provide a #reflection querry" do
      (Optics.respond_to? :reflection).should be_true
    end
    
    describe "for positive orthogonal normal on plane xy plane" do
      it "should return reflection equal to negated incident direction" do
        w_in = Vector3f.new(4.0, 0.0, 0.0)
        w_in.scale(Random.rand(1.0))
        normal = Vector3f.new(0.0, 0.0, 1.0)
        w_out = Optics.reflection(normal, w_in)
        w_out.same_values_as?(w_in.s_copy.negate).should be_true
      end
    end
  end
  
end