require_relative 'spec_helper'

describe OneSampler do
  before(:all) do
    @one_sampler = OneSampler.new
  end

  it "should contain n smaples per row" do
    n = Random.rand(1000) + 1
    d = Random.rand(1000) + 1

    samples = @one_sampler.make_samples(d, n)
    expect(samples.count).to eq(1)
    expect(samples.first.count).to eq(n)
  end

  it "should only have samples equals 0.5" do
    n = Random.rand(1000) + 1
    samples = @one_sampler.make_samples(1, n)
    samples.flatten.each do |sample|
      expect(sample).to eq(0.5)
    end
  end
end
