require_relative 'spec_helper'

describe Optics do
  describe "A positive orthogonal normal on the xy plane" do
    it "should be reflected to the negated incident direction" do
      w_in = Vector3f.new(4.0, 0.0, 0.0)
      w_in.scale(Random.rand(1.0))

      normal = Vector3f.new(0.0, 0.0, 1.0)
      w_out = Optics.reflection(normal, w_in)
      expect(w_out).to eq(w_in.s_copy.negate)
    end
  end
end
