require_relative 'spec_helper'

describe OneSampler do
  before(:each) do
    @one_sampler = OneSampler.new
  end

  it "has implemented #make_samples" do
    (@one_sampler.respond_to? :make_samples).should be_true
    lambda { @one_sampler.make_samples(1, 2) }.should_not raise_error
  end

  it "should always create one row containing n samples" do
    n = Random.rand(1000) + 1
    d = Random.rand(1000) + 1
    samples = @one_sampler.make_samples(d, n)
    samples.count.should eq(1)
    samples.first.count.should eq(n)
  end

  it "all samples should be equal 0.5" do
    n = Random.rand(1000) + 1
    samples = @one_sampler.make_samples(1, n)
    expr = samples.first.inject(true) {|expression, item| expression &= item.eql?(0.5)}
    expr.should be_true
    expr = samples.first.inject(true) {|expression, item| expression &= !item.eql?(0.5)}
    expr.should_not be_true
  end
end
